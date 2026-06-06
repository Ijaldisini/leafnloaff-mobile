import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class CheckoutService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? getCurrentUserId() => _supabase.auth.currentUser?.id;

  Future<Map<String, dynamic>?> fetchDefaultAddress() async {
    final userId = getCurrentUserId();
    if (userId == null) return null;

    final response = await _supabase
        .from('user_addresses')
        .select()
        .eq('user_id', userId)
        .order('is_default', ascending: false)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    return response;
  }

  Future<String> uploadPaymentProof(File imageFile) async {
    final userId = getCurrentUserId();
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_$userId.jpg';

    await _supabase.storage.from('payment_proofs').upload(fileName, imageFile);

    return _supabase.storage.from('payment_proofs').getPublicUrl(fileName);
  }

  Future<String> placeOrder({
    required Map<String, dynamic> orderData,
    required List<Map<String, dynamic>> cartItems,
  }) async {
    final orderResponse = await _supabase
        .from('orders')
        .insert(orderData)
        .select('id')
        .single();

    final orderId = orderResponse['id'];

    final orderItemsData = cartItems.map((item) {
      return {
        'order_id': orderId,
        'menu_id': item['menu_id'],
        'quantity': item['quantity'],
        'price_at_time': item['menus']['price'],
      };
    }).toList();
    await _supabase.from('order_items').insert(orderItemsData);

    final cartIds = cartItems.map((e) => e['id']).toList();
    await _supabase.from('cart').delete().inFilter('id', cartIds);

    return orderId;
  }
}
