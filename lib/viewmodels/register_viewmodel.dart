import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<UserModel?> register({Function(String)? onError}) async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      onError?.call('Semua form pendaftaran wajib diisi');
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newUser = UserModel(
        id: '',
        fullName: name,
        username: username,
        email: email,
      );

      await _authService.register(newUser, password);
      return newUser;
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
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
