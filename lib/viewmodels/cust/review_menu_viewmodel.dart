import 'package:flutter/material.dart';
import '../../services/cust/review_menu_service.dart';

class ReviewMenuViewModel extends ChangeNotifier {
  final ReviewMenuService _service = ReviewMenuService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isAddingToCart = false;
  bool get isAddingToCart => _isAddingToCart;

  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;

  Future<void> fetchReviews(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _reviews = await _service.fetchReviews(productId);
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(String productId) async {
    _isAddingToCart = true;
    notifyListeners();

    try {
      final userId = _service.getCurrentUserId();
      if (userId == null) {
        throw Exception("Sesi telah habis, silakan login ulang.");
      }

      await _service.addToCart(
        userId: userId,
        productId: productId,
        quantity: 1,
      );

      _isAddingToCart = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isAddingToCart = false;
      notifyListeners();
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
