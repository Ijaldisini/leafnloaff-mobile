import 'package:flutter/material.dart';
import '../../services/cust/review_order_service.dart';
import '../../models/review_model.dart';

class ReviewOrderViewModel extends ChangeNotifier {
  final ReviewOrderService _service = ReviewOrderService();

  bool isLoading = false;
  List<ReviewModel> orderReviews = [];

  Future<bool> submitAllReviews(
    String orderId,
    List<ReviewSubmitModel> reviewsData, {
    Function(String)? onError,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      for (var review in reviewsData) {
        await _service.submitReview(orderId, review);
      }

      await _service.sendReviewNotificationToAdmin(orderId);

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      onError?.call('Gagal mengirim ulasan: ${e.toString()}');
      return false;
    }
  }

  Future<void> fetchReviewsForOrder(
    String orderId, {
    Function(String)? onError,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      orderReviews = await _service.fetchReviewsByOrder(orderId);
    } catch (e) {
      onError?.call('Gagal memuat ulasan: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
