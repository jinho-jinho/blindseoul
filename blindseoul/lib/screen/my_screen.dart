import 'package:flutter/material.dart';

class MyScreen extends StatelessWidget {
  const MyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: const Center(
        child: Text('내 정보 화면입니다.', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}