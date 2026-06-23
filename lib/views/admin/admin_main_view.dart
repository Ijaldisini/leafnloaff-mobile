import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../viewmodels/admin/admin_main_viewmodel.dart';
import 'admin_dashboard_view.dart';
import 'admin_menu_management_view.dart';
import 'admin_order_management_view.dart';
import 'admin_notification_view.dart';
import 'admin_voucher_view.dart';

class AdminMainView extends StatefulWidget {
  final UserModel user;

  const AdminMainView({super.key, required this.user});

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

class _AdminMainViewState extends State<AdminMainView> {
  final AdminMainViewModel _viewModel = AdminMainViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final bool isSmallScreen = screenWidth < 430;
    final bool isVerySmallScreen = screenWidth < 360;

    final double outerPadding = isVerySmallScreen
        ? 12.0
        : (isSmallScreen ? 16.0 : 24.0);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF3D5A4A),
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              IndexedStack(
                index: _viewModel.selectedIndex,
                children: [
                  AdminDashboardView(
                    onNavigate: (index) {
                      _viewModel.setSelectedIndex(index);
                    },
                  ),
                  const AdminOrderManagementView(),
                  const AdminMenuManagementView(),
                  const AdminNotificationView(),
                  const AdminVoucherView(),
                ],
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFF3D5A4A), Color(0x003D5A4A)],
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: outerPadding,
                      vertical: 12,
                    ),
                    child: Container(
                      height: 58,
                      padding: EdgeInsets.symmetric(
                        horizontal: isVerySmallScreen ? 4 : 8,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xFFD699AB), Color(0xFFCA748D)],
                        ),
                        borderRadius: BorderRadius.circular(120),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x3F000000),
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildNavItem(
                            0,
                            Icons.home_rounded,
                            'Home',
                            isSmallScreen,
                            isVerySmallScreen,
                          ),
                          _buildNavItem(
                            1,
                            Icons.receipt_long_rounded,
                            'Order',
                            isSmallScreen,
                            isVerySmallScreen,
                          ),
                          _buildNavItem(
                            2,
                            Icons.restaurant_menu_rounded,
                            'Menu',
                            isSmallScreen,
                            isVerySmallScreen,
                          ),
                          _buildNavItem(
                            3,
                            Icons.notifications_outlined,
                            'Notif',
                            isSmallScreen,
                            isVerySmallScreen,
                          ),
                          _buildNavItem(
                            4,
                            Icons.confirmation_number_outlined,
                            'Voucher',
                            isSmallScreen,
                            isVerySmallScreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    bool isSmallScreen,
    bool isVerySmallScreen,
  ) {
    final isActive = _viewModel.selectedIndex == index;

    final double activePadding = isVerySmallScreen
        ? 10.0
        : (isSmallScreen ? 12.0 : 16.0);
    final double inactivePadding = isVerySmallScreen
        ? 6.0
        : (isSmallScreen ? 8.0 : 12.0);
    final double iconSize = isVerySmallScreen
        ? 18.0
        : (isSmallScreen ? 20.0 : 24.0);
    final double textSize = isVerySmallScreen
        ? 11.0
        : (isSmallScreen ? 13.0 : 16.0);

    return GestureDetector(
      onTap: () => _viewModel.setSelectedIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? activePadding : inactivePadding,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFEED5DB) : Colors.transparent,
          borderRadius: BorderRadius.circular(97.66),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFFCA748D) : Colors.white,
              size: iconSize,
            ),
            if (isActive) ...[
              SizedBox(width: isVerySmallScreen ? 4 : 6),
              Text(
                label,
                style: TextStyle(
                  color: const Color(0xFFCA748D),
                  fontSize: textSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
