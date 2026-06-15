import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/cart_model.dart';
import '../../models/address_model.dart';

class CartService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    try {
      final existingCart = await _supabase
          .from('cart')
          .select()
          .eq('user_id', userId)
          .eq('menu_id', productId)
          .maybeSingle();

      if (existingCart != null) {
        final currentQty = (existingCart['quantity'] as num).toInt();
        await _supabase
            .from('cart')
            .update({'quantity': currentQty + quantity})
            .eq('id', existingCart['id']);
      } else {
        await _supabase.from('cart').insert({
          'user_id': userId,
          'menu_id': productId,
          'quantity': quantity,
        });
      }
    } catch (e) {
      throw Exception('Gagal menambahkan ke keranjang: $e');
    }
  }

  Future<List<CartItemModel>> fetchCartItems() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return [];

    final response = await _supabase
        .from('cart')
        .select('*, menus (*)')
        .eq('user_id', user.id)
        .order('created_at', ascending: true);

    return (response as List).map((e) => CartItemModel.fromJson(e)).toList();
  }

  Future<void> updateQuantity(String cartId, int newQuantity) async {
    if (newQuantity < 1) {
      await deleteCartItem(cartId);
      return;
    }
    await _supabase
        .from('cart')
        .update({'quantity': newQuantity})
        .eq('id', cartId);
  }

  Future<void> deleteCartItem(String cartId) async {
    await _supabase.from('cart').delete().eq('id', cartId);
  }

  Future<void> deleteSelectedItems(List<String> cartIds) async {
    if (cartIds.isEmpty) return;
    await _supabase.from('cart').delete().inFilter('id', cartIds);
  }

  Future<void> updateNotes(String cartId, String notes) async {
    await _supabase.from('cart').update({'notes': notes}).eq('id', cartId);
  }

  Future<AddressModel?> fetchDefaultAddress() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final response = await _supabase
        .from('user_addresses')
        .select()
        .eq('user_id', user.id)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (response != null) {
      return AddressModel.fromJson(response);
    }
    return null;
  }

  Future<void> checkStock(List<CartItemModel> selectedItems) async {
    for (var item in selectedItems) {
      final menuResponse = await _supabase
          .from('menus')
          .select('stock, name')
          .eq('id', item.menuId)
          .single();

      final currentStock = menuResponse['stock'] as int;

      if (currentStock < item.quantity) {
        throw Exception(
          'Stok tidak mencukupi untuk menu ${menuResponse['name']} (Sisa stok: $currentStock)',
        );
      }
    }
  }
}
