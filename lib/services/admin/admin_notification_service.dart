import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/notification_model.dart';
import '../../utils/notification_helper.dart';

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

  RealtimeChannel? listenToAdminNotifications(
    Function(NotificationModel) onNewNotification,
  ) {
    return _supabase
        .channel('public:notifications_admin')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          callback: (payload) {
            final newRecord = payload.newRecord;

            if (newRecord['user_id'] == null) {
              final orderId = newRecord['order_id'];
              final title = (newRecord['title'] ?? '').toString().toLowerCase();

              if ((title.contains('ulasan') ||
                      title.contains('pesanan') ||
                      title.contains('review')) &&
                  orderId == null) {
                return;
              }

              String notifPayload = 'admin_notif';
              if (orderId != null) {
                if (title.contains('ulasan') || title.contains('review')) {
                  notifPayload = 'admin_review_$orderId';
                } else {
                  notifPayload = 'admin_order_$orderId';
                }
              }

              NotificationHelper.showNotification(
                id: newRecord['id'].hashCode,
                title: newRecord['title'] ?? 'Notifikasi Admin',
                body: newRecord['message'] ?? 'Ada pesan baru masuk.',
                payload: notifPayload,
              );

              final newNotif = NotificationModel.fromJson(newRecord);
              onNewNotification(newNotif);
            }
          },
        )
        .subscribe();
  }
}
