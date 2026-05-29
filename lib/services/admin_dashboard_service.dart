import 'package:supabase_flutter/supabase_flutter.dart';

class AdminDashboardService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getOrdersToday(
    String startOfDay,
    String endOfDay,
  ) async {
    return await _supabase
        .from('orders')
        .select('id, total_price, status, created_at')
        .gte('created_at', startOfDay)
        .lte('created_at', endOfDay);
  }

  Future<List<dynamic>> getNewCustomersThisWeek(String startOfWeek) async {
    return await _supabase
        .from('profiles')
        .select('id')
        .eq('role', 'customer')
        .gte('created_at', startOfWeek);
  }

  Future<List<dynamic>> getOrderItemsToday(
    String startOfDay,
    String endOfDay,
  ) async {
    return await _supabase
        .from('order_items')
        .select('menu_id, quantity, menus(name)')
        .gte('created_at', startOfDay)
        .lte('created_at', endOfDay);
  }

  Future<List<dynamic>> getRecentOrders() async {
    return await _supabase
        .from('orders')
        .select('''
          id,
          status,
          created_at,
          total_price,
          notes,
          order_items (
            quantity,
            menus (name)
          )
        ''')
        .order('created_at', ascending: false)
        .limit(3);
  }
}
