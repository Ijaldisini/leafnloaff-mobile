import 'package:flutter/material.dart';
import 'admin_dashboard_view.dart';
import 'admin_menu_management_view.dart';
import 'admin_order_management_view.dart';
import 'admin_notification_view.dart';
import 'admin_voucher_view.dart';
import '../../models/user_model.dart';


class AdminMainView extends StatefulWidget {
  final UserModel user;

  const AdminMainView({super.key, required this.user});

  @override
  State<AdminMainView> createState() => _AdminMainViewState();
}

class _AdminMainViewState extends State<AdminMainView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3D5A4A),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: const [
              AdminDashboardView(),
              AdminOrderManagementView(),
              AdminMenuManagementView(),
              AdminNotificationView(),
              AdminVoucherView(),
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
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Color(0xFF3D5A4A), Color(0x003E5A4A)],
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xFF3D5A4A),
                  padding: const EdgeInsets.only(
                    bottom: 30,
                    left: 15,
                    right: 15,
                  ),
                  child: Container(
                    height: 50,
                    decoration: ShapeDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildNavItem(index: 0, title: 'Home'),
                        _buildNavItem(index: 1, title: 'Order'),
                        _buildNavItem(index: 2, title: 'Menu'),
                        _buildNavItem(index: 3, title: 'Notif'),
                        _buildNavItem(
                          index: 4,
                          title: 'Voucher',
                        ),
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
  }

  Widget _buildNavItem({required int index, required String title}) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: ShapeDecoration(
          color: isActive ? const Color(0xFFEED5DB) : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(97.66),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFFCA748D) : const Color(0xFFFDFDFD),
            fontSize: 12,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
