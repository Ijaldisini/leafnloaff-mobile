import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../viewmodels/cust/customer_main_viewmodel.dart';
import 'home_view.dart';
import 'profile_view.dart';
import 'cart_view.dart';
import 'notification_view.dart';

class CustomerMainView extends StatefulWidget {
  final UserModel user;

  const CustomerMainView({super.key, required this.user});

  @override
  State<CustomerMainView> createState() => _CustomerMainViewState();
}

class _CustomerMainViewState extends State<CustomerMainView> {
  final CustomerMainViewModel _viewModel = CustomerMainViewModel();

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeView(user: widget.user),
      const CartView(),
      const NotificationView(),
      ProfileView(user: widget.user),
    ];
  }

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
              IndexedStack(index: _viewModel.selectedIndex, children: _pages),

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 110,
                child: Container(
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
                left: 24,
                right: 24,
                bottom: 20,
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
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNavItem(0, Icons.home_rounded, 'Home'),
                      _buildNavItem(1, Icons.shopping_cart_outlined, 'Cart'),
                      _buildNavItem(2, Icons.notifications_outlined, 'Notif'),
                      _buildNavItem(3, Icons.person_outline, 'Profile'),
                    ],
                  ),
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
                  fontSize: 18,
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
