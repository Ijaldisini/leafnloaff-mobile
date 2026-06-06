import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/cust/home_service.dart';
import 'cart_viewmodel.dart';

class HomeViewModel extends ChangeNotifier {
  static final HomeViewModel _instance = HomeViewModel._internal();
  factory HomeViewModel() => _instance;
  HomeViewModel._internal();

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

  final Set<String> _recentlyAddedItems = {};
  Set<String> get recentlyAddedItems => _recentlyAddedItems;

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

  Future<void> addToCart(String productId) async {
    if (_recentlyAddedItems.contains(productId)) return;

    try {
      final userId = _service.getCurrentUserId();
      if (userId == null) {
        throw Exception("Sesi telah habis, silakan login ulang.");
      }

      _recentlyAddedItems.add(productId);
      notifyListeners();

      await _service.addToCart(
        userId: userId,
        productId: productId,
        quantity: 1,
      );

      CartViewModel().loadCartData();

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
