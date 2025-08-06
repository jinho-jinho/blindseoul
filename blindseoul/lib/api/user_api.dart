import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/api_response.dart';
import '../model/error_response.dart';

class UserApi {
  final String _baseUrl = 'http://192.168.0.15:8080';

  /// 공통 에러 메시지 추출 및 ErrorResponse 파싱
  String _extractErrorMessage(http.Response response) {
    try {
      final json = jsonDecode(response.body);
      final error = ErrorResponse.fromJson(json);
      return error.message;
    } catch (_) {
      return response.body;
    }
  }

  /// 회원가입
  Future<int> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/user/signup');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final apiResponse = ApiResponse<int>.fromJson(
        json,
        (data) => data as int,
      );
      print('회원가입 성공: ${apiResponse.message}');
      return apiResponse.data;
    } else {
      throw Exception('회원가입 실패: ${_extractErrorMessage(response)}');
    }
  }

  /// 로그인
  Future<int> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$_baseUrl/user/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final apiResponse = ApiResponse<int>.fromJson(
        json,
        (data) => data as int,
      );
      print('로그인 성공 (userId): ${apiResponse.data}');
      return apiResponse.data;
    } else {
      throw Exception('로그인 실패: ${_extractErrorMessage(response)}');
    }
  }

  /// 이메일 인증번호 전송
  Future<void> sendVerificationCode(String email) async {
    final url = Uri.parse('$_baseUrl/api/auth/send-code?email=$email');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final apiResponse = ApiResponse<void>.fromJson(
        json,
        (_) => null,
      );
      print('인증번호 전송 성공: ${apiResponse.message}');
    } else {
      throw Exception('인증번호 전송 실패: ${_extractErrorMessage(response)}');
    }
  }

  /// 이메일 인증 확인
  Future<void> verifyCode(String email, String code) async {
    final url = Uri.parse('$_baseUrl/api/auth/verify-code?email=$email&code=$code');
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final apiResponse = ApiResponse<void>.fromJson(
        json,
        (_) => null,
      );
      print('이메일 인증 성공: ${apiResponse.message}');
    } else {
      throw Exception('이메일 인증 실패: ${_extractErrorMessage(response)}');
    }
  }
}
