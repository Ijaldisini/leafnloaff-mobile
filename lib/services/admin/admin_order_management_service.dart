import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderManagementService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllOrders() async {
    return await _supabase
        .from('orders')
        .select('''
          id, total_price, status, created_at,
          order_items ( quantity, menus (name) )
        ''')
        .order('created_at', ascending: false);
  }
}
