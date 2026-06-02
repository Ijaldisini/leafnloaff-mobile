import 'package:flutter/material.dart';
import '../viewmodels/welcome_viewmodel.dart';

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

  // Data tiap slide
  final List<Map<String, String>> _slides = [
    {
      'title': 'Fuel Your\nHustle',
      'subtitle': 'Makanan sehat untuk hari yang produktif.',
      'image_top': 'assets/images/sandwich-welcome-page-atas.png',
      'image_bottom': 'assets/images/sandwich-welcome-page-bawah.png',
    },
    {
      'title': 'Wholesome\nIngredients',
      'subtitle': 'Bahan segar pilihan di setiap gigitan.',
      'image_top': 'assets/images/sandwich-welcome-page-atas.png',
      'image_bottom': 'assets/images/sandwich-welcome-page-bawah.png',
    },
    {
      'title': 'Real\nNutrition',
      'subtitle': 'Makanan sederhana, nutrisi nyata.',
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

    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.08, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFEAEAAA), Color(0xFF2D4839)],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [

                  // ─── Gambar atas (lingkaran kiri atas) ───────
                  Positioned(
                    left: -screenWidth * 0.18,
                    top: -screenHeight * 0.04,
                    child: _buildImageCircle(
                      slide['image_top']!,
                      screenWidth * 0.85,
                    ),
                  ),

                  // ─── Gambar bawah (lingkaran kanan tengah) ───
                  Positioned(
                    right: -screenWidth * 0.08,
                    top: screenHeight * 0.38,
                    child: _buildImageCircle(
                      slide['image_bottom']!,
                      screenWidth * 0.62,
                    ),
                  ),

                  // ─── Overlay gelap tipis ──────────────────────
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.15),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.6, 1.0],
                      ),
                    ),
                  ),

                  // ─── Logo "Leaf n Loaff" ──────────────────────
                  Positioned(
                    right: 24,
                    top: screenHeight * 0.06,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _logoText('Leaf n'),
                        _logoText('Loaff'),
                      ],
                    ),
                  ),

                  // ─── Tagline + subtitle (animasi) ────────────
                  Positioned(
                    left: 24,  // ✅ Fixed left padding
                    right: 24,  // ✅ Fixed right padding (bukan persentase)
                    bottom: screenHeight * 0.22,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: SlideTransition(
                        position: _slideAnim,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pill label
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFCA748D).withOpacity(0.85),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Text(
                                '${idx + 1} / ${_slides.length}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            Text(
                              slide['title']!,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.085,  
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                height: 1.0, 
                                letterSpacing: -1,  
                                shadows: [
                                  Shadow(
                                    offset: const Offset(3, 3),
                                    blurRadius: 8,
                                    color: Colors.black.withOpacity(0.3),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            // Subtitle
                            Text(
                              slide['subtitle']!,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 14,  // ✅ Sedikit lebih besar
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(1, 1),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ─── Dot indicator ────────────────────────────
                  Positioned(
                    bottom: screenHeight * 0.135,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (i) {
                        final isActive = i == idx;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? const Color(0xFFCA748D)
                                : Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        );
                      }),
                    ),
                  ),

                  // ─── Tombol Next / Start ──────────────────────
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: screenHeight * 0.045,
                    child: GestureDetector(
                      onTap: () => _viewModel.onNextPressed(context),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 52,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                          ),
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFCA748D).withOpacity(0.45),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              isLast ? 'START' : 'Selanjutnya',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isLast
                                    ? Icons.check_rounded
                                    : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
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

  // ─── Helpers ─────────────────────────────────────

  Widget _buildImageCircle(String assetPath, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFF426E55).withOpacity(0.3),
            child: const Icon(
              Icons.lunch_dining,
              color: Colors.white54,
              size: 64,
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoText(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 68,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w800,
        height: 1.05,
        shadows: [
          Shadow(
            offset: const Offset(4, 4),
            blurRadius: 8,
            color: Colors.black.withOpacity(0.3),
          ),
        ],
      ),
    );
  }
}