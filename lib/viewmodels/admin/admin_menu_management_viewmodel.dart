import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/menu_model.dart';
import '../../services/admin/admin_menu_service.dart';

class AdminMenuManagementViewModel extends ChangeNotifier {
  final AdminMenuService _service = AdminMenuService();

  StreamSubscription<List<Map<String, dynamic>>>? _menuSubscription;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<MenuModel> _allMenus = [];

  List<MenuModel> _menus = [];
  List<MenuModel> get menus => _menus;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';

  final List<String> categories = ['All', 'Makanan', 'Minuman', 'Snack'];

  AdminMenuManagementViewModel() {
    _listenToMenus();
  }

  void _listenToMenus() {
    _menuSubscription = _service.streamAllMenus().listen(
      (data) {
        _allMenus = data
            .map<MenuModel>((json) => MenuModel.fromJson(json))
            .toList();
        _filterMenus();

        if (_isLoading) {
          _isLoading = false;
        }
        notifyListeners();
      },
      onError: (error) {
        debugPrint("Gagal stream dari DB: $error");
        if (_isLoading) {
          _isLoading = false;
        }
        notifyListeners();
      },
    );
  }

  Future<void> fetchMenus() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _filterMenus();
  }

  void searchMenu(String query) {
    _searchQuery = query.toLowerCase();
    _filterMenus();
  }

  void _filterMenus() {
    List<MenuModel> tempMenus = _selectedCategory == 'All'
        ? List.from(_allMenus)
        : _allMenus
              .where(
                (menu) =>
                    menu.category.toLowerCase() ==
                    _selectedCategory.toLowerCase(),
              )
              .toList();

    if (_searchQuery.isNotEmpty) {
      tempMenus = tempMenus
          .where((menu) => menu.name.toLowerCase().contains(_searchQuery))
          .toList();
    }

    tempMenus.sort((a, b) {
      if (a.isActive && !b.isActive) return -1;
      if (!a.isActive && b.isActive) return 1;

      if (a.stock != b.stock) {
        return a.stock.compareTo(b.stock);
      }

      return a.name.compareTo(b.name);
    });

    _menus = tempMenus;
    notifyListeners();
  }

  Future<String?> deleteMenu(String id) async {
    try {
      await _service.deleteMenu(id);
      return null;
    } catch (e) {
      return 'Gagal menonaktifkan menu, coba lagi.';
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }

  @override
  void dispose() {
    _menuSubscription?.cancel();
    super.dispose();
  }
}
