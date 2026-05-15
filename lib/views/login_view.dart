import 'package:flutter/material.dart';
import '../viewmodels/login_viewmodel.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = LoginViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          return SingleChildScrollView(
            child: Container(
              width: 390,
              height: 844,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, 0.00),
                  end: Alignment(1.00, 1.00),
                  colors: [Color(0xFFEAEAAA), Color(0xFF2D4839)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 68,
                    top: 82,
                    child: Container(
                      width: 255,
                      height: 38,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment(0.50, 0.00),
                          end: Alignment(0.50, 1.00),
                          colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(108.57),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 73,
                    top: 86,
                    child: Container(
                      width: 118,
                      height: 30.92,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFEED5DB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(88.35),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 73,
                    top: 86,
                    child: Container(
                      width: 118,
                      height: 30.92,
                      alignment: Alignment.center,
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          color: Color(0xFFCA748D),
                          fontSize: 18,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 199,
                    top: 86,
                    child: GestureDetector(
                      onTap: () => _viewModel.navigateToRegister(
                        context,
                      ),
                      child: Container(
                        width: 118,
                        height: 30.92,
                        alignment: Alignment.center,
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            color: Color(0xFFEED5DB),
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 141.68,
                    top: 222.34,
                    child: const SizedBox(
                      width: 97.96,
                      height: 113.75,
                      child: Icon(Icons.eco, size: 80, color: Colors.white),
                    ),
                  ),

                  Positioned(
                    left: 58,
                    top: 421,
                    child: const Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 58,
                    top: 447,
                    child: _buildInputField(
                      _viewModel.emailController,
                      'Masukkan email',
                      false,
                    ),
                  ),

                  Positioned(
                    left: 58,
                    top: 518,
                    child: const Text(
                      'Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 58,
                    top: 540,
                    child: _buildInputField(
                      _viewModel.passwordController,
                      'Masukkan password',
                      true,
                    ),
                  ),

                  Positioned(
                    left: 102,
                    top: 628,
                    child: GestureDetector(
                      onTap: _viewModel.isLoading
                          ? null
                          : () => _viewModel.login(context),
                      child: Container(
                        width: 189,
                        height: 38,
                        decoration: ShapeDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(108.57),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: _viewModel.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hint,
    bool isPassword,
  ) {
    return Container(
      width: 275,
      height: 38,
      decoration: ShapeDecoration(
        color: const Color(0xFFFDFDFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(108.57),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black, fontFamily: 'Poppins'),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
