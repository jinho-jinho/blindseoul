import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:blindseoul/screen/blindwalk_map_screen.dart';
import 'package:blindseoul/screen/community_screen.dart';
import 'package:blindseoul/screen/my_screen.dart';
import 'package:blindseoul/screen/login_overlay_screen.dart';
import 'package:blindseoul/screen/login_screen.dart';
import 'package:blindseoul/screen/signup_screen.dart';
import 'package:blindseoul/provider/auth_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlindSeoul',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeWithBottomNav(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}

class HomeWithBottomNav extends StatefulWidget {
  const HomeWithBottomNav({super.key});

  @override
  State<HomeWithBottomNav> createState() => _HomeWithBottomNavState();
}

class _HomeWithBottomNavState extends State<HomeWithBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    BlindwalkMapScreen(),
    CommunityScreen(),
    MyScreen(),
  ];

  void _onItemTapped(int index) {
    final isLoggedIn = context.read<AuthProvider>().isLoggedIn;

    if (!isLoggedIn && index != 0) {
      showDialog(
        context: context,
        builder: (_) => const LoginOverlayScreen(),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Now'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
        ],
      ),
    );
  }
}