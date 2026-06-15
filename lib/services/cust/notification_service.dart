import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/notification_model.dart';
import '../../utils/notification_helper.dart';

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

  RealtimeChannel? listenToCustomerNotifications(
    Function(NotificationModel) onNewNotification,
  ) {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;

    final channel = _supabase
        .channel('public:notifications_customer_${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: user.id,
          ),
          callback: (payload) {
            final newRecord = payload.newRecord;
            if (newRecord == null)
              return;

            final orderId = newRecord['order_id']?.toString().trim();

            if (orderId != null && orderId.isNotEmpty) {
              final String notifPayload = 'cust_order_$orderId';

              NotificationHelper.showNotification(
                id: newRecord['id'].hashCode,
                title: newRecord['title'] ?? 'Leaf N Loaff',
                body: newRecord['message'] ?? 'Kamu memiliki pesan baru',
                payload: notifPayload,
              );
            }

            final newNotif = NotificationModel.fromJson(newRecord);
            onNewNotification(newNotif);
          },
        );

    channel.subscribe();
    return channel;
  }
}
