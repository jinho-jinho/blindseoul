import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  final String _baseUrl = 'http://192.168.0.15:8080';

  Future<void> signup({
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

    if (response.statusCode != 200) {
      throw Exception('회원가입 실패: ${response.body}');
    }
  }

  Future<void> login({
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

    if (response.statusCode != 200) {
      throw Exception('로그인 실패: ${response.body}');
    }
  }

  Future<void> sendVerificationCode(String email) async {
    final url = Uri.parse('$_baseUrl/api/auth/send-code?email=$email');
    final response = await http.post(
      url,
      headers: {'Accept': 'text/plain'}, // or application/json if 바꿀 예정
    );

    if (response.statusCode != 200) {
      throw Exception('인증번호 전송 실패: ${response.body}');
    }
  }

  Future<void> verifyCode(String email, String code) async {
    final url = Uri.parse('$_baseUrl/api/auth/verify-code?email=$email&code=$code');
    final response = await http.post(
      url,
      headers: {'Accept': 'text/plain'},
    );

    if (response.statusCode != 200) {
      throw Exception('인증번호 확인 실패: ${response.body}');
    }
  }
}
