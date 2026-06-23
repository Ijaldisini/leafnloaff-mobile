import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/cust/home_service.dart';
import '../../services/cust/cart_service.dart';

class HomeViewModel extends ChangeNotifier {
  final HomeService _homeService;
  final CartService _cartService;
  final VoidCallback? onCartUpdated;

  HomeViewModel({
    required HomeService homeService,
    required CartService cartService,
    this.onCartUpdated,
  }) : _homeService = homeService,
       _cartService = cartService;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  final List<String> _categories = ['All', 'Makanan', 'Minuman', 'Snack'];
  List<String> get categories => _categories;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  List<Map<String, dynamic>> _menus = [];
  List<Map<String, dynamic>> get menus => _menus;

  List<Map<String, dynamic>> _activeVouchers = [];
  List<Map<String, dynamic>> get activeVouchers => _activeVouchers;

  final Set<String> _recentlyAddedItems = {};
  Set<String> get recentlyAddedItems => _recentlyAddedItems;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _currentLocation = 'Memuat lokasi...';
  String get currentLocation => _currentLocation;

  List<Map<String, dynamic>> get filteredMenus {
    List<Map<String, dynamic>> result = List.from(_menus);

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

    result.sort((a, b) {
      final stockA = (a['stock'] as num?)?.toInt() ?? 0;
      final stockB = (b['stock'] as num?)?.toInt() ?? 0;

      if (stockA > 0 && stockB <= 0) return -1;
      if (stockA <= 0 && stockB > 0) return 1;
      return 0;
    });

    return result;
  }

  Future<void> fetchHomeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        _homeService.fetchDefaultAddress(),
        _homeService.fetchActiveVouchers(),
        _homeService.fetchActiveMenus(),
      ]);

      _currentLocation =
          (results[0] as String?) ??
          'Belum ada alamat, silakan tambah di profil.';
      _activeVouchers = results[1] as List<Map<String, dynamic>>;
      _menus = results[2] as List<Map<String, dynamic>>;
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

  Future<void> addToCart(String productId) async {
    if (_recentlyAddedItems.contains(productId)) return;

    try {
      final userId = _cartService.getCurrentUserId();
      if (userId == null) {
        throw Exception("Sesi telah habis, silakan login ulang.");
      }

      _recentlyAddedItems.add(productId);
      notifyListeners();

      await _cartService.addToCart(
        userId: userId,
        productId: productId,
        quantity: 1,
      );

      onCartUpdated?.call();

      Timer(const Duration(milliseconds: 1500), () {
        _recentlyAddedItems.remove(productId);
        notifyListeners();
      });
    } catch (e) {
      _recentlyAddedItems.remove(productId);
      notifyListeners();
      debugPrint('Error add to cart: $e');
    }
  }
}
