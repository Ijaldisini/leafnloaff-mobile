import 'package:flutter/material.dart';
import '../../services/cust/detail_order_service.dart';
import 'history_viewmodel.dart';

class DetailOrderViewModel extends ChangeNotifier {
  final DetailOrderService _service = DetailOrderService();

  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? orderData;

  double subTotal = 0;
  double shippingCost = 0;
  double discount = 0;
  double totalPayment = 0;

  Future<void> fetchOrder(String orderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orderData = await _service.fetchOrderDetails(orderId);
      _calculateSummary();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _calculateSummary() {
    if (orderData == null) return;

    subTotal = 0;
    final items = orderData!['order_items'] as List<dynamic>? ?? [];
    for (var item in items) {
      final price = (item['price_at_time'] as num).toDouble();
      final qty = (item['quantity'] as num).toInt();
      subTotal += (price * qty);
    }

    discount = (orderData!['discount_applied'] as num?)?.toDouble() ?? 0;
    totalPayment = (orderData!['total_price'] as num).toDouble();

    shippingCost = totalPayment - subTotal + discount;
  }

  Future<bool> cancelOrder() async {
    if (orderData == null) return false;
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateOrderStatus(orderData!['id'], 'Dibatalkan');
      await fetchOrder(orderData!['id']);
      HistoryViewModel().fetchHistory();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> receiveOrder() async {
    if (orderData == null) return false;
    isLoading = true;
    notifyListeners();
    try {
      await _service.updateOrderStatus(orderData!['id'], 'Selesai');
      await fetchOrder(orderData!['id']);
      HistoryViewModel().fetchHistory();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
