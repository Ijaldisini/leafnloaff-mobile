import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminNotificationViewModel extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Map<String, List<Map<String, dynamic>>> _groupedNotifications = {};
  Map<String, List<Map<String, dynamic>>> get groupedNotifications =>
      _groupedNotifications;

  Future<void> fetchNotifications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final adminId = _supabase.auth.currentUser?.id;

      if (adminId == null) {
        throw Exception("Admin tidak ditemukan");
      }

      final response = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', adminId)
          .order('created_at', ascending: false);

      debugPrint("====== DATA NOTIFIKASI DARI SUPABASE ======");
      debugPrint(response.toString());
      debugPrint("JUMLAH DATA: ${response.length}");

      if (response.isEmpty) {
        _errorMessage =
            "$errorMessage\nTidak ada notifikasi untuk ditampilkan.";
      } else {
        _groupDataByDate(response);
      }
    } catch (e) {
      _errorMessage = "Error Sistem: $e";
      debugPrint("Error fetching notifications: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _groupDataByDate(List<dynamic> data) {
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var item in data) {
      final createdAt = DateTime.parse(item['created_at']).toLocal();
      final date = DateTime(createdAt.year, createdAt.month, createdAt.day);

      String groupKey;
      if (date == today) {
        groupKey = 'Today';
      } else if (date == yesterday) {
        groupKey = 'Yesterday';
      } else {
        groupKey = _formatDate(date);
      }

      if (!grouped.containsKey(groupKey)) {
        grouped[groupKey] = [];
      }
      grouped[groupKey]!.add(item as Map<String, dynamic>);
    }

    _groupedNotifications = grouped;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);

      fetchNotifications();
    } catch (e) {
      debugPrint("Error marking notification as read: $e");
    }
  }
}
