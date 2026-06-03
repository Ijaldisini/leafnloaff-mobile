import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import 'package:leafnloaff/viewmodels/admin/admin_dashboard_viewmodel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../login_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final AdminDashboardViewModel _viewModel = AdminDashboardViewModel();
  final PageController _pageController = PageController();

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _viewModel.fetchDashboardData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _handleLogout() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin keluar?',
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Batal',
                style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await Supabase.instance.client.auth.signOut();
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayDateStr = DateFormat('EEEE, MMM d, yyyy').format(DateTime.now());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, child) {
          if (_viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFD699AB)),
            );
          }

          return Stack(
            children: [
              Positioned(
                left: -17,
                top: -30,
                child: Container(
                  width: screenWidth + 34,
                  height: 289,
                  decoration: const BoxDecoration(color: Color(0xFFD699AB)),
                ),
              ),

              Positioned(
                left: -17,
                top: 147,
                child: Container(
                  width: screenWidth + 34,
                  height: 114,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0x003D5A4A), Color(0xFF3D5A4A)],
                    ),
                  ),
                ),
              ),

              SafeArea(
                child: RefreshIndicator(
                  color: const Color(0xFFCA748D),
                  onRefresh: _viewModel.fetchDashboardData,
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 100),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Today's Overview",
                                  style: TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 19.17,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w800,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                        color: Color(0x3F000000),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Opacity(
                                  opacity: 0.70,
                                  child: Text(
                                    todayDateStr,
                                    style: const TextStyle(
                                      color: Color(0xFFFDFDFD),
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            IconButton(
                              onPressed: _handleLogout,
                              icon: const Icon(
                                Icons.logout,
                                color: Colors.white,
                                size: 28,
                              ),
                              tooltip: 'Logout',
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 145,
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          scrollBehavior: const MaterialScrollBehavior()
                              .copyWith(
                                dragDevices: {
                                  PointerDeviceKind.mouse,
                                  PointerDeviceKind.touch,
                                  PointerDeviceKind.trackpad,
                                },
                              ),
                          onPageChanged: (index) {
                            setState(() => _currentPage = index);
                          },
                          itemCount: _viewModel.dashboardStats.length,
                          itemBuilder: (context, index) {
                            final stat = _viewModel.dashboardStats[index];
                            return _buildTopCard(
                              title: stat.title,
                              value: stat.value,
                              subtitle: stat.subtitle,
                              percent: stat.percent,
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _viewModel.dashboardStats.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentPage == index
                                  ? const Color(0xFF1C3628)
                                  : const Color(
                                      0xFFEED5DB,
                                    ).withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildActionButton(
                                title: 'Create a\nnew menu',
                                icon: Icons.add_circle_outline,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildActionButton(
                                title: 'Create a\nnew voucher',
                                icon: Icons.confirmation_number_outlined,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _buildActionButton(
                                title: 'See all\nreviews',
                                icon: Icons.chat_bubble_outline,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Recent Order',
                              style: TextStyle(
                                color: Color(0xFFFDFDFD),
                                fontSize: 19.17,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w800,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                    color: Color(0x3F000000),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                              },
                              child: Opacity(
                                opacity: 0.70,
                                child: const Text(
                                  'View All',
                                  style: TextStyle(
                                    color: Color(0xFFFDFDFD),
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(2, 2),
                                        blurRadius: 4,
                                        color: Color(0x3F000000),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 15),

                      if (_viewModel.recentOrders.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Text(
                            "Belum ada order hari ini.",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        )
                      else
                        ..._viewModel.recentOrders.map((order) {
                          final priceFormatted = NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp. ',
                            decimalDigits: 0,
                          ).format(order.totalPrice);

                          final safeId = order.id.length >= 8
                              ? order.id.substring(0, 8).toUpperCase()
                              : order.id.toUpperCase();

                          return Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                              right: 25,
                              bottom: 15,
                            ),
                            child: _buildOrderCard(
                              orderId: safeId,
                              status: _capitalize(order.status),
                              price: priceFormatted,
                              productName: order.productName,
                              qty: order.quantity.toString(),
                              timeAgo: _viewModel.getTimeAgo(order.createdAt),
                              notes: order.notes ?? '',
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFDFDFD), Color(0xFF73986F)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF51725F)),
          borderRadius: BorderRadius.circular(20),
        ),
        shadows: const [BoxShadow(color: Color(0xFF51725F), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF51725F),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: const Color(0xFF2D4839),
              fontSize: isLongText ? 23 : 35,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          Row(
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
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
        ],
      ),
    );
  }

  Widget _buildActionButton({required String title, required IconData icon}) {
    return GestureDetector(
      onTap: () {
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(1.00, 1.00),
            end: Alignment(0.00, 0.00),
            colors: [Color(0xFFD699AB), Color(0xFFFDFDFD)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
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
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF2D4839),
                fontSize: 12,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  color: Color(0xFFCA748D),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard({
    required String orderId,
    required String status,
    required String price,
    required String productName,
    required String qty,
    required String timeAgo,
    required String notes,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order's ID: $orderId",
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 16,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                timeAgo,
                style: const TextStyle(
                  color: Color(0xFF51725F),
                  fontSize: 8,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Product: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: productName,
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          if (notes.isNotEmpty && notes != 'null') ...[
            Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'Notes: ',
                    style: TextStyle(
                      color: Color(0xFF51725F),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: notes,
                    style: const TextStyle(
                      color: Color(0xFF51725F),
                      fontSize: 10,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
          ],
          Text.rich(
            TextSpan(
              children: [
                const TextSpan(
                  text: 'Qty: ',
                  style: TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                TextSpan(
                  text: qty,
                  style: const TextStyle(
                    color: Color(0xFF51725F),
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Color(0xFF2D4839),
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
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
            ],
          ),
        ],
      ),
    );
  }
}
