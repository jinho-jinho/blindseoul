import 'dart:async';
import 'package:flutter/material.dart';
import '../api/user_api.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();
  final userApi = UserApi();

  bool isCodeSent = false;
  bool isVerified = false;
  Timer? _timer;
  int remainingSeconds = 300;

  void _startTimer() {
    _timer?.cancel();
    remainingSeconds = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _sendCode() async {
    try {
      await userApi.sendVerificationCode(emailController.text);
      setState(() => isCodeSent = true);
      _startTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('인증번호가 전송되었습니다')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('인증번호 전송 실패: $e')),
      );
    }
  }

    void _verifyCode() async {
    try {
      await userApi.verifyCode(emailController.text, codeController.text);
      setState(() {
        isVerified = true;
        _timer?.cancel();          // ✅ 인증 완료 시 타이머 중단
        isCodeSent = false;        // ✅ 인증 입력 UI 제거
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 인증 완료')),
      );
    } catch (e) {
      // ✅ 서버 메시지 추출
      final errorMsg = e.toString().contains('이미 인증된 이메일')
          ? '이미 인증된 이메일입니다'
          : e.toString().contains('만료') 
              ? '인증번호가 만료되었습니다'
              : '인증번호가 일치하지 않습니다';

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMsg)),
      );
    }
  }

  void _signup() async {
    if (!isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 인증이 필요합니다')),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호가 일치하지 않습니다')),
      );
      return;
    }
    if (passwordController.text.length < 8) {
      // ✅ 비밀번호 길이 확인
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호는 8자리 이상이어야 합니다')),
      );
      return;
    }

    try {
      await userApi.signup(
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('회원가입 실패: ${e.toString()}')),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerText = '${(remainingSeconds ~/ 60).toString().padLeft(1, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}';
    bool _obscurePassword = true;
    bool _obscureConfirmPassword = true;

    return Scaffold(
      appBar: AppBar(title: const Text('회원가입')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: '이름'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: '이메일'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _sendCode,
                    child: const Text('인증'),
                  ),
                ],
              ),
              if (isCodeSent && !isVerified)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('인증번호 입력 (남은 시간: $timerText)', style: const TextStyle(fontSize: 12)),
                    TextField(
                      controller: codeController,
                      decoration: const InputDecoration(labelText: '인증번호'),
                    ),
                    ElevatedButton(
                      onPressed: _verifyCode,
                      child: const Text('확인'),
                    ),
                  ],
                ),
              TextField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: '비밀번호',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: '비밀번호 확인',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('회원가입'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
