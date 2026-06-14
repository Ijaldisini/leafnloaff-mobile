import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/dashboard_stat_model.dart';
import '../../models/recent_order_model.dart';
import '../../services/admin/admin_dashboard_service.dart';

class AdminDashboardViewModel extends ChangeNotifier {
  final AdminDashboardService _service = AdminDashboardService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<DashboardStatModel> _dashboardStats = [];
  List<DashboardStatModel> get dashboardStats => _dashboardStats;

  List<RecentOrderModel> _recentOrders = [];
  List<RecentOrderModel> get recentOrders => _recentOrders;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    notifyListeners();

    final now = DateTime.now();
    final startOfDay = DateTime(
      now.year,
      now.month,
      now.day,
    ).toUtc().toIso8601String();
    final endOfDay = DateTime(
      now.year,
      now.month,
      now.day,
      23,
      59,
      59,
    ).toUtc().toIso8601String();
    final startOfWeek = now
        .subtract(Duration(days: now.weekday - 1))
        .toUtc()
        .toIso8601String();

    double revenue = 0;
    int totalOrdersToday = 0;
    int newUsersCount = 0;
    String bestSellerName = "Belum ada order";
    int maxQty = 0;

    try {
      final ordersToday = await _service.getOrdersToday(startOfDay, endOfDay);
      totalOrdersToday = ordersToday.length;

      for (var order in ordersToday) {
        final status = order['status'].toString().toLowerCase();
        if (status != 'cancelled' && status != 'dibatalkan') {
          revenue += (order['total_price'] as num).toDouble();
        }
      }
    } catch (e) {
      debugPrint("VM Error: $e");
    }

    try {
      final newUsers = await _service.getNewCustomersThisWeek(startOfWeek);
      newUsersCount = newUsers.length;
    } catch (e) {
      debugPrint("VM Error: $e");
    }

    try {
      final orderItemsToday = await _service.getOrderItemsToday(
        startOfDay,
        endOfDay,
      );
      Map<String, int> itemCounts = {};

      for (var item in orderItemsToday) {
        final menuName = item['menus'] != null
            ? item['menus']['name']
            : 'Unknown';
        final qty = item['quantity'] as int;
        itemCounts[menuName] = (itemCounts[menuName] ?? 0) + qty;

        if (itemCounts[menuName]! > maxQty) {
          maxQty = itemCounts[menuName]!;
          bestSellerName = menuName;
        }
      }
    } catch (e) {
      debugPrint("VM Error: $e");
    }

    try {
      final recentData = await _service.getRecentOrders();
      _recentOrders = recentData.map((order) {
        final items = order['order_items'] as List<dynamic>? ?? [];
        String productName = "Unknown Item";
        int qty = 0;

        if (items.isNotEmpty) {
          qty = items[0]['quantity'] ?? 0;
          productName = items[0]['menus']?['name'] ?? "Unknown Item";
          if (items.length > 1) {
            productName += " +${items.length - 1} lainnya";
          }
        }

        return RecentOrderModel(
          id: order['id'].toString(),
          status: order['status']?.toString() ?? 'Unknown',
          createdAt: DateTime.parse(order['created_at']).toLocal(),
          totalPrice: (order['total_price'] as num).toDouble(),
          notes: order['notes']?.toString() ?? '',
          productName: productName,
          quantity: qty,
        );
      }).toList();
    } catch (e) {
      debugPrint("VM Error: $e");
    }

    final formattedRevenue = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(revenue);

    _dashboardStats = [
      DashboardStatModel(
        title: "Today's Revenue",
        value: formattedRevenue,
        subtitle: "Updated just now",
        percent: "0,0%",
      ),
      DashboardStatModel(
        title: "Today's Orders",
        value: "$totalOrdersToday Orders",
        subtitle: "Updated just now",
        percent: "0,0%",
      ),
      DashboardStatModel(
        title: "New Customers",
        value: "$newUsersCount Users",
        subtitle: "New this week",
        percent: "0,0%",
      ),
      DashboardStatModel(
        title: "Best Seller",
        value: bestSellerName.replaceAll(' ', '\n'),
        subtitle: "$maxQty sold today",
        percent: "0,0%",
      ),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<String?> performLogout() async {
    try {
      await _service.logout();
      return null;
    } catch (e) {
      return "Terjadi kesalahan saat logout. Silahkan coba lagi.";
    }
  }

  String getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Just now";
    if (diff.inMinutes < 60) return "${diff.inMinutes} Mins Ago";
    if (diff.inHours < 24) return "${diff.inHours} Hours Ago";
    return "${diff.inDays} Days Ago";
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }
}
