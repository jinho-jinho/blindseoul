import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('커뮤니티')),
      body: const Center(
        child: Text('커뮤니티 기능 준비 중입니다.', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}