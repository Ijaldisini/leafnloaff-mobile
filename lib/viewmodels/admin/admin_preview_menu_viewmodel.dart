import 'package:flutter/material.dart';
import '../../services/admin/admin_review_service.dart';

class AdminPreviewMenuViewModel extends ChangeNotifier {
  final AdminReviewService _service = AdminReviewService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  double _averageRating = 0.0;
  double get averageRating => _averageRating;

  int _totalReviews = 0;
  int get totalReviews => _totalReviews;

  Map<int, int> _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  Map<int, int> get ratingDistribution => _ratingDistribution;

  Future<void> fetchReviews(String menuId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getMenuRatings(menuId);

      _totalReviews = response.length;

      if (_totalReviews > 0) {
        int sumRating = 0;
        Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

        for (var row in response) {
          int rating = row['rating'] as int;
          sumRating += rating;
          if (distribution.containsKey(rating)) {
            distribution[rating] = distribution[rating]! + 1;
          }
        }

        _averageRating = sumRating / _totalReviews;
        _ratingDistribution = distribution;
      } else {
        _averageRating = 0.0;
        _ratingDistribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
      }
    } catch (e) {
      debugPrint("Error fetching preview reviews: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
