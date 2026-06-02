import 'package:flutter/material.dart';
import '../viewmodels/register_viewmodel.dart';
import 'login_view.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView>
    with SingleTickerProviderStateMixin {
  final RegisterViewModel _viewModel = RegisterViewModel();
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
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _viewModel.dispose();
    super.dispose();
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
              // ✅ Gradient yang sama dengan LoginView
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFEF9C3),  // ✅ Kuning cream
                  Color(0xFF84A98C),  // ✅ Hijau sage
                  Color(0xFF52796F),  // ✅ Hijau gelap
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: screenHeight -
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

                            // ── Tab bar ───────────────────────────
                            Center(child: _buildTabBar()),

                            const SizedBox(height: 28),

                            // ── Logo ─────────────────────────────
                            Center(child: _buildLogo()),

                            const SizedBox(height: 28),

                            // ── Fields ────────────────────────────
                            _fieldLabel('Name'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _viewModel.nameController,
                              isPassword: false,
                            ),

                            const SizedBox(height: 16),

                            _fieldLabel('Username'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _viewModel.usernameController,
                              isPassword: false,
                            ),

                            const SizedBox(height: 16),

                            _fieldLabel('Email'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _viewModel.emailController,
                              isPassword: false,
                              keyboardType: TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 16),

                            _fieldLabel('Password'),
                            const SizedBox(height: 8),
                            _buildInputField(
                              controller: _viewModel.passwordController,
                              isPassword: true,
                            ),

                            const SizedBox(height: 12),

                            if (_viewModel.errorMessage != null &&
                                _viewModel.errorMessage!.isNotEmpty)
                              _buildErrorBox(_viewModel.errorMessage!),

                            const Spacer(),
                            const SizedBox(height: 28),

                            // ── Tombol Register ───────────────────
                            Center(child: _buildRegisterButton()),

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

  Widget _buildTabBar() {
    return Container(
      width: 240,
      height: 36,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD699AB),  
            Color(0xFFCA748D),  
          ],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children: [
          // Login — tidak aktif
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              ),
              child: const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white70,  
                    fontSize: 15,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          // Register — aktif
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFEED5DB),  
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: const Text(
                'Register',
                style: TextStyle(
                  color: Color(0xFFCA748D),  
                  fontSize: 15,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_logoLine('Leaf'), _logoLine('Loaff')],
    );
  }

  Widget _logoLine(String text) {
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3
              ..color = const Color(0xFF2D4839).withOpacity(0.4),
            fontSize: 54,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFF5F5A0), Color(0xFFEED5DB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 54,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w900,
              height: 1.05,
            ),
          ),
        ),
        Positioned(
          left: 2,
          top: -6,
          child: Text(
            '♛',
            style: TextStyle(
              fontSize: 14,
              color: const Color(0xFFD4B44A).withOpacity(0.9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        shadows: [
          Shadow(
            offset: Offset(1, 1),
            blurRadius: 3,
            color: Colors.black26,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
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
        color: const Color(0xFFE76F51).withOpacity(0.2),  // ✅ Coral
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE76F51).withOpacity(0.5),  // ✅ Coral
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline,
            color: Color(0xFFEED5DB),
            size: 16,
          ),
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

  Widget _buildRegisterButton() {
    return GestureDetector(
      onTap: _viewModel.isLoading ? null : () => _viewModel.register(context),
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
                : const [
                    Color(0xFFD699AB),  
                    Color(0xFFCA748D),  
                  ],
          ),
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFCA748D).withOpacity(0.45),  // ✅ Coral shadow
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
                'Register',
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