import 'package:flutter/material.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = RegisterViewModel();

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
                    left: 199,
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
                    left: 101,
                    top: 695,
                    child: GestureDetector(
                      onTap: _viewModel.isLoading
                          ? null
                          : () => _viewModel.register(context),
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
                                'Register',
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
                  Positioned(
                    left: 199,
                    top: 86,
                    child: Container(
                      width: 118,
                      height: 30.92,
                      alignment: Alignment.center,
                      child: const Text(
                        'Register',
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
                    left: 141.68,
                    top: 189.34,
                    child: const SizedBox(
                      width: 97.96,
                      height: 113.75,
                      child: Icon(Icons.eco, size: 80, color: Colors.white),
                    ),
                  ),

                  Positioned(
                    left: 59,
                    top: 350,
                    child: const Text(
                      'Name',
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
                    top: 376,
                    child: _buildInputField(
                      _viewModel.nameController,
                      'Masukkan nama',
                      false,
                    ),
                  ),

                  Positioned(
                    left: 58,
                    top: 429,
                    child: const Text(
                      'Username',
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
                    top: 455,
                    child: _buildInputField(
                      _viewModel.usernameController,
                      'Masukkan username',
                      false,
                    ),
                  ),

                  Positioned(
                    left: 58,
                    top: 508,
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
                    top: 534,
                    child: _buildInputField(
                      _viewModel.emailController,
                      'Masukkan email',
                      false,
                    ),
                  ),

                  Positioned(
                    left: 59,
                    top: 587,
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
                    top: 613,
                    child: _buildInputField(
                      _viewModel.passwordController,
                      'Buat password',
                      true,
                    ),
                  ),

                  Positioned(
                    left: 101,
                    top: 695,
                    child: GestureDetector(
                      onTap: _viewModel.isLoading
                          ? null
                          : () => _viewModel.register(context),
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
                                'Register',
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
