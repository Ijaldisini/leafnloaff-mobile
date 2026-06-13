import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AdminOrderReviewService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getReviewsByOrderId(String orderId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('''
            id, order_id, menu_id, user_id, rating, comment, image_url, created_at,
            menus ( name, price, image_url )
          ''')
          .eq('order_id', orderId)
          .order('created_at', ascending: false);

      return response;
    } catch (e) {
      debugPrint("Error Fetching Reviews: $e");
      throw Exception("Database belum siap atau error: $e");
    }
  }
}
