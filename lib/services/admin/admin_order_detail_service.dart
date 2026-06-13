import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderDetailService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
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

      debugPrint(
        "✅ Perintah update dikirim untuk Order ID: $orderId, Status baru: $newStatus",
      );
    } catch (e) {
      debugPrint("❌ Error Update Service: $e");
      throw Exception(e.toString());
    }
  }
}
