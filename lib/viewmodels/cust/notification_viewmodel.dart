import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/notification_model.dart';
import '../../services/cust/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();
  RealtimeChannel? _realtimeSubscription;

  bool isLoading = false;
  String? errorMessage;

  List<NotificationModel> _rawNotifications = [];
  List<Map<String, dynamic>> groupedNotifications = [];

  void initListener() {
    _realtimeSubscription?.unsubscribe();

    _realtimeSubscription = _service.listenToCustomerNotifications((newNotif) {
      if (newNotif.orderId != null && newNotif.orderId!.trim().isNotEmpty) {
        final isDuplicate = _rawNotifications.any((n) => n.id == newNotif.id);

        if (!isDuplicate) {
          _rawNotifications.insert(0, newNotif);
          groupedNotifications = _groupNotificationsByDate(_rawNotifications);
          notifyListeners();
        }
      }
    });
  }

  @override
  void dispose() {
    _realtimeSubscription?.unsubscribe();
    super.dispose();
  }

  Future<void> loadNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final allNotifications = await _service.fetchNotifications();

      _rawNotifications = allNotifications.where((notif) {
        return notif.orderId != null && notif.orderId!.trim().isNotEmpty;
      }).toList();

      _removeDuplicates();

      groupedNotifications = _groupNotificationsByDate(_rawNotifications);
    } catch (e) {
      errorMessage = "Gagal memuat notifikasi: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _removeDuplicates() {
    final seenIds = <String>{};
    _rawNotifications.retainWhere((notif) => seenIds.add(notif.id));
  }

  List<Map<String, dynamic>> _groupNotificationsByDate(
    List<NotificationModel> notifications,
  ) {
    Map<String, List<NotificationModel>> groupedMap = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var notif in notifications) {
      final notifDate = DateTime(
        notif.createdAt.year,
        notif.createdAt.month,
        notif.createdAt.day,
      );

      String groupKey;
      if (notifDate == today) {
        groupKey = 'Today';
      } else if (notifDate == yesterday) {
        groupKey = 'Yesterday';
      } else {
        groupKey = DateFormat('MMM d, yyyy').format(notifDate);
      }

      if (!groupedMap.containsKey(groupKey)) {
        groupedMap[groupKey] = [];
      }
      groupedMap[groupKey]!.add(notif);
    }

    return groupedMap.entries.map((e) {
      return {'date': e.key, 'items': e.value};
    }).toList();
  }
}
