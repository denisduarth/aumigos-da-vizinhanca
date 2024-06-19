import 'dart:math';

import 'package:aumigos_da_vizinhanca/src/models/animal.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz_all;

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  void _setupNotifications() async {
    // await _setupTimezone();
    await _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidIcon = AndroidInitializationSettings("");
    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: androidIcon,
      ),
    );
  }

  // Future<void> _setupTimezone() async {
  //   tz_all.initializeTimeZones();
  //   final String actualTimezone =
  //       await FlutterNativeTimezone.getLocalTimezone();
  //   tz.setLocalLocation(
  //     tz.getLocation(actualTimezone),
  //   );
  // }

  void showNotification(Animal animal) {
    final notificationDetails = {
      'android': const AndroidNotificationDetails(
        'notifications_x',
        'Lembretes de alimentação',
        channelDescription: 'Está na hora de alimentar seus animais',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true,
      ),
      'ios': const DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
        presentBadge: true,
        presentBanner: true,
        subtitle: 'Está na hora de alimentar seus animais',
      ),
    };

    localNotificationsPlugin.show(
      Random().nextInt(100),
      "Alimentação",
      "Está na hora de aliementar ${animal.name}",
      NotificationDetails(
        android: notificationDetails['android'] as AndroidNotificationDetails,
        iOS: notificationDetails['android'] as DarwinNotificationDetails,
      ),
    );
  }
}
