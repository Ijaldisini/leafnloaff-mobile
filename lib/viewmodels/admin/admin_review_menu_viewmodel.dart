import 'package:flutter/material.dart';
import '../../models/review_model.dart';
import '../../services/admin/admin_review_service.dart';

class AdminReviewMenuViewModel extends ChangeNotifier {
  final AdminReviewService _service = AdminReviewService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<ReviewModel> _reviews = [];
  List<ReviewModel> get reviews => _reviews;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchReviewsDetail(String menuId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reviews = await _service.getMenuReviewsDetail(menuId);
    } catch (e) {
      debugPrint("Error fetching review details: $e");
      _errorMessage = e.toString();
      _reviews = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatDate(DateTime date) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
  }
}
