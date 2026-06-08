import 'package:supabase_flutter/supabase_flutter.dart';

class DetailOrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('*, order_items(*, menus(*))')
          .eq('id', orderId)
          .single();

      return response;
    } catch (e) {
      throw Exception('Gagal mengambil detail pesanan: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);
    } catch (e) {
      throw Exception('Gagal mengupdate status: $e');
    }
  }
}
