// lib/screen/my_screen.dart
import 'package:flutter/material.dart';
import '../api/user_api.dart';
import '../model/user_response.dart';
import 'package:intl/intl.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final _api = UserApi();
  late Future<UserResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = _api.me();
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('yyyy.MM.dd HH:mm');
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: FutureBuilder<UserResponse>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('불러오기 실패: ${snap.error}', style: const TextStyle(color: Colors.red)));
          }
          final u = snap.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(u.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(u.email),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: const Text('가입일'),
                  subtitle: Text(dateFmt.format(u.createdAt.toLocal())),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  await _api.logout();
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('로그아웃되었습니다.')));
                  setState(() => _future = Future.error('로그인이 필요합니다.'));
                },
                icon: const Icon(Icons.logout),
                label: const Text('로그아웃'),
              ),
            ],
          );
        },
      ),
    );
  }
}
