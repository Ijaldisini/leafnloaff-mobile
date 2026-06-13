import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notification_model.dart';
import '../../services/admin/admin_notification_service.dart';

class AdminNotificationViewModel extends ChangeNotifier {
  AdminNotificationViewModel() {
    _service.listenToAdminNotifications();
  }
  final AdminNotificationService _service = AdminNotificationService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<Map<String, dynamic>> _groupedNotifications = [];
  List<Map<String, dynamic>> get groupedNotifications => _groupedNotifications;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<NotificationModel> rawNotifications = await _service
          .fetchAdminNotifications();

      final filteredNotifications = rawNotifications.where((notif) {
        final titleLower = notif.title.toLowerCase();
        if (titleLower.contains('ulasan') ||
            titleLower.contains('pesanan') ||
            titleLower.contains('review')) {
          return notif.orderId != null && notif.orderId!.isNotEmpty;
        }
        return true;
      }).toList();

      if (filteredNotifications.isEmpty) {
        _errorMessage = "Tidak ada notifikasi untuk ditampilkan.";
        _groupedNotifications = [];
      } else {
        _groupDataByDate(filteredNotifications);
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _groupDataByDate(List<NotificationModel> data) {
    Map<String, List<NotificationModel>> grouped = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var item in data) {
      final date = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );

      String groupKey;
      if (date == today) {
        groupKey = 'Today';
      } else if (date == yesterday) {
        groupKey = 'Yesterday';
      } else {
        groupKey = DateFormat('MMM d, yyyy').format(date);
      }

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(item);
    }

    _groupedNotifications = grouped.entries.map((entry) {
      return {'date': entry.key, 'items': entry.value};
    }).toList();
  }
}
