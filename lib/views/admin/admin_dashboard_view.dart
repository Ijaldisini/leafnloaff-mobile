import 'package:flutter/material.dart';

class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: 390,
            height: 844,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Color(0xFF3D5A4A)
            ),
            child: Stack(
              children: [
                Positioned(
                  left: -17,
                  top: -30,
                  child: Container(
                    width: 422,
                    height: 289,
                    decoration: const BoxDecoration(color: Color(0xFFD699AB)),
                  ),
                ),
                Positioned(
                  left: -17,
                  top: 147,
                  child: Container(
                    width: 422,
                    height: 114,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.50, -0.00),
                        end: Alignment(0.50, 1.00),
                        colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 32,
                  top: 67,
                  child: SizedBox(
                    width: 181,
                    child: Text(
                      'Today’s Overview',
                      style: TextStyle(
                        color: Color(0xFF2D4839),
                        fontSize: 19.17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 32,
                  top: 93,
                  child: Text(
                    'Sunday, May 3, 2026',
                    style: TextStyle(
                      color: Color(0xFF51725F),
                      fontSize: 15,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      height: 1.10,
                    ),
                  ),
                ),
                Positioned(
                  left: 28,
                  top: 127,
                  child: Container(
                    width: 334,
                    height: 139,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.00, 0.00),
                        end: Alignment(0.89, 1.32),
                        colors: [Color(0xFFFDFDFD), Color(0xFF73986F)],
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 1,
                          color: Color(0xFF51725F),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0xFF51725F),
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 165,
                  top: 218,
                  child: Container(
                    width: 31,
                    height: 10,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFFDFDFD),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          width: 0.50,
                          color: Color(0xFF2D4839),
                        ),
                        borderRadius: BorderRadius.circular(29.21),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 174,
                  top: 220,
                  child: SizedBox(
                    width: 19,
                    child: Text(
                      '16,67%',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF51725F),
                        fontSize: 5.71,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 45,
                  top: 147,
                  child: SizedBox(
                    width: 181,
                    child: Text(
                      'Today’s Revenue',
                      style: TextStyle(
                        color: Color(0xFF51725F),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 45,
                  top: 218,
                  child: SizedBox(
                    width: 115,
                    child: Text(
                      '+ Rp50.000 this month',
                      style: TextStyle(
                        color: Color(0xFF848383),
                        fontSize: 10,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 45,
                  top: 170,
                  child: SizedBox(
                    width: 224,
                    child: Text(
                      'Rp. 300000',
                      style: TextStyle(
                        color: Color(0xFF2D4839),
                        fontSize: 35,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 204.50,
                  top: 254,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF3D5A4A),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 197.50,
                  top: 254,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF3D5A4A),
                      shape: OvalBorder(),
                    ),
                  ),
                ),
                Positioned(
                  left: 190.50,
                  top: 254,
                  child: Container(
                    width: 5,
                    height: 5,
                    decoration: const ShapeDecoration(
                      color: Color(0xFF1C3628),
                      shape: OvalBorder(),
                    ),
                  ),
                ),

                _buildOrderCard(topPosition: 435),
                _buildOrderCard(topPosition: 593),
                _buildOrderCard(topPosition: 751),

                Positioned(
                  left: 22,
                  top: 401,
                  child: SizedBox(
                    width: 181,
                    child: Text(
                      'Recent Order',
                      style: TextStyle(
                        color: const Color(0xFFFDFDFD),
                        fontSize: 19.17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        height: 1.10,
                        shadows: [
                          Shadow(
                            offset: const Offset(2, 2),
                            blurRadius: 4,
                            color: const Color(0xFF000000).withValues(alpha: 0.25),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 181,
                  top: 406,
                  child: SizedBox(
                    width: 181,
                    child: Opacity(
                      opacity: 0.70,
                      child: Text(
                        'View All',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: const Color(0xFFFDFDFD),
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.10,
                          shadows: [
                            Shadow(
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              color: const Color(0xFF000000).withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: -12,
                  top: 717,
                  child: Container(
                    width: 414,
                    height: 130,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.50, 0.60),
                        end: Alignment(0.50, 0.00),
                        colors: [Color(0xFF3D5A4A), Color(0x003E5A4A)],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 22,
                  top: 771,
                  child: Container(
                    width: 340,
                    height: 42,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment(0.50, 0.00),
                        end: Alignment(0.50, 1.00),
                        colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(120),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x3F000000),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 27,
                  top: 775,
                  child: Container(
                    width: 105,
                    height: 34.26,
                    decoration: ShapeDecoration(
                      color: const Color(0xFFEED5DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(97.66),
                      ),
                    ),
                  ),
                ),
                const Positioned(
                  left: 64.07,
                  top: 784.75,
                  child: SizedBox(
                    width: 57.25,
                    child: Text(
                      'Home',
                      style: TextStyle(
                        color: Color(0xFFCA748D),
                        fontSize: 18.22,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard({required double topPosition}) {
    return Positioned(
      left: 22,
      top: topPosition,
      child: Container(
        width: 340,
        height: 143,
        decoration: ShapeDecoration(
          color: const Color(0xFFFDFDFD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.69),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            const Positioned(
              left: 13,
              top: 10,
              child: Text(
                'Order’s ID',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Positioned(
              left: 13,
              top: 112,
              child: Text(
                'Rp. 12000',
                style: TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const Positioned(
              left: 13,
              top: 58,
              child: SizedBox(
                width: 231,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Notes:',
                        style: TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        style: TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 261,
              top: 10,
              child: SizedBox(
                width: 63,
                child: Text(
                  '1 Minutes Ago',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 8,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 13,
              top: 33,
              child: SizedBox(
                width: 231,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Product:',
                        style: TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text:
                            ' Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                        style: TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 13,
              top: 83,
              child: SizedBox(
                width: 172,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Qty:',
                        style: TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      TextSpan(
                        text: ' 1',
                        style: TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 10,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 261,
              top: 23,
              child: Container(
                width: 63.20,
                height: 20,
                decoration: ShapeDecoration(
                  color: const Color(0xFFEED5DB),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      width: 0.80,
                      color: Color(0xFFCA748D),
                    ),
                    borderRadius: BorderRadius.circular(19.92),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 277,
              top: 27.80,
              child: Text(
                'Status',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFCA748D),
                  fontSize: 9.60,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
