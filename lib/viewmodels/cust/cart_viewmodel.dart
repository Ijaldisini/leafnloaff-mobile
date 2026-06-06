import 'package:flutter/material.dart';
import '../../services/cust/cart_service.dart';

class CartViewModel extends ChangeNotifier {
  final CartService _service = CartService();

  bool isLoading = true;
  String? errorMessage;

  List<Map<String, dynamic>> cartItems = [];
  Set<String> selectedItemIds = {};
  String currentLocation = 'Memuat lokasi...';

  Future<void> loadCartData() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final address = await _service.fetchDefaultAddress();
      currentLocation = address ?? 'Belum ada alamat pengiriman.';
      cartItems = await _service.fetchCartItems();

      selectedItemIds = cartItems.map((e) => e['id'].toString()).toSet();
    } catch (e) {
      errorMessage = 'Gagal memuat keranjang: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void toggleSelection(String cartId) {
    if (selectedItemIds.contains(cartId)) {
      selectedItemIds.remove(cartId);
    } else {
      selectedItemIds.add(cartId);
    }
    notifyListeners();
  }

  Future<void> incrementQuantity(String cartId, int currentQty) async {
    await _service.updateQuantity(cartId, currentQty + 1);
    await loadCartData();
  }

  Future<void> decrementQuantity(String cartId, int currentQty) async {
    if (currentQty <= 1) {
      await _service.deleteCartItem(cartId);
      selectedItemIds.remove(cartId);
    } else {
      await _service.updateQuantity(cartId, currentQty - 1);
    }
    await loadCartData();
  }

  Future<void> deleteSelected() async {
    if (selectedItemIds.isEmpty) return;
    isLoading = true;
    notifyListeners();

    try {
      await _service.deleteSelectedItems(selectedItemIds.toList());
      selectedItemIds.clear();
      await loadCartData();
    } catch (e) {
      errorMessage = 'Gagal menghapus item: $e';
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveNotes(String cartId, String notes) async {
    try {
      await _service.updateNotes(cartId, notes);
      await loadCartData();
    } catch (e) {
      debugPrint('Gagal menyimpan notes: $e');
    }
  }

  double get totalPayment {
    double total = 0;
    for (var item in cartItems) {
      if (selectedItemIds.contains(item['id'].toString())) {
        final menu = item['menus'] as Map<String, dynamic>;
        final price = (menu['price'] as num).toDouble();
        final qty = (item['quantity'] as num).toInt();
        total += (price * qty);
      }
    }
    return total;
  }
}
