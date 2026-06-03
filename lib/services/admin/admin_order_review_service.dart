import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class AdminOrderReviewService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getReviewsByOrderId(String orderId) async {
    try {
      final response = await _supabase
          .from('reviews')
          .select('''
            rating, review_text, image_urls,
            orders!inner (
              order_items (
                quantity, notes,
                menus ( name, price, image_url )
              )
            )
          ''')
          .eq('order_id', orderId);

      return response;
    } catch (e) {
      debugPrint("Error Fetching Reviews: $e");
      throw Exception("Database belum siap atau error: $e");
    }
  }
}
