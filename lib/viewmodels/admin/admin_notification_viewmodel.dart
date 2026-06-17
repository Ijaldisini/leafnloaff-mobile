import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/notification_model.dart';
import '../../services/admin/admin_notification_service.dart';

class AdminNotificationViewModel extends ChangeNotifier {
  final AdminNotificationService _service = AdminNotificationService();
  RealtimeChannel? _realtimeSubscription;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<NotificationModel> _rawNotifications = [];

  List<Map<String, dynamic>> _groupedNotifications = [];
  List<Map<String, dynamic>> get groupedNotifications => _groupedNotifications;

  void initListener() {
    _realtimeSubscription?.unsubscribe();

    _realtimeSubscription = _service.listenToAdminNotifications((newNotif) {
      final isDuplicate = _rawNotifications.any((n) => n.id == newNotif.id);

      if (!isDuplicate) {
        _rawNotifications.insert(0, newNotif);
        _errorMessage = null;
        _groupDataByDate(_rawNotifications);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _realtimeSubscription?.unsubscribe();
    super.dispose();
  }

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<NotificationModel> rawNotifications = await _service
          .fetchAdminNotifications();

      _rawNotifications = rawNotifications.where((notif) {
        final titleLower = notif.title.toLowerCase();
        if (titleLower.contains('ulasan') ||
            titleLower.contains('pesanan') ||
            titleLower.contains('review')) {
          return notif.orderId != null && notif.orderId!.isNotEmpty;
        }
        return true;
      }).toList();

      if (_rawNotifications.isEmpty) {
        _errorMessage = "Tidak ada notifikasi untuk ditampilkan.";
        _groupedNotifications = [];
      } else {
        _groupDataByDate(_rawNotifications);
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
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

    _groupedNotifications = grouped.entries.map((e) {
      return {'date': e.key, 'items': e.value};
    }).toList();
  }
}
