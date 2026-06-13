import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/admin/admin_order_review_service.dart';

class AdminOrderReviewViewModel extends ChangeNotifier {
  final AdminOrderReviewService _service = AdminOrderReviewService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReviews(String orderId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.getReviewsByOrderId(orderId);

      _reviews = List<Map<String, dynamic>>.from(response);
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
