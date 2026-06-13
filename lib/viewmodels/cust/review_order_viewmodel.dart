import 'package:flutter/material.dart';
import '../../services/cust/review_order_service.dart';
import '../../models/review_model.dart';

class ReviewOrderViewModel extends ChangeNotifier {
  final ReviewOrderService _service = ReviewOrderService();

  bool isLoading = false;
  String? errorMessage;

  List<ReviewModel> orderReviews = [];

  Future<bool> submitAllReviews(
    String orderId,
    List<ReviewSubmitModel> reviewsData,
  ) async {
    isLoading = true;
    errorMessage = null;
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
      errorMessage = 'Gagal mengirim ulasan: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchReviewsForOrder(String orderId) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      orderReviews = await _service.fetchReviewsByOrder(orderId);
    } catch (e) {
      errorMessage = 'Gagal memuat ulasan: ${e.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
