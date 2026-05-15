import 'package:flutter/material.dart';
import '../viewmodels/welcome_viewmodel.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final WelcomeViewModel _viewModel = WelcomeViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _viewModel,
        builder: (context, child) {
          return ListView(
            children: [
              Column(
                children: [
                  Container(
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
                          left: 16.94,
                          top: 772.50,
                          child: GestureDetector(
                            onTap: () => _viewModel.onNextPressed(context),
                            child: Container(
                              width: 356.11,
                              height: 38,
                              decoration: ShapeDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment(0.50, 0.00),
                                  end: Alignment(0.50, 1.00),
                                  colors: [
                                    Color(0xFFD699AB),
                                    Color(0xFFCA748D),
                                  ],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(108.57),
                                ),
                                shadows: const [
                                  BoxShadow(
                                    color: Color(0x3F000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 4),
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 169,
                          top: 774.67,
                          child: GestureDetector(
                            onTap: () => _viewModel.onNextPressed(context),
                            child: Text(
                              _viewModel.currentSlideIndex == 2
                                  ? 'Start'
                                  : 'Next',
                              style: TextStyle(
                                color: const Color(0xFFFDFDFD),
                                fontSize: 20.99,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(2, 2),
                                    blurRadius: 2,
                                    color: const Color(
                                      0xFF000000,
                                    ).withOpacity(0.25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: -85,
                          top: -52,
                          child: Container(
                            width: 415,
                            height: 415,
                            decoration: const ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/sandwich-welcome-page-atas.png",
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 195,
                          top: 376,
                          child: Container(
                            width: 270,
                            height: 270,
                            decoration: const ShapeDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                  "assets/images/sandwich-welcome-page-bawah.png",
                                ),
                                fit: BoxFit.fill,
                              ),
                              shape: OvalBorder(),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 116,
                          top: 87,
                          child: SizedBox(
                            width: 237.38,
                            child: Text(
                              'Leaf n ',
                              style: TextStyle(
                                color: const Color(0xFFFDFDFD),
                                fontSize: 74.88,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                height: 1.10,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(6, 6),
                                    blurRadius: 4,
                                    color: const Color(
                                      0xFF000000,
                                    ).withOpacity(0.50),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 119,
                          top: 166,
                          child: SizedBox(
                            width: 237.38,
                            child: Text(
                              'Loaff',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFFFDFDFD),
                                fontSize: 74.88,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                height: 1.10,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(6, 6),
                                    blurRadius: 4,
                                    color: const Color(
                                      0xFF000000,
                                    ).withOpacity(0.50),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 2,
                          top: 531,
                          child: SizedBox(
                            width: 237.38,
                            child: Text(
                              _viewModel.currentSlideIndex == 0
                                  ? 'Fuel Your Hustle'
                                  : _viewModel.currentSlideIndex == 1
                                  ? 'Wholesome ingredients in every bite.'
                                  : 'Simple food, real nutrition.',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                color: const Color(0xFFFDFDFD),
                                fontSize: _viewModel.currentSlideIndex == 0
                                    ? 40
                                    : 30,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w700,
                                height: 1.10,
                                shadows: [
                                  Shadow(
                                    offset: const Offset(6, 6),
                                    blurRadius: 4,
                                    color: const Color(
                                      0xFF000000,
                                    ).withOpacity(0.50),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: 181.70,
                          top: 746.50,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: ShapeDecoration(
                              color: _viewModel.currentSlideIndex == 0
                                  ? const Color(0xFF1C3628)
                                  : const Color(0xFF3D5A4A),
                              shape: const OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 191.50,
                          top: 746.50,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: ShapeDecoration(
                              color: _viewModel.currentSlideIndex == 1
                                  ? const Color(0xFF1C3628)
                                  : const Color(0xFF3D5A4A),
                              shape: const OvalBorder(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 201.30,
                          top: 746.50,
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: ShapeDecoration(
                              color: _viewModel.currentSlideIndex == 2
                                  ? const Color(0xFF1C3628)
                                  : const Color(0xFF3D5A4A),
                              shape: const OvalBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}