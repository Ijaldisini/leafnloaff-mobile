import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notification_model.dart';
import '../../services/cust/notification_service.dart';

class NotificationViewModel extends ChangeNotifier {
  final NotificationService _service = NotificationService();

  bool isLoading = false;
  String? errorMessage;

  List<Map<String, dynamic>> groupedNotifications = [];

  Future<void> loadNotifications() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final List<NotificationModel> rawNotifications = await _service
          .fetchNotifications();
      groupedNotifications = _groupNotificationsByDate(rawNotifications);
    } catch (e) {
      errorMessage = "Gagal memuat notifikasi: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
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
