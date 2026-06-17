import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/address_model.dart';
import '../../models/cart_model.dart';

class CheckoutService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String? getCurrentUserId() => _supabase.auth.currentUser?.id;

  Future<AddressModel?> fetchDefaultAddress() async {
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

    return response != null ? AddressModel.fromJson(response) : null;
  }

  Future<String> uploadPaymentProof(File imageFile) async {
    final fileExt = imageFile.path.split('.').last;
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${getCurrentUserId()}.$fileExt';
    await _supabase.storage.from('payment_proofs').upload(fileName, imageFile);
    return _supabase.storage.from('payment_proofs').getPublicUrl(fileName);
  }

  Future<String> placeOrder({
    required Map<String, dynamic> orderData,
    required List<CartItemModel> cartItems,
  }) async {
    try {
      for (var item in cartItems) {
        final menuResponse = await _supabase
            .from('menus')
            .select('stock')
            .eq('id', item.menuId)
            .single();

        final currentStock = menuResponse['stock'] as int;

        await _supabase
            .from('menus')
            .update({'stock': currentStock - item.quantity})
            .eq('id', item.menuId);
      }

      final orderResponse = await _supabase
          .from('orders')
          .insert(orderData)
          .select('id')
          .single();
      final orderId = orderResponse['id'];
      final shortId = orderId.toString().substring(0, 8).toUpperCase();

      final orderItemsData = cartItems.map((item) {
        return {
          'order_id': orderId,
          'menu_id': item.menuId,
          'quantity': item.quantity,
          'price_at_time': item.menuPrice,
        };
      }).toList();
      await _supabase.from('order_items').insert(orderItemsData);

      final cartIds = cartItems.map((e) => e.id).toList();
      await _supabase.from('cart').delete().inFilter('id', cartIds);

      final userId = getCurrentUserId();

      await _supabase.from('notifications').insert({
        'user_id': null,
        'order_id': orderId,
        'title': 'Pesanan Masuk',
        'message': 'Pesanan baru dengan ID $shortId telah masuk.',
      });

      if (userId != null) {
        await _supabase.from('notifications').insert({
          'user_id': userId,
          'order_id': orderId,
          'title': 'Pesanan Dibuat',
          'message':
              'Pesanan $shortId Anda berhasil dibuat dan menunggu konfirmasi.',
        });
      }

      return orderId;
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<Map<String, double>?> fetchAdminLocation() async {
    try {
      final adminProfile = await _supabase
          .from('profiles')
          .select('id')
          .eq('role', 'admin')
          .limit(1)
          .maybeSingle();
      if (adminProfile == null) return null;

      final addressResponse = await _supabase
          .from('user_addresses')
          .select('latitude, longitude')
          .eq('user_id', adminProfile['id'])
          .order('is_default', ascending: false)
          .limit(1)
          .maybeSingle();
      if (addressResponse != null && addressResponse['latitude'] != null) {
        return {
          'latitude': addressResponse['latitude'],
          'longitude': addressResponse['longitude'],
        };
      }
    } catch (e) {}
    return null;
  }
}
