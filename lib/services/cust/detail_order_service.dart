import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order_model.dart';

class DetailOrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<OrderDetailModel> fetchOrderDetails(String orderId) async {
    try {
      final orderData = await _supabase
          .from('orders')
          .select(
            '*, order_items(*, menus(*)), profiles:user_id(full_name, phone_number)',
          )
          .eq('id', orderId)
          .single();

      String phoneNumber = orderData['profiles']?['phone_number'] ?? '-';
      String fullName = orderData['profiles']?['full_name'] ?? 'Unknown';

      if (orderData['user_id'] != null &&
          orderData['address_detail'] != null &&
          orderData['address_detail'] != 'Diambil di Toko') {
        final addressData = await _supabase
            .from('user_addresses')
            .select('recipient_name, phone_number')
            .eq('user_id', orderData['user_id'])
            .eq('address_detail', orderData['address_detail'])
            .limit(1)
            .maybeSingle();

        if (addressData != null) {
          if (addressData['phone_number'] != null &&
              addressData['phone_number'].toString().isNotEmpty) {
            phoneNumber = addressData['phone_number'];
          }
          if (addressData['recipient_name'] != null &&
              addressData['recipient_name'].toString().isNotEmpty) {
            fullName = addressData['recipient_name'];
          }
        }
      }

      orderData['profiles'] ??= {};
      orderData['profiles']['phone_number'] = phoneNumber;
      orderData['profiles']['full_name'] = fullName;

      return OrderDetailModel.fromJson(orderData);
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

      final shortId = orderId.substring(0, 8).toUpperCase();
      final userId = _supabase.auth.currentUser?.id;

      String titleAdmin = '';
      String msgAdmin = '';
      String titleCust = '';
      String msgCust = '';

      if (newStatus.toLowerCase() == 'selesai') {
        titleAdmin = 'Pesanan Diterima';
        msgAdmin = 'Pesanan $shortId telah diterima oleh Customer.';
        titleCust = 'Pesanan Diterima';
        msgCust =
            'Pesanan $shortId Anda telah selesai. Silakan berikan ulasan!';
      } else if (newStatus.toLowerCase() == 'dibatalkan' ||
          newStatus.toLowerCase() == 'cancelled') {
        titleAdmin = 'Pesanan Dibatalkan';
        msgAdmin = 'Customer membatalkan pesanan $shortId.';
        titleCust = 'Pesanan Dibatalkan';
        msgCust = 'Anda telah membatalkan pesanan $shortId.';
      }

      if (titleAdmin.isNotEmpty) {
        await _supabase.from('notifications').insert({
          'user_id': null,
          'order_id': orderId,
          'title': titleAdmin,
          'message': msgAdmin,
        });
      }

      if (titleCust.isNotEmpty && userId != null) {
        await _supabase.from('notifications').insert({
          'user_id': userId,
          'order_id': orderId,
          'title': titleCust,
          'message': msgCust,
        });
      }
    } catch (e) {
      throw Exception('Gagal mengupdate status: $e');
    }
  }
}
