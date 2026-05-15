import 'package:flutter/material.dart';
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

  void navigateToRegisterOtp(
    BuildContext context,
    String email,
    String secret,
  ) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterOtpView(email: email, otpSecret: secret),
      ),
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
      final String secret = await _authService.register(
        email,
        password,
        name,
        username,
      );

      debugPrint("Register Berhasil!");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Register Berhasil! Silakan scan QR Code.'),
          ),
        );
        navigateToRegisterOtp(context, email, secret);
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
}
