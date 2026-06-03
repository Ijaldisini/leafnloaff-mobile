import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import '../models/user_model.dart';
import '../views/cust/main_view.dart';

class RegisterOtpViewModel extends ChangeNotifier {
  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String get otpCode => otpControllers.map((c) => c.text).join();

  void verifyOtp(BuildContext context, UserModel user) async {
    final code = otpCode;

    if (code.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit kode OTP')),
      );
      return;
    }

    if (user.otpSecret == null || user.otpSecret!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error: Kode Rahasia tidak ditemukan pada akun ini'),
        ),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final String expectedCode = OTP.generateTOTPCodeString(
        user.otpSecret!,
        DateTime.now().millisecondsSinceEpoch,
        length: 6,
        interval: 30,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      debugPrint("Kode diinput: $code");
      debugPrint("Kode diharapkan: $expectedCode");

      await Future.delayed(const Duration(milliseconds: 500));

      if (code == expectedCode) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Verifikasi Berhasil!')));

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerMainView(user: user),
            ),
            (route) => false,
          );
        }
      } else {
        throw Exception('Kode OTP salah atau sudah kedaluwarsa.');
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
    if (value.length == 1 && index < 5) {
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
