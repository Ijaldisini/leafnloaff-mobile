import 'package:flutter/material.dart';
import '../../services/cust/cart_service.dart';
import '../../models/cart_model.dart';

class CartViewModel extends ChangeNotifier {
  static final CartViewModel _instance = CartViewModel._internal();
  factory CartViewModel() => _instance;
  CartViewModel._internal();

  final CartService _service = CartService();

  bool isLoading = true;
  String? errorMessage;

  List<CartItemModel> cartItems = [];
  Set<String> selectedItemIds = {};
  String currentLocation = 'Memuat lokasi...';

  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  Future<void> loadCartData() async {
    if (_isProcessing) return;

    isLoading = true;
    errorMessage = null;
    _isProcessing = true;

    notifyListeners();

    try {
      final results = await Future.wait([
        _service.fetchDefaultAddress(),
        _service.fetchCartItems(),
      ]);

      final address = results[0];
      currentLocation =
          (address as dynamic)?.addressDetail ?? 'Belum ada alamat pengiriman.';

      cartItems = results[1] as List<CartItemModel>;

      selectedItemIds = cartItems.map((e) => e.id).toSet();
    } catch (e) {
      errorMessage = 'Gagal memuat keranjang: $e';
    } finally {
      isLoading = false;
      _isProcessing = false;
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
    _service
        .updateQuantity(cartId, currentQty + 1)
        .then((_) {
          loadCartData();
        })
        .catchError((e) {
          debugPrint("Gagal tambah quantity: $e");
        });
  }

  Future<void> decrementQuantity(String cartId, int currentQty) async {
    if (currentQty <= 1) {
      _service.deleteCartItem(cartId).then((_) {
        selectedItemIds.remove(cartId);
        loadCartData();
      });
    } else {
      _service.updateQuantity(cartId, currentQty - 1).then((_) {
        loadCartData();
      });
    }
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

  Future<String?> validateStockBeforeCheckout() async {
    if (_isProcessing) return "Sedang memproses, mohon tunggu sebentar.";

    _isProcessing = true;

    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final itemsToCheck = cartItems
          .where((item) => selectedItemIds.contains(item.id))
          .toList();

      await _service.checkStock(itemsToCheck);
      return null;
    } catch (e) {
      return e.toString().replaceAll(
        'Exception: ',
        '',
      );
    } finally {
      _isProcessing = false;
    }
  }

  double get totalPayment {
    return cartItems
        .where((item) => selectedItemIds.contains(item.id))
        .fold(0, (sum, item) => sum + (item.menuPrice * item.quantity));
  }
}
