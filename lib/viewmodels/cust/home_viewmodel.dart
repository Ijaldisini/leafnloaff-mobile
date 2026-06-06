import 'package:flutter/material.dart';
import '../../services/cust/home_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _service = HomeService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<String> _categories = ['All', 'Sandwich', 'Drink', 'Snack'];
  List<String> get categories => _categories;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  List<Map<String, dynamic>> _menus = [];
  List<Map<String, dynamic>> get menus => _menus;

  Map<String, dynamic>? _activeVoucher;
  Map<String, dynamic>? get activeVoucher => _activeVoucher;

  final Set<String> _favoriteItems = {};
  Set<String> get favoriteItems => _favoriteItems;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _currentLocation = 'Memuat lokasi...';
  String get currentLocation => _currentLocation;

  List<Map<String, dynamic>> get filteredMenus {
    List<Map<String, dynamic>> result = _menus;

    if (_selectedCategory != 'All') {
      result = result.where((m) {
        final cat = (m['category'] ?? '').toString().toLowerCase();
        return cat == _selectedCategory.toLowerCase();
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      result = result.where((m) {
        final name = (m['name'] ?? '').toString().toLowerCase();
        return name.contains(_searchQuery.toLowerCase());
      }).toList();
    }

    return result;
  }

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final address = await _service.fetchDefaultAddress();
      _currentLocation =
          address ?? 'Belum ada alamat, silakan tambah di profil.';

      _activeVoucher = await _service.fetchActiveVoucher();
      _menus = await _service.fetchActiveMenus();

    } catch (e) {
      debugPrint('Error fetching home data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _searchQuery = '';
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
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
