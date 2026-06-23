import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class LoginViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<UserModel?> login({Function(String)? onError}) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      onError?.call('Email dan Password tidak boleh kosong');
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final UserModel loggedInUser = await _authService.login(email, password);
      return loggedInUser;
    } catch (e) {
      onError?.call(e.toString().replaceAll('Exception: ', ''));
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
