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
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF3D5A4A),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 110, 
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Color(0xFF3D5A4A), Color(0x003D5A4A)],
                        ),
                      ),
                    ),
                    Container(
                      color: const Color(0xFF3D5A4A),
                      padding: const EdgeInsets.only(
                        bottom: 30,
                        left: 24,
                        right: 24,
                      ),
                      child: Container(
                        height: 58,  
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
                            _buildNavItem(0, Icons.home_rounded, 'Home'),
                            _buildNavItem(1, Icons.receipt_long_rounded, 'Order'),
                            _buildNavItem(2, Icons.restaurant_menu_rounded, 'Menu'),
                            _buildNavItem(3, Icons.notifications_outlined, 'Notif'),
                            _buildNavItem(4, Icons.confirmation_number_outlined, 'Voucher'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _viewModel.selectedIndex == index;

    return GestureDetector(
      onTap: () => _viewModel.setSelectedIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 16 : 12,
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
              size: 24,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFCA748D),
                  fontSize: 16,
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