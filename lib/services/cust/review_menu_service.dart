import 'package:supabase_flutter/supabase_flutter.dart';

class ReviewMenuService {
  final _supabase = Supabase.instance.client;

  String? getCurrentUserId() {
    return _supabase.auth.currentUser?.id;
  }

  Future<List<Map<String, dynamic>>> fetchReviews(String productId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('''
            *,
            profiles:user_id (
              full_name
            )
          ''')
          .eq(
            'menu_id',
            productId,
          )
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil ulasan: $e');
    }
  }

  Future<void> addToCart({
    required String userId,
    required String productId,
    required int quantity,
  }) async {
    try {
      final existingCartItem = await _supabase
          .from('cart')
          .select()
          .eq('user_id', userId)
          .eq('menu_id', productId)
          .maybeSingle();

      if (existingCartItem != null) {
        final newQuantity = (existingCartItem['quantity'] as int) + quantity;
        await _supabase
            .from('cart')
            .update({'quantity': newQuantity})
            .eq('id', existingCartItem['id']);
      } else {
        await _supabase.from('cart').insert({
          'user_id': userId,
          'menu_id': productId,
          'quantity': quantity,
        });
      }
    } catch (e) {
      throw Exception('Gagal menambah ke keranjang: $e');
    }
  }
}
