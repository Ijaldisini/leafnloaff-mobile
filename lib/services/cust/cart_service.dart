import 'package:supabase_flutter/supabase_flutter.dart';

class CartService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    final response = await _supabase
        .from('cart')
        .select('''
          *,
          menus (*)
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
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

  Future<String?> fetchDefaultAddress() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final addressData = await _supabase
        .from('user_addresses')
        .select('address_detail')
        .eq('user_id', user.id)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false)
        .limit(1);

    if (addressData.isNotEmpty) {
      return addressData.first['address_detail'] as String;
    }
    return null;
  }
}
