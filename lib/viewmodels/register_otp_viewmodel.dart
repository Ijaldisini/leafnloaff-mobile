import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../views/cust/main_view.dart';
import '../services/auth_service.dart';

class RegisterOtpViewModel extends ChangeNotifier {
  final List<TextEditingController> otpControllers = List.generate(
    8,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(8, (_) => FocusNode());

  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get otpCode => otpControllers.map((c) => c.text).join();

  void verifyOtp(BuildContext context, UserModel user) async {
    final code = otpCode;

    if (code.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 8 digit kode OTP')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.verifyEmailOtp(user.email, code);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verifikasi Email Berhasil!')),
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CustomerMainView(user: user)),
          (route) => false,
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void nextField(String value, int index) {
    if (value.length == 1 && index < 7) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
