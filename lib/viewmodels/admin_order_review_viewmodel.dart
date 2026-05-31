import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/order_review_model.dart';
import '../services/admin_order_review_service.dart';

class AdminOrderReviewViewModel extends ChangeNotifier {
  final AdminOrderReviewService _service = AdminOrderReviewService();

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

      if (response.isEmpty) {
        _reviews = [];
      } else {
        _reviews = response.expand<OrderReviewModel>((data) {
          final orders = data['orders'] ?? {};
          final orderItems = orders['order_items'] as List<dynamic>? ?? [];

          List<String> images = [];
          if (data['image_urls'] != null) {
            images = List<String>.from(data['image_urls']);
          }

          return orderItems.map((item) {
            final menu = item['menus'] ?? {};
            return OrderReviewModel(
              itemName: menu['name']?.toString() ?? 'Unknown Item',
              itemImageUrl: menu['image_url']?.toString(),
              notes: item['notes']?.toString() ?? '-',
              qty: item['quantity'] ?? 1,
              price: (menu['price'] as num?)?.toDouble() ?? 0.0,
              rating: data['rating'] ?? 5,
              reviewText: data['review_text']?.toString() ?? '',
              reviewImages: images,
            );
          });
        }).toList();
      }
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
