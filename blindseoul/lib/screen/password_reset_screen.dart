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

  bool _codeSent = false;
  bool _codeVerified = false;

  bool _obscureNewPw = true;
  bool _obscureConfirmPw = true;

  void _showSnack(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  bool _isValidEmail(String email) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('비밀번호 재설정')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '비밀번호 재설정',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 1단계 이메일
                      TextField(
                        controller: _emailCtrl,
                        enabled: !_codeSent,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: '이메일',
                          hintText: 'you@example.com',
                          prefixIcon: const Icon(Icons.alternate_email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: _codeSent || _sending ? null : _sendCode,
                        child: _sending
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('코드 전송'),
                      ),

                      // 2단계 인증번호
                      if (_codeSent) ...[
                        const Divider(height: 32),
                        TextField(
                          controller: _codeCtrl,
                          enabled: !_codeVerified,
                          decoration: InputDecoration(
                            labelText: '인증번호',
                            hintText: '이메일로 받은 6자리 코드',
                            prefixIcon: const Icon(Icons.verified_user_outlined),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton.tonal(
                          onPressed:
                              (!_codeSent || _codeVerified || _verifying) ? null : _verifyCode,
                          child: _verifying
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('코드 확인'),
                        ),
                      ],

                      // 3단계 새 비밀번호
                      if (_codeVerified) ...[
                        const Divider(height: 32),
                        TextField(
                          controller: _newPwCtrl,
                          obscureText: _obscureNewPw,
                          decoration: InputDecoration(
                            labelText: '새 비밀번호 (8자 이상)',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() {
                                _obscureNewPw = !_obscureNewPw;
                              }),
                              icon: Icon(
                                _obscureNewPw ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _confirmPwCtrl,
                          obscureText: _obscureConfirmPw,
                          decoration: InputDecoration(
                            labelText: '새 비밀번호 확인',
                            prefixIcon: const Icon(Icons.lock_person_outlined),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() {
                                _obscureConfirmPw = !_obscureConfirmPw;
                              }),
                              icon: Icon(
                                _obscureConfirmPw ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: _resetting ? null : _resetPassword,
                          child: _resetting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2.2),
                                )
                              : const Text('비밀번호 변경'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
