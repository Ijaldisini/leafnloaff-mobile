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

  void listenToCustomerNotifications() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _supabase
        .channel('public:notifications_customer')
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
            final orderId = newRecord['order_id'];

            final String notifPayload = orderId != null
                ? 'cust_order_$orderId'
                : 'customer_notif';

            NotificationHelper.showNotification(
              id: newRecord['id'].hashCode,
              title: newRecord['title'] ?? 'Leaf N Loaff',
              body: newRecord['message'] ?? 'Kamu memiliki pesan baru',
              payload: notifPayload,
            );
          },
        )
        .subscribe();
  }
}
