import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/notification_model.dart';

class AdminNotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<NotificationModel>> fetchAdminNotifications() async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('*')
          .isFilter('user_id', null)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => NotificationModel.fromJson(data))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil notifikasi admin: $e');
    }
  }
}