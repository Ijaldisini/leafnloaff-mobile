import 'package:flutter/material.dart';
import '../../services/cust/review_menu_service.dart';
import '../../models/review_model.dart';
import 'cart_viewmodel.dart';

class ReviewMenuViewModel extends ChangeNotifier {
  final ReviewMenuService _service = ReviewMenuService();

  bool _isDisposed = false;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isAddingToCart = false;
  bool get isAddingToCart => _isAddingToCart;

  List<ReviewModel> _reviews = [];
  List<ReviewModel> get reviews => _reviews;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  Future<void> fetchReviews(String productId) async {
    _isLoading = true;
    safeNotifyListeners();

    try {
      _reviews = await _service.fetchReviews(productId);
    } catch (e) {
      debugPrint('Error fetching reviews: $e');
    } finally {
      _isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> addToCart(String productId) async {
    _isAddingToCart = true;
    safeNotifyListeners();

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

      CartViewModel().loadCartData();

      _isAddingToCart = false;
      safeNotifyListeners();
      return true;
    } catch (e) {
      _isAddingToCart = false;
      safeNotifyListeners();
      throw Exception(e.toString().replaceAll("Exception: ", ""));
    }
  }
}
