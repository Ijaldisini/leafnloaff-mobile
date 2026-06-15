import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../views/cust/detail_order_view.dart';
import '../views/admin/admin_order_detail_view.dart';
import '../views/admin/admin_order_review_view.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await _notificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final String? payload = response.payload;

        if (payload != null) {
          if (payload.startsWith('cust_order_')) {
            final orderId = payload.replaceAll('cust_order_', '');
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => DetailOrderView(orderId: orderId),
              ),
            );
          } else if (payload.startsWith('admin_order_')) {
            final orderId = payload.replaceAll('admin_order_', '');
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => AdminOrderDetailView(orderId: orderId),
              ),
            );
          } else if (payload.startsWith('admin_review_')) {
            final orderId = payload.replaceAll('admin_review_', '');
            navigatorKey.currentState?.push(
              MaterialPageRoute(
                builder: (_) => AdminOrderReviewView(orderId: orderId),
              ),
            );
          }
        }
      },
    );
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'leafnloaff_channel',
          'Leaf N Loaff Notifications',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: platformDetails,
      payload: payload,
    );
  }
}
