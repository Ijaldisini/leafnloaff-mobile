import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/notification_model.dart';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<NotificationModel>> fetchNotifications() async {
    final user = _supabase.auth.currentUser;
    if (user == null) throw Exception('User belum login.');

    final response = await _supabase
        .from('notifications')
        .select('*')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return (response as List)
        .map((data) => NotificationModel.fromJson(data))
        .toList();
  }
}
