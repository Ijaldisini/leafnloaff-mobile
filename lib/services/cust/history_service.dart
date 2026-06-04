import 'package:supabase_flutter/supabase_flutter.dart';
import '/models/order_detail_model.dart';

class HistoryService {
  final _supabase = Supabase.instance.client;

  Future<List<OrderDetailModel>> fetchUserOrders(String userId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select('''
            id,
            created_at,
            status,
            total_price,
            notes,
            payment_method,
            address_detail,
            profiles:user_id ( full_name, phone_number ),
            order_items (
              quantity,
              menus ( name, price, image_url )
            )
          ''')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => OrderDetailModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal memuat riwayat pesanan: $e');
    }
  }
}
