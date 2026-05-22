import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _dashboardStats = [
    {
      "title": "Today's Revenue",
      "value": "Rp. 300000",
      "subtitle": "+ Rp50.000 from yesterday",
      "percent": "16,67%",
    },
    {
      "title": "Today's Orders",
      "value": "24 Orders",
      "subtitle": "+ 4 orders from yesterday",
      "percent": "20,0%",
    },
    {
      "title": "New Customers",
      "value": "8 Users",
      "subtitle": "+ 2 users this week",
      "percent": "33,3%",
    },
    {
      "title": "Best Seller",
      "value": "Chicken Teriyaki\nSandwich",
      "subtitle": "12 sold today",
      "percent": "33,3%",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3D5A4A),
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Center(
          child: Container(
            width: 390,
            height:
                950,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: Color(0xFF3D5A4A)),
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
                  left: 25,
                  top: 67,
                  child: SizedBox(
                    width: 181,
                    child: Text(
                      'Today’s Overview',
                      style: TextStyle(
                        color: Color(0xFFFDFDFD),
                        fontSize: 19.17,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 25,
                  top: 93,
                  child: Opacity(
                    opacity: 0.70,
                    child: const Text(
                      'Sunday, May 3, 2026',
                      style: TextStyle(
                        color: Color(0xFFFDFDFD),
                        fontSize: 15,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        height: 1.10,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  top: 127,
                  height: 145,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    scrollBehavior: const MaterialScrollBehavior().copyWith(
                      dragDevices: {
                        PointerDeviceKind.mouse,
                        PointerDeviceKind.touch,
                        PointerDeviceKind.trackpad,
                      },
                    ),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _dashboardStats.length,
                    itemBuilder: (context, index) {
                      final stat = _dashboardStats[index];
                      return Container(
                        color: Colors.transparent,
                        child: _buildTopCard(
                          title: stat["title"],
                          value: stat["value"],
                          subtitle: stat["subtitle"],
                          percent: stat["percent"],
                        ),
                      );
                    },
                  ),
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  top: 252,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _dashboardStats.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? const Color(0xFF1C3628)
                              : const Color(0xFF3D5A4A),
                        ),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: 25,
                  top: 310,
                  child: _buildActionButton(
                    title: 'Create a new\ncatalog',
                    showIcon: true,
                  ),
                ),
                Positioned(
                  left: 201,
                  top: 310,
                  child: _buildActionButton(
                    title: 'See all\nreviews',
                    showIcon: false,
                  ),
                ),

                const Positioned(
                  left: 25,
                  top: 410,
                  child: Text(
                    'Recent Order',
                    style: TextStyle(
                      color: Color(0xFFFDFDFD),
                      fontSize: 19.17,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Positioned(
                  left: 184,
                  top: 415,
                  child: Opacity(
                    opacity: 0.70,
                    child: const Text(
                      'View All',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFFFDFDFD),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                _buildOrderCard(topPosition: 450, status: "Waiting"),
                _buildOrderCard(topPosition: 610, status: "Preparing"),
                _buildOrderCard(topPosition: 770, status: "Delivered"),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopCard({
    required String title,
    required String value,
    required String subtitle,
    required String percent,
  }) {
    bool isLongText = value.contains('\n');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, 0.00),
          end: Alignment(0.89, 1.32),
          colors: [Color(0xFFFDFDFD), Color(0xFF73986F)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF51725F)),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [BoxShadow(color: Color(0xFF51725F), blurRadius: 5)],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 23,
            top: 20,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF51725F),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Positioned(
            left: 23,
            top: 43,
            child: SizedBox(
              width: 290,
              child: Text(
                value,
                maxLines: 2,
                style: TextStyle(
                  color: const Color(0xFF2D4839),
                  fontSize: isLongText ? 23 : 35,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
          ),
          Positioned(
            left: 23,
            bottom: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF848383),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFDFDFD),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 0.80,
                        color: Color(0xFF2D4839),
                      ),
                      borderRadius: BorderRadius.circular(29.21),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_upward,
                        size: 8,
                        color: Color(0xFF51725F),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        percent,
                        style: const TextStyle(
                          color: Color(0xFF51725F),
                          fontSize: 6,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required String title, required bool showIcon}) {
    return Container(
      width: 164,
      height: 79,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(1.00, 1.00),
          end: Alignment(0.00, 0.00),
          colors: [Color(0xFFD699AB), Color(0xFFFDFDFD)],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
          Positioned(
            left: 12,
            top: 12,
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 15,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showIcon)
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                width: 20,
                height: 20,
                decoration: const ShapeDecoration(
                  shape: OvalBorder(
                    side: BorderSide(width: 2.5, color: Color(0xFF2D4839)),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required double topPosition,
    required String status,
  }) {
    return Positioned(
      left: 25,
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
                        text: ' Lorem ipsum dolor sit amet...',
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
                child: Center(
                  child: Text(
                    status,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFCA748D),
                      fontSize: 9.60,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
