// lib/screen/password_reset_screen.dart
import 'package:flutter/material.dart';
import '../api/user_api.dart';

class PasswordResetScreen extends StatefulWidget {
  const PasswordResetScreen({super.key});

  @override
  State<PasswordResetScreen> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  final _emailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _newPwCtrl = TextEditingController();
  final _confirmPwCtrl = TextEditingController();

  final _api = UserApi();

  bool _sending = false;
  bool _verifying = false;
  bool _resetting = false;

  bool _codeSent = false;     // 1단계 완료 플래그
  bool _codeVerified = false; // 2단계 완료 플래그

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  bool _isValidEmail(String email) {
    // 아주 간단한 검증
    return email.contains('@') && email.contains('.');
  }

  Future<void> _sendCode() async {
    final email = _emailCtrl.text.trim();
    if (!_isValidEmail(email)) {
      _showSnack('올바른 이메일을 입력해 주세요.');
      return;
    }
    setState(() => _sending = true);
    try {
      await _api.sendPasswordResetCode(email);
      setState(() => _codeSent = true);
      _showSnack('인증번호를 전송했어요. 메일함을 확인해 주세요.');
    } catch (e) {
      _showSnack('$e');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _verifyCode() async {
    final email = _emailCtrl.text.trim();
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      _showSnack('인증번호를 입력해 주세요.');
      return;
    }
    setState(() => _verifying = true);
    try {
      await _api.verifyPasswordResetCode(email, code);
      setState(() => _codeVerified = true);
      _showSnack('인증이 완료되었습니다. 새 비밀번호를 입력해 주세요.');
    } catch (e) {
      _showSnack('$e');
    } finally {
      if (mounted) setState(() => _verifying = false);
    }
  }

  Future<void> _resetPassword() async {
    final email = _emailCtrl.text.trim();
    final code = _codeCtrl.text.trim();
    final newPw = _newPwCtrl.text;
    final confirmPw = _confirmPwCtrl.text;

    if (newPw.length < 8) {
      _showSnack('비밀번호는 8자 이상이어야 합니다.');
      return;
    }
    if (newPw != confirmPw) {
      _showSnack('비밀번호가 일치하지 않습니다.');
      return;
    }

    setState(() => _resetting = true);
    try {
      await _api.resetPassword(email: email, code: code, newPassword: newPw);
      _showSnack('비밀번호가 변경되었습니다. 로그인 화면으로 돌아갑니다.');
      if (!mounted) return;
      Navigator.pop(context, 'password_reset_success');
    } catch (e) {
      _showSnack('$e');
    } finally {
      if (mounted) setState(() => _resetting = false);
    }
  }

  Widget _emailStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('1단계. 이메일 입력', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: '이메일',
            hintText: 'you@example.com',
            border: OutlineInputBorder(),
          ),
          enabled: !_codeSent, // 코드 전송 후엔 이메일 못 바꾸게 잠금
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _codeSent || _sending ? null : _sendCode,
            child: _sending ? const CircularProgressIndicator() : const Text('코드 전송'),
          ),
        ),
      ],
    );
  }

  Widget _codeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text('2단계. 인증번호 확인', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _codeCtrl,
          decoration: const InputDecoration(
            labelText: '인증번호',
            hintText: '이메일로 받은 6자리 코드',
            border: OutlineInputBorder(),
          ),
          enabled: _codeSent && !_codeVerified,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (!_codeSent || _codeVerified || _verifying) ? null : _verifyCode,
            child: _verifying ? const CircularProgressIndicator() : const Text('코드 확인'),
          ),
        ),
      ],
    );
  }

  Widget _newPasswordStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: 32),
        const Text('3단계. 새 비밀번호 설정', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: _newPwCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: '새 비밀번호 (8자 이상)',
            border: OutlineInputBorder(),
          ),
          enabled: _codeVerified,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _confirmPwCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: '새 비밀번호 확인',
            border: OutlineInputBorder(),
          ),
          enabled: _codeVerified,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_codeVerified && !_resetting) ? _resetPassword : null,
            child: _resetting ? const CircularProgressIndicator() : const Text('비밀번호 변경'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _codeCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('비밀번호 재설정')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _emailStep(),
            _codeStep(),
            _newPasswordStep(),
          ],
        ),
      ),
    );
  }
}
