import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/menu_model.dart';
import '../../services/admin/admin_menu_management_service.dart';

class AdminMenuManagementViewModel extends ChangeNotifier {
  final AdminMenuManagementService _service = AdminMenuManagementService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<MenuModel> _allMenus = [];

  List<MenuModel> _menus = [];
  List<MenuModel> get menus => _menus;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';

  final List<String> categories = ['All', 'Makanan', 'Minuman', 'Snack'];

  AdminMenuManagementViewModel() {
    Future.microtask(() => fetchMenus());
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
      if (a.isActive == b.isActive) {
        return a.name.compareTo(b.name);
      }
      return a.isActive ? -1 : 1;
    });

    _menus = tempMenus;
    notifyListeners();
  }

  Future<void> fetchMenus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getAllMenus();

      _allMenus = response.map<MenuModel>((data) {
        String? rawImageUrl = data['image_url']?.toString();
        if (rawImageUrl != null && rawImageUrl.contains('example.com')) {
          rawImageUrl = 'https://placehold.co/113x100/png?text=Image+Not+Found';
        }

        return MenuModel(
          id: data['id']?.toString() ?? '',
          name: data['name']?.toString() ?? 'Unknown Name',
          description: data['description']?.toString() ?? '-',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          category: data['category']?.toString() ?? 'Makanan',
          imageUrl: rawImageUrl,
          stock: data['stock'] ?? 0,
          isActive: data['is_active'] ?? true,
          createdAt: data['created_at'] != null
              ? DateTime.parse(data['created_at'].toString())
              : DateTime.now(),
        );
      }).toList();

      _filterMenus();
    } catch (e) {
      debugPrint("Gagal fetch dari DB: $e");
      _allMenus = [];
      _menus = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteMenu(String id, BuildContext context) async {
    try {
      await _service.deleteMenu(id);

      final index = _allMenus.indexWhere((menu) => menu.id == id);
      if (index != -1) {
        final oldMenu = _allMenus[index];
        _allMenus[index] = MenuModel(
          id: oldMenu.id,
          name: oldMenu.name,
          description: oldMenu.description,
          price: oldMenu.price,
          category: oldMenu.category,
          imageUrl: oldMenu.imageUrl,
          stock: oldMenu.stock,
          isActive: false,
          createdAt: oldMenu.createdAt,
        );
      }

      _filterMenus();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Menu berhasil dinonaktifkan')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menonaktifkan menu, coba lagi.')),
        );
      }
    }
  }

  String formatCurrency(double amount) {
    return NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp. ',
      decimalDigits: 0,
    ).format(amount);
  }
}
