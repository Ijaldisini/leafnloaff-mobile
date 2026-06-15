import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/order_model.dart';

class HistoryService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<OrderHistoryModel>> fetchUserHistory() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    final response = await _supabase
        .from('orders')
        .select('''
          *,
          order_items (
            quantity,
            menus (
              name
            )
          )
        ''')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(
      response,
    ).map((e) => OrderHistoryModel.fromJson(e)).toList();
  }
}
