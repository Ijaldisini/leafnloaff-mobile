import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../services/cust/history_service.dart';
import '../../models/order_model.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryService _service;

  HistoryViewModel({required HistoryService service}) : _service = service;

  bool isLoading = false;
  Map<String, List<OrderHistoryModel>> groupedOrders = {};

  Future<void> fetchHistory({Function(String)? onError}) async {
    isLoading = true;
    notifyListeners();

    try {
      final orders = await _service.fetchUserHistory();
      _groupOrdersByDate(orders);
    } catch (e) {
      onError?.call(e.toString());
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _groupOrdersByDate(List<OrderHistoryModel> orders) {
    groupedOrders.clear();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var order in orders) {
      final orderDate = DateTime(
        order.createdAt.year,
        order.createdAt.month,
        order.createdAt.day,
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
}
