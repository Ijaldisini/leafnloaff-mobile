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
          .eq('product_id', productId)
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
      await _supabase.from('cart').insert({
        'user_id': userId,
        'product_id': productId,
        'quantity': quantity,
      });
    } catch (e) {
      throw Exception('Gagal menambah ke keranjang: $e');
    }
  }
}
