import 'package:flutter/material.dart';
import '../viewmodels/welcome_viewmodel.dart';
import 'login_view.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView>
    with TickerProviderStateMixin {
  final WelcomeViewModel _viewModel = WelcomeViewModel();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<Map<String, String>> _slides = [
    {
      'text': 'Fuel Your\nHustle',
      'image_top': 'assets/images/sandwich-welcome-page-atas.png',
      'image_bottom': 'assets/images/sandwich-welcome-page-bawah.png',
    },
    {
      'text': 'Wholesome\ningredients in\nevery bite.',
      'image_top': 'assets/images/sandwich-welcome-page-atas.png',
      'image_bottom': 'assets/images/sandwich-welcome-page-bawah.png',
    },
    {
      'text': 'Simple food,\nreal nutrition.',
      'image_top': 'assets/images/sandwich-welcome-page-atas.png',
      'image_bottom': 'assets/images/sandwich-welcome-page-bawah.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(_onSlideChanged);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0.08, 0), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeController.forward();
    _slideController.forward();
  }

  void _onSlideChanged() {
    _fadeController.reset();
    _slideController.reset();
    _fadeController.forward();
    _slideController.forward();
    setState(() {});
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onSlideChanged);
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final hasNextSlide = _viewModel.onNextPressed();

    if (!hasNextSlide) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final idx = _viewModel.currentSlideIndex;
    final slide = _slides[idx];
    final isLast = idx == _slides.length - 1;

    return Scaffold(
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, _) {
          return Container(
            width: screenWidth,
            height: screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFFEAEAAA),
                  const Color(0xFF2D4839).withValues(alpha: 0.82),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -screenWidth * 0.15,
                  top: -screenWidth * 0.15,
                  child: _buildImageCircle(
                    slide['image_top']!,
                    screenWidth * 1.05,
                  ),
                ),

                Positioned(
                  right: 24,
                  top: screenHeight * 0.12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [_logoText('Leaf n'), _logoText('Loaff')],
                  ),
                ),

                Positioned(
                  right: -screenWidth * 0.15,
                  top: screenHeight * 0.44,
                  child: _buildImageCircle(
                    slide['image_bottom']!,
                    screenWidth * 0.7,
                  ),
                ),

                Positioned(
                  left: 0,
                  bottom: screenHeight * 0.25,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: SlideTransition(
                      position: _slideAnim,
                      child: SizedBox(
                        width: screenWidth * 0.65,
                        child: Text(
                          slide['text']!,
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: const Color(0xFFFDFDFD),
                            fontSize: screenWidth * 0.1,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                            height: 1.10,
                            shadows: [
                              Shadow(
                                offset: const Offset(6, 6),
                                blurRadius: 4,
                                color: Colors.black.withValues(alpha: 0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  bottom: screenHeight * 0.13,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_slides.length, (i) {
                      final isActive = i == idx;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 1.4),
                        width: 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF1C3628)
                              : const Color(0xFF3D5A4A),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ),
                ),

                Positioned(
                  bottom: screenHeight * 0.05,
                  left: 16,
                  right: 16,
                  child: GestureDetector(
                    onTap: _handleNext,
                    child: Container(
                      height: 48,
                      decoration: ShapeDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        shadows: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          isLast ? 'Mulai' : 'Next',
                          style: TextStyle(
                            color: const Color(0xFFFDFDFD),
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 2,
                                color: Colors.black.withValues(alpha: 0.25),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImageCircle(String assetPath, double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF426E55).withValues(alpha: 0.3),
            child: const Icon(
              Icons.image_not_supported,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoText(String text) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: const Color(0xFFFDFDFD),
        fontSize: screenWidth * 0.18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800,
        height: 1.1,
        shadows: [
          Shadow(
            offset: const Offset(6, 6),
            blurRadius: 4,
            color: Colors.black.withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
