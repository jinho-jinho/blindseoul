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
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/login'),
              child: const Text('로그인 하러 가기'),
            ),
          ),
        ],
      ),
    );
  }
}