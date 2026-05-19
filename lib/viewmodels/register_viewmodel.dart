import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../views/register_otp_view.dart';

class RegisterViewModel extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void navigateToRegisterOtp(BuildContext context, UserModel user) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => RegisterOtpView(user: user)),
    );
  }

  Future<void> register(BuildContext context) async {
    final name = nameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (name.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua form pendaftaran wajib diisi')),
      );
      return;
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

      final String secret = await _authService.register(newUser, password);

      final completedUser = UserModel(
        id: '',
        fullName: name,
        username: username,
        email: email,
        otpSecret: secret,
      );

      debugPrint("Register Berhasil!");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Register Berhasil! Silakan scan QR Code.'),
          ),
        );
        navigateToRegisterOtp(context, completedUser);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
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
