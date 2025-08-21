// lib/api/user_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/api_response.dart';
import '../model/error_response.dart';
import '../model/user_response.dart';
import '../core/token_storage.dart';
import '../core/http_headers.dart';

class UserApi {
  final String _baseUrl = 'http://192.168.0.15:8080';

  String _extractErrorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      final error = ErrorResponse.fromJson(json);
      return error.message;
    } catch (_) {
      return response.body;
    }
  }

  Future<int> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/user/signup');
    final res = await http.post(
      url,
      headers: HttpHeadersHelper.json(),
      body: jsonEncode({'name': name, 'email': email, 'password': password}),
    );
    if (res.statusCode == 200) {
      final json = jsonDecode(res.body);
      final api = ApiResponse<int>.fromJson(json, (d) => d as int);
      return api.data;
    } else {
      throw Exception('회원가입 실패: ${_extractErrorMessage(res)}');
    }
  }

  /// 로그인 → accessToken 저장 (userId 반환 안함)
  Future<void> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/user/login');
    final res = await http.post(
      url,
      headers: HttpHeadersHelper.json(),
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      // { success, data: { accessToken, tokenType, expiresIn }, message }
      final api = ApiResponse<Map<String, dynamic>>.fromJson(
        map,
        (d) => d as Map<String, dynamic>,
      );
      final token = api.data['accessToken'] as String?;
      if (token == null || token.isEmpty) {
        throw Exception('로그인 응답에 토큰이 없습니다.');
      }
      await TokenStorage.save(token);
    } else {
      throw Exception('로그인 실패: ${_extractErrorMessage(res)}');
    }
  }

  /// 현재 사용자(토큰 기반) 조회
  Future<UserResponse> me() async {
    final url = Uri.parse('$_baseUrl/user/me');
    final res = await http.get(url, headers: await HttpHeadersHelper.authJson());

    if (res.statusCode == 200) {
      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final api = ApiResponse<UserResponse>.fromJson(
        map,
        (d) => UserResponse.fromJson(d as Map<String, dynamic>),
      );
      return api.data;
    } else {
      if (res.statusCode == 401) {
        await TokenStorage.clear(); // 토큰 무효/만료 시 정리
      }
      throw Exception('내 정보 조회 실패: ${_extractErrorMessage(res)}');
    }
  }

  Future<void> logout() async {
    await TokenStorage.clear();
  }

  // 이메일 인증 API는 그대로 사용
  Future<void> sendVerificationCode(String email) async {
    final url = Uri.parse('$_baseUrl/api/auth/send-code?email=$email');
    final res = await http.post(url, headers: HttpHeadersHelper.json());
    if (res.statusCode != 200) {
      throw Exception('인증번호 전송 실패: ${_extractErrorMessage(res)}');
    }
  }

  Future<void> verifyCode(String email, String code) async {
    final url = Uri.parse('$_baseUrl/api/auth/verify-code?email=$email&code=$code');
    final res = await http.post(url, headers: HttpHeadersHelper.json());
    if (res.statusCode != 200) {
      throw Exception('이메일 인증 실패: ${_extractErrorMessage(res)}');
    }
  }
}
