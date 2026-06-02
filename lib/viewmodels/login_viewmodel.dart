import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../views/register_view.dart';
import '../views/home_view.dart';
import '../views/admin/admin_main_view.dart';
import 'package:flutter/scheduler.dart';

class LoginViewModel extends ChangeNotifier {
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

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void navigateToRegister(BuildContext context) {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => const RegisterView(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    _clearError();

    if (email.isEmpty || password.isEmpty) {
      _setError('Email dan Password tidak boleh kosong');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final UserModel loggedInUser = await _authService.login(email, password);

      debugPrint("Login Berhasil! Role: ${loggedInUser.role}");

      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Selamat datang, ${loggedInUser.fullName}!')),
        );

        if (loggedInUser.role == 'admin') {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminMainView()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeView(user: loggedInUser),
            ),
            (route) => false,
          );
        }
      });
    } catch (e) {
      final errorMsg = e.toString().replaceAll('Exception: ', '');
      _setError(errorMsg);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
          ),
        );
      }
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