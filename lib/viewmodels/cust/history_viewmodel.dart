import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/models/order_detail_model.dart';
import '/services/cust/history_service.dart';

class HistoryViewModel extends ChangeNotifier {
  final HistoryService _service = HistoryService();

  List<OrderDetailModel> orders = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchHistory(String userId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orders = await _service.fetchUserOrders(userId);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final orderDate = DateTime(date.year, date.month, date.day);

    if (orderDate == today) {
      return 'Today';
    } else if (orderDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }
}
