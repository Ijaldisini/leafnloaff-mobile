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
      final orderData = await _supabase
          .from('orders')
          .select('*, profiles:user_id(full_name, phone_number)')
          .eq('id', orderId)
          .single();

      final Map<String, dynamic> mutableOrderData = Map<String, dynamic>.from(
        orderData,
      );

      String phoneNumber = mutableOrderData['profiles']?['phone_number'] ?? '-';
      String fullName = mutableOrderData['profiles']?['full_name'] ?? 'Unknown';

      if (mutableOrderData['user_id'] != null &&
          mutableOrderData['address_detail'] != null &&
          mutableOrderData['address_detail'] != 'Diambil di Toko') {
        final addressData = await _supabase
            .from('user_addresses')
            .select('recipient_name, phone_number')
            .eq('user_id', mutableOrderData['user_id'])
            .eq('address_detail', mutableOrderData['address_detail'])
            .limit(1)
            .maybeSingle();

        if (addressData != null) {
          if (addressData['phone_number'] != null &&
              addressData['phone_number'].toString().trim().isNotEmpty) {
            phoneNumber = addressData['phone_number'];
          }
          if (addressData['recipient_name'] != null &&
              addressData['recipient_name'].toString().trim().isNotEmpty) {
            fullName = addressData['recipient_name'];
          }
        }
      }

      mutableOrderData['profiles'] ??= {};
      mutableOrderData['profiles']['phone_number'] = phoneNumber;
      mutableOrderData['profiles']['full_name'] = fullName;

      final itemsData = await _supabase
          .from('order_items')
          .select('*, menus(*)')
          .eq('order_id', orderId);

      mutableOrderData['order_items'] = itemsData;

      return mutableOrderData;
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

      final shortId = orderId.substring(0, 8).toUpperCase();
      String titleAdmin = '';
      String msgAdmin = '';
      String titleCust = '';
      String msgCust = '';

      if (newStatus.toLowerCase() == 'diproses') {
        titleAdmin = 'Pesanan Diproses';
        msgAdmin = 'Pesanan $shortId sedang diproses.';
        titleCust = 'Pesanan Diproses';
        msgCust = 'Pesanan $shortId Anda sedang diproses oleh toko.';
      } else if (newStatus.toLowerCase() == 'dikirim') {
        titleAdmin = 'Pesanan Dikirim';
        msgAdmin = 'Pesanan $shortId sedang dikirim ke customer.';
        titleCust = 'Pesanan Dikirim';
        msgCust = 'Pesanan $shortId Anda sedang dalam perjalanan.';
      } else if (newStatus.toLowerCase() == 'dibatalkan' ||
          newStatus.toLowerCase() == 'cancelled') {
        titleAdmin = 'Pesanan Dibatalkan';
        msgAdmin = 'Anda telah membatalkan pesanan $shortId.';
        titleCust = 'Pesanan Dibatalkan';
        msgCust = 'Maaf, pesanan $shortId Anda telah dibatalkan oleh Admin.';
      }

      if (titleAdmin.isNotEmpty) {
        await _supabase.from('notifications').insert({
          'user_id': null,
          'order_id': orderId,
          'title': titleAdmin,
          'message': msgAdmin,
        });
      }

      if (titleCust.isNotEmpty && orderData['user_id'] != null) {
        await _supabase.from('notifications').insert({
          'user_id': orderData['user_id'],
          'order_id': orderId,
          'title': titleCust,
          'message': msgCust,
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
          .eq('order_id', orderId);
    } catch (e) {
      debugPrint("Error fetching reviews: $e");
      throw Exception("Gagal memuat ulasan.");
    }
  }
}
