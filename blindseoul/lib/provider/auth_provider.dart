import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _loadLoginState(); // 앱 실행 시 자동 로그인 체크
  }

  void _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _isLoading = false;
    notifyListeners();
  }

  void login() async {
    _isLoggedIn = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    notifyListeners();
  }

  void logout() async {
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    notifyListeners();
  }
}
