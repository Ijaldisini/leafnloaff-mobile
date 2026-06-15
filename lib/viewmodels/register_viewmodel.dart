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

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<UserModel?> register() async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    clearError();

    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      _setError('Semua form pendaftaran wajib diisi');
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
      _setError(e.toString().replaceAll('Exception: ', ''));
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
