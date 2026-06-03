import 'package:flutter/material.dart';
import '/services/cust/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _service = HomeService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<String> _categories = [];
  List<String> get categories => _categories;

  String _selectedCategory = '';
  String get selectedCategory => _selectedCategory;

  List<Map<String, dynamic>> _menus = [];
  List<Map<String, dynamic>> get menus => _menus;

  Map<String, dynamic>? _activeVoucher;
  Map<String, dynamic>? get activeVoucher => _activeVoucher;

  final Set<String> _favoriteItems = {};
  Set<String> get favoriteItems => _favoriteItems;

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _activeVoucher = await _service.fetchActiveVoucher();

      _menus = await _service.fetchActiveMenus();

      final Set<String> unique = {};
      for (var m in _menus) {
        if (m['category'] != null) {
          unique.add(m['category'].toString());
        }
      }
      _categories = unique.toList();

      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first;
      }
    } catch (e) {
      debugPrint('Error fetching home data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void toggleFavorite(String id) {
    if (_favoriteItems.contains(id)) {
      _favoriteItems.remove(id);
    } else {
      _favoriteItems.add(id);
    }
    notifyListeners();
  }
}
