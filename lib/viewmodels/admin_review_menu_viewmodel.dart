import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminReviewMenuViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Map<String, dynamic>> _reviews = [];
  List<Map<String, dynamic>> get reviews => _reviews;

  Future<void> fetchReviewsDetail(String menuId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('reviews')
          .select('*, profiles(full_name)')
          .eq('menu_id', menuId)
          .order('created_at', ascending: false);

      _reviews = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error fetching review details: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatDate(String isoDate) {
    try {
      DateTime date = DateTime.parse(isoDate);
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
    } catch (e) {
      return isoDate;
    }
  }
}
