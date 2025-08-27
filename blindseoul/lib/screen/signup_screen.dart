import 'dart:async';
import 'package:flutter/material.dart';
import '../api/user_api.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _code = TextEditingController();
  final _api = UserApi();
  final _formKey = GlobalKey<FormState>();

  bool _isCodeSent = false;
  bool _isVerified = false;
  bool _loadingSend = false;
  bool _loadingVerify = false;
  bool _loadingSignup = false;

  // 👇 비밀번호 눈동자 토글을 State 필드로 유지 (build 안 X)
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  Timer? _timer;
  int _remaining = 300; // 5분

  @override
  void dispose() {
    _timer?.cancel();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    _code.dispose();
    super.dispose();
  }

  String _mmss(int sec) =>
      '${(sec ~/ 60).toString().padLeft(1, '0')}:${(sec % 60).toString().padLeft(2, '0')}';

  void _startTimer() {
    _timer?.cancel();
    setState(() => _remaining = 300);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_remaining > 0) {
          _remaining--;
        } else {
          t.cancel();
          _isCodeSent = false; // 시간 만료 시 입력창 감춤
        }
      });
    });
  }

  Future<void> _sendCode() async {
    final email = _email.text.trim();
    if (email.isEmpty || !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('올바른 이메일을 입력하세요')),
      );
      return;
    }
    setState(() {
      _loadingSend = true;
    });
    try {
      await _api.sendVerificationCode(email);
      if (!mounted) return;
      setState(() {
        _isCodeSent = true;
        _isVerified = false;
      });
      _startTimer();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('인증번호가 전송되었습니다')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('인증번호 전송 실패: $e')));
    } finally {
      if (mounted) setState(() => _loadingSend = false);
    }
  }

  Future<void> _verifyCode() async {
    final email = _email.text.trim();
    final code = _code.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('인증번호를 입력하세요')));
      return;
    }
    setState(() => _loadingVerify = true);
    try {
      await _api.verifyCode(email, code);
      if (!mounted) return;
      setState(() {
        _isVerified = true;
        _isCodeSent = false;
      });
      _timer?.cancel();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이메일 인증 완료')));
    } catch (e) {
      if (!mounted) return;
      final msg = e.toString();
      final friendly = msg.contains('이미 인증') ? '이미 인증된 이메일입니다'
          : msg.contains('만료') ? '인증번호가 만료되었습니다'
          : '인증번호가 일치하지 않습니다';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(friendly)));
    } finally {
      if (mounted) setState(() => _loadingVerify = false);
    }
  }

  Future<void> _signup() async {
    if (!_isVerified) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('이메일 인증이 필요합니다')));
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _loadingSignup = true);
    try {
      await _api.signup(
        name: _name.text.trim(),
        email: _email.text.trim(),
        password: _password.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('회원가입 성공')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('회원가입 실패: $e')));
    } finally {
      if (mounted) setState(() => _loadingSignup = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerText = _mmss(_remaining);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: const Text('회원가입')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    '계정 만들기',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BlindSeoul의 모든 기능을 사용해보세요.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _name,
                              decoration: InputDecoration(
                                labelText: '이름',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (v) =>
                                  (v ?? '').trim().isEmpty ? '이름을 입력해주세요' : null,
                            ),
                            const SizedBox(height: 14),

                            // 이메일 + 인증 버튼
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _email,
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    decoration: InputDecoration(
                                      labelText: '이메일',
                                      hintText: 'name@example.com',
                                      prefixIcon: const Icon(Icons.alternate_email),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      filled: true,
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: (v) {
                                      final val = (v ?? '').trim();
                                      if (val.isEmpty) return '이메일을 입력해주세요';
                                      final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(val);
                                      if (!ok) return '올바른 이메일 형식이 아니에요';
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                SizedBox(
                                  height: 56,
                                  child: FilledButton.tonal(
                                    onPressed: _loadingSend ? null : _sendCode,
                                    child: _loadingSend
                                        ? const SizedBox(
                                            width: 18, height: 18,
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          )
                                        : const Text('인증'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),

                            // 인증번호 입력 영역 (타이머 포함)
                            if (_isCodeSent && !_isVerified)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '인증번호 입력',
                                        style: theme.textTheme.labelLarge,
                                      ),
                                      Text(
                                        '남은 시간: $timerText',
                                        style: theme.textTheme.labelMedium?.copyWith(
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          controller: _code,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: '6자리 인증번호',
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            filled: true,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        height: 48,
                                        child: FilledButton(
                                          onPressed: _loadingVerify ? null : _verifyCode,
                                          child: _loadingVerify
                                              ? const SizedBox(
                                                  width: 18, height: 18,
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                )
                                              : const Text('확인'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '인증번호는 5분간 유효합니다.',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color?.withOpacity(.7),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),

                            // 비밀번호
                            TextFormField(
                              controller: _password,
                              obscureText: _obscurePassword,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                labelText: '비밀번호',
                                hintText: '최소 8자',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _obscurePassword ? '표시' : '숨기기',
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    child: Icon(
                                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                      key: ValueKey(_obscurePassword),
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                final val = v ?? '';
                                if (val.isEmpty) return '비밀번호를 입력해주세요';
                                if (val.length < 8) return '8자 이상 입력해주세요';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // 비밀번호 확인
                            TextFormField(
                              controller: _confirm,
                              obscureText: _obscureConfirm,
                              autofillHints: const [AutofillHints.newPassword],
                              decoration: InputDecoration(
                                labelText: '비밀번호 확인',
                                prefixIcon: const Icon(Icons.lock_person_outlined),
                                suffixIcon: IconButton(
                                  tooltip: _obscureConfirm ? '표시' : '숨기기',
                                  onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    child: Icon(
                                      _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                                      key: ValueKey(_obscureConfirm),
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              textInputAction: TextInputAction.done,
                              validator: (v) {
                                if (v == null || v.isEmpty) return '비밀번호를 다시 입력해주세요';
                                if (v != _password.text) return '비밀번호가 일치하지 않습니다';
                                return null;
                              },
                              onFieldSubmitted: (_) => _signup(),
                            ),

                            const SizedBox(height: 18),

                            // 회원가입 버튼
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                onPressed: _loadingSignup ? null : _signup,
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _loadingSignup
                                    ? const SizedBox(
                                        width: 22, height: 22,
                                        child: CircularProgressIndicator(strokeWidth: 2.4),
                                      )
                                    : const Text('회원가입'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Text(
                    '이미 계정이 있으신가요?',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('로그인 화면으로 돌아가기'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
