// lib/utils/app_navigator.dart

import 'package:flutter/material.dart';
import '../views/login_view.dart';
import '../views/register_view.dart';
import '../views/home_view.dart';
import '../views/detail_menu_view.dart';
import '../models/user_model.dart';

class AppNavigator {
  static void toLogin(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      _fade(const LoginView()),
      (route) => false,
    );
  }

  static void toRegister(BuildContext context) {
    Navigator.push(context, _slide(const RegisterView()));
  }

  /// Ke Home setelah login berhasil, hapus semua history
  static void toHome(BuildContext context, UserModel user) {
    Navigator.pushAndRemoveUntil(
      context,
      _fade(HomeView(user: user)),
      (route) => false,
    );
  }

  static void toDetailMenu(
    BuildContext context, {
    required String productId,
    required String productName,
    required String productImage,
    required int price,
    required String description,
    double rating = 5.0,
    int totalReviews = 0,
    Map<int, int>? ratingDistribution,
  }) {
    Navigator.push(
      context,
      _slideUp(
        DetailMenuView(
          productId: productId,
          productName: productName,
          productImage: productImage,
          price: price,
          description: description,
          rating: rating,
          totalReviews: totalReviews,
          ratingDistribution: ratingDistribution,
        ),
      ),
    );
  }

  static void back(BuildContext context) {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  static PageRouteBuilder _fade(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  static PageRouteBuilder _slide(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  static PageRouteBuilder _slideUp(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        final tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}