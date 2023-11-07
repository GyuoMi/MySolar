import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_solar_app/screens/tracking_page.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final BuildContext context;
  final Function(String payload) onNotificationTapped;
  NotificationService({required this.context, required this.onNotificationTapped});

  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('my_solar_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max, priority: Priority.high, ongoing: true),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin
        .show(id, title, body, await notificationDetails(), payload: payLoad);
  }

  Future<void> handleNotification(String payload) async {
    if (payload == 'tracking_page') {
      onNotificationTapped(payload);
    }
  }
}
