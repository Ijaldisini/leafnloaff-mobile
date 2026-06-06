import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../services/cust/history_service.dart';

class HistoryViewModel extends ChangeNotifier {
  static final HistoryViewModel _instance = HistoryViewModel._internal();
  factory HistoryViewModel() => _instance;
  HistoryViewModel._internal();

  final HistoryService _service = HistoryService();

  bool isLoading = false;
  String? errorMessage;

  Map<String, List<Map<String, dynamic>>> groupedOrders = {};

  Future<void> fetchHistory() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final orders = await _service.fetchUserHistory();
      _groupOrdersByDate(orders);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _groupOrdersByDate(List<Map<String, dynamic>> orders) {
    groupedOrders.clear();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var order in orders) {
      final createdAt = DateTime.parse(order['created_at']).toLocal();
      final orderDate = DateTime(
        createdAt.year,
        createdAt.month,
        createdAt.day,
      );

      String dateKey;
      if (orderDate == today) {
        dateKey = 'Today';
      } else if (orderDate == yesterday) {
        dateKey = 'Yesterday';
      } else {
        dateKey = DateFormat('MMM d, yyyy').format(orderDate);
      }

      if (!groupedOrders.containsKey(dateKey)) {
        groupedOrders[dateKey] = [];
      }
      groupedOrders[dateKey]!.add(order);
    }
  }

  double getProgress(String status) {
    switch (status) {
      case 'Diproses':
        return 0.33;
      case 'Dikirim':
        return 0.66;
      case 'Selesai':
        return 1.0;
      default:
        return 0.0;
    }
  }

  String extractProductNames(List<dynamic> orderItems) {
    if (orderItems.isEmpty) return '-';
    final names = orderItems.map((item) {
      final menu = item['menus'] as Map<String, dynamic>?;
      return menu?['name'] ?? 'Unknown';
    }).toList();
    return names.join(', ');
  }

  int calculateTotalQty(List<dynamic> orderItems) {
    int total = 0;
    for (var item in orderItems) {
      total += (item['quantity'] as int?) ?? 0;
    }
    return total;
  }

  String formatCurrency(dynamic amount) {
    final numValue = num.tryParse(amount.toString()) ?? 0;
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(numValue);
  }
}
