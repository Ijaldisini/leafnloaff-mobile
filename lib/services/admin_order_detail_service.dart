import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderDetailService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> getOrderDetail(String orderId) async {
    return await _supabase
        .from('orders')
        .select('''
          id, created_at, status, total_price, notes, payment_method, address_detail,
          profiles:user_id ( full_name, phone_number ),
          order_items (
            quantity,
            menus ( name, price, image_url )
          )
        ''')
        .eq('id', orderId)
        .single();
  }
}
