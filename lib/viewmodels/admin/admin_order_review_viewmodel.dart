import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/order_model.dart';
import '../../services/admin/admin_order_service.dart';

class AdminOrderReviewViewModel extends ChangeNotifier {
  final AdminOrderService _service = AdminOrderService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<OrderReviewModel> _reviews = [];
  List<OrderReviewModel> get reviews => _reviews;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReviews(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getReviewsByOrderId(orderId);
      _reviews = (response as List)
          .map((data) => OrderReviewModel.fromJson(data))
          .toList();
    } catch (e) {
      debugPrint("Gagal mengambil data review dari DB: $e");
      _errorMessage = e.toString();
      _reviews = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }
}
