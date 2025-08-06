import 'dart:ui';
import 'package:flutter/material.dart';

class LoginOverlayScreen extends StatelessWidget {
  const LoginOverlayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
            child: Container(
              color: Colors.black.withAlpha(76),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final result = await Navigator.pushNamed(context, '/login');
                if (result == 'success') {
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                }
              },
              child: const Text('로그인 하러 가기'),
            ),
          ),
        ],
      ),
    );
  }
}