import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllOrders({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = _supabase.from('orders').select('''
            id, total_price, status, created_at,
            order_items ( quantity, menus (name) )
          ''');

      if (startDate != null && endDate != null) {
        query = query
            .gte('created_at', startDate.toUtc().toIso8601String())
            .lte('created_at', endDate.toUtc().toIso8601String());
      }

      return await query.order('created_at', ascending: false);
    } catch (e) {
      debugPrint("Error fetching all orders: $e");
      throw Exception("Gagal mengambil data pesanan.");
    }
  }

  Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
    try {
      return await _supabase
          .from('orders')
          .select('''
            id, created_at, status, total_price, notes, payment_method, address_detail,
            va_number, latitude, longitude, payment_proof_url,
            profiles:user_id ( full_name, phone_number ),
            order_items (
              quantity,
              menus ( name, price, image_url )
            )
          ''')
          .eq('id', orderId)
          .single();
    } catch (e) {
      debugPrint("Error fetching order detail: $e");
      throw Exception("Detail pesanan tidak ditemukan.");
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _supabase
          .from('orders')
          .update({'status': newStatus})
          .eq('id', orderId);

      final orderData = await _supabase
          .from('orders')
          .select('user_id')
          .eq('id', orderId)
          .single();

      if (orderData['user_id'] != null) {
        await _supabase.from('notifications').insert({
          'user_id': orderData['user_id'],
          'order_id': orderId,
          'title': 'Status Pesanan Diperbarui',
          'message': 'Pesanan Anda sekarang berstatus: $newStatus.',
        });
      }
    } catch (e) {
      debugPrint("Error Update Order Status: $e");
      throw Exception(e.toString());
    }
  }

  Future<List<dynamic>> getReviewsByOrderId(String orderId) async {
    try {
      return await _supabase
          .from('reviews')
          .select('''
            id, order_id, menu_id, user_id, rating, comment, image_url, created_at,
            menus ( name, price, image_url )
          ''')
          .eq('order_id', orderId)
          .order('created_at', ascending: false);
    } catch (e) {
      debugPrint("Error Fetching Reviews: $e");
      throw Exception("Database belum siap atau error: $e");
    }
  }
}
