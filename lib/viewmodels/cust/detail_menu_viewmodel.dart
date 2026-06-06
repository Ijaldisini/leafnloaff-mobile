import 'package:flutter/material.dart';
import '../../services/cust/detail_menu_service.dart';
import 'cart_viewmodel.dart';

class DetailMenuViewModel extends ChangeNotifier {
  final DetailMenuService _service = DetailMenuService();

  bool _isAddingToCart = false;
  bool get isAddingToCart => _isAddingToCart;

  Map<int, int> _ratingDist = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  Map<int, int> get ratingDist => _ratingDist;

  double _rating = 0.0;
  double get rating => _rating;

  int _totalReviews = 0;
  int get totalReviews => _totalReviews;

  void initData(
    double initialRating,
    int initialTotal,
    Map<int, int>? initialDist,
  ) {
    _rating = initialRating;
    _totalReviews = initialTotal;
    if (initialDist != null) {
      _ratingDist = initialDist;
    }
  }

  Future<void> fetchReviews(String productId) async {
    try {
      final reviews = await _service.fetchReviews(productId);

      if (reviews.isNotEmpty) {
        _totalReviews = reviews.length;
        double sum = 0;
        Map<int, int> dist = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

        for (var r in reviews) {
          int star = (r['rating'] as num).toInt();
          sum += star;
          if (dist.containsKey(star)) {
            dist[star] = dist[star]! + 1;
          }
        }

        _rating = sum / _totalReviews;
        _ratingDist = dist;
      } else {
        _rating = 0.0;
        _totalReviews = 0;
        _ratingDist = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
      }

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
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

      CartViewModel().loadCartData();
      
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
