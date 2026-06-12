import 'package:supabase_flutter/supabase_flutter.dart';

class AdminOrderManagementService {
  final _supabase = Supabase.instance.client;

  Future<List<dynamic>> getAllOrders({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
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
  }
}
