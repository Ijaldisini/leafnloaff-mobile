import 'package:flutter/material.dart';
import '../viewmodels/login_viewmodel.dart';
import 'cust/main_view.dart';
import 'admin/admin_main_view.dart';
import 'register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final LoginViewModel _viewModel = LoginViewModel();
  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    final user = await _viewModel.login();

    if (!mounted) return;

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selamat datang, ${user.fullName}!')),
      );
      if (user.role == 'admin') {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => AdminMainView(user: user)),
          (route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CustomerMainView(user: user)),
          (route) => false,
        );
      }
    } else if (_viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEAEAAA), Color(0xFF2D4839)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        screenHeight -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: IntrinsicHeight(
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 28),
                            Center(child: _buildTabBar(context)),
                            const SizedBox(height: 36),
                            Center(child: _buildLogo()),
                            const SizedBox(height: 40),
                            _fieldLabel('Email'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _viewModel.emailController,
                              hint: '',
                              isPassword: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 20),
                            _fieldLabel('Password'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _viewModel.passwordController,
                              hint: '',
                              isPassword: true,
                            ),
                            const SizedBox(height: 12),
                            if (_viewModel.errorMessage != null &&
                                _viewModel.errorMessage!.isNotEmpty)
                              _buildErrorBox(_viewModel.errorMessage!),
                            const Spacer(),
                            const SizedBox(height: 36),
                            Center(child: _buildLoginButton()),
                            const SizedBox(height: 36),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return Container(
      width: 240,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFEED5DB),
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Color(0xFFCA748D),
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim1, anim2) =>
                        const RegisterView(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: const Center(
                child: Text(
                  'Register',
                  style: TextStyle(
                    color: Color(0xFFEED5DB),
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: 200,  
      height: 200, 
      fit: BoxFit.contain,
    );
  }

  // Widget _logoLine(String text) {
  //   return Stack(
  //     children: [
  //       Text(
  //         text,
  //         style: TextStyle(
  //           foreground: Paint()
  //             ..style = PaintingStyle.stroke
  //             ..strokeWidth = 3
  //             ..color = const Color(0xFF2D4839).withOpacity(0.4),
  //           fontSize: 62,
  //           fontFamily: 'Poppins',
  //           fontWeight: FontWeight.w900,
  //           height: 1.05,
  //         ),
  //       ),
  //       ShaderMask(
  //         shaderCallback: (bounds) => const LinearGradient(
  //           colors: [Color(0xFFF5F5A0), Color(0xFFEED5DB)],
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //         ).createShader(bounds),
  //         child: Text(
  //           text,
  //           style: const TextStyle(
  //             color: Colors.white,
  //             fontSize: 62,
  //             fontFamily: 'Poppins',
  //             fontWeight: FontWeight.w900,
  //             height: 1.05,
  //           ),
  //         ),
  //       ),
  //       Positioned(
  //         left: 2,
  //         top: -8,
  //         child: Text(
  //           '♛',
  //           style: TextStyle(
  //             fontSize: 16,
  //             color: const Color(0xFFD4B44A).withOpacity(0.9),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        shadows: [
          Shadow(offset: Offset(1, 1), blurRadius: 3, color: Colors.black26),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required bool isPassword,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                obscureText: isPassword ? _obscurePassword : false,
                keyboardType: keyboardType,
                style: const TextStyle(
                  color: Colors.black87,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                  hintText: hint,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            ),
            if (isPassword)
              GestureDetector(
                onTap: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                child: Icon(
                  _obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 19,
                  color: const Color(0xFFCA748D),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFCA748D).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCA748D).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Color(0xFFEED5DB), size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Color(0xFFEED5DB),
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return GestureDetector(
      onTap: _viewModel.isLoading
          ? null
          : _handleLogin,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 200,
        height: 46,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _viewModel.isLoading
                ? [
                    const Color(0xFFD699AB).withOpacity(0.6),
                    const Color(0xFFCA748D).withOpacity(0.6),
                  ]
                : const [Color(0xFFD699AB), Color(0xFFCA748D)],
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCA748D).withOpacity(0.45),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: _viewModel.isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
