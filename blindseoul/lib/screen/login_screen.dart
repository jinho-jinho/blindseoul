import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';
import '../api/user_api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _api = UserApi();

  bool _obscure = true;
  bool _loading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await _api.login(email: _email.text.trim(), password: _password.text);
      if (!mounted) return;
      await context.read<AuthProvider>().login();
      if (!mounted) return;
      Navigator.pop(context, 'success');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
    // (선택) TextEditingController 정리
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    '로그인',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'BlindSeoul에 다시 오신 걸 환영해요.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(.7),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 카드 컨테이너
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
                            // 이메일
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: const [AutofillHints.username, AutofillHints.email],
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
                                final value = (v ?? '').trim();
                                if (value.isEmpty) return '이메일을 입력해주세요';
                                final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
                                if (!ok) return '올바른 이메일 형식이 아니에요';
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),

                            // 비밀번호 (+ 눈동자 토글)
                            TextFormField(
                              controller: _password,
                              obscureText: _obscure,
                              autofillHints: const [AutofillHints.password],
                              decoration: InputDecoration(
                                labelText: '비밀번호',
                                hintText: '비밀번호를 입력하세요',
                                prefixIcon: const Icon(Icons.lock_outline),
                                suffixIcon: IconButton(
                                  tooltip: _obscure ? '표시' : '숨기기',
                                  onPressed: () => setState(() => _obscure = !_obscure),
                                  icon: AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    transitionBuilder: (child, anim) =>
                                        FadeTransition(opacity: anim, child: child),
                                    child: Icon(
                                      _obscure ? Icons.visibility_off : Icons.visibility,
                                      key: ValueKey(_obscure),
                                    ),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                              ),
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => _login(),
                              validator: (v) {
                                if ((v ?? '').isEmpty) return '비밀번호를 입력해주세요';
                                if ((v ?? '').length < 6) return '6자 이상 입력해주세요';
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // 로그인 버튼
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: FilledButton(
                                onPressed: _loading ? null : _login,
                                style: FilledButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        width: 22, height: 22,
                                        child: CircularProgressIndicator(strokeWidth: 2.4),
                                      )
                                    : const Text('로그인'),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // 링크들
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                  onPressed: _loading ? null : () => Navigator.pushNamed(context, '/signup'),
                                  child: const Text('회원가입'),
                                ),
                                TextButton(
                                  onPressed: _loading ? null : () => Navigator.pushNamed(context, '/password-reset'),
                                  child: const Text('비밀번호 찾기'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // 하단 서브텍스트
                  Text(
                    '© ${DateTime.now().year} BlindSeoul',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
