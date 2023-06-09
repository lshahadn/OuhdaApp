import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

class NotificationAPI {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'Channel id',
        'Channel name',
        channelDescription: 'Channel description',
        importance: Importance.max,
        playSound: false,
        // sound: AndroidNotificationSound('slow_spring_board'),
      ),
      // iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings("@mipmap/ic_launcher");
    final ios = DarwinInitializationSettings();

    final settings = InitializationSettings(
      android: android,
      iOS: ios
    );

    await _notification.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async {
      onNotifications.add(payload.payload);
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notification.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );


}
