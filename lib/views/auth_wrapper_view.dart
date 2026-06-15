import 'package:flutter/material.dart';
import '../viewmodels/auth_wrapper_viewmodel.dart';
import 'welcome_view.dart';
import 'cust/main_view.dart';
import 'admin/admin_main_view.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthWrapperViewModel _viewModel = AuthWrapperViewModel();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    await _viewModel.checkAuthStatus();

    if (!mounted) return;

    final userModel = _viewModel.currentUser;
    if (userModel != null) {
      if (userModel.role == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminMainView(user: userModel),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomerMainView(user: userModel),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeView()),
      );
    }
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF3D5A4A),
      body: Center(child: CircularProgressIndicator(color: Color(0xFFD699AB))),
    );
  }
}
