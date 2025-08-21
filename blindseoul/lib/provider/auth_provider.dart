// lib/provider/auth_provider.dart
import 'package:flutter/material.dart';
import '../core/token_storage.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isLoading = true;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  AuthProvider() {
    _load();
  }

  Future<void> _load() async {
    final token = await TokenStorage.read();
    _isLoggedIn = token != null && token.isNotEmpty;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await TokenStorage.clear();
    _isLoggedIn = false;
    notifyListeners();
  }
}
