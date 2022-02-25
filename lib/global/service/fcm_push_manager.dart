import 'dart:convert';

import 'package:crediApp/global/singleton.dart';
import 'package:crediApp/global/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class FcmPushManager {
  static final FcmPushManager _manager = FcmPushManager._internal();

  factory FcmPushManager() {
    return _manager;
  }
  FcmPushManager._internal() {
    // 초기화 코드
  }

  final fcm = FirebaseMessaging.instance;
  final _notification = FlutterLocalNotificationsPlugin();
  final onNotifications = BehaviorSubject<String?>();

  Future init({bool initScheduled = false}) async {
    final details = await _notification.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.payload);
    }

    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notification.initialize(settings,
        onSelectNotification: (payload) async {
      onNotifications.add(payload);
    });

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  Future registerNotification() async {
    NotificationSettings settings = await fcm.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      Singleton.shared.userData!.user =
          Singleton.shared.userData!.user!.copyWith(pushEnabled: true);
      print('accept push permission');
    } else {
      print('not accept push permission');
      Singleton.shared.userData!.user =
          Singleton.shared.userData!.user!.copyWith(pushEnabled: false);
    }

    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    // fcm.subscribeToTopic("factory");
    // fcm.subscribeToTopic(Singleton.shared.userData!.userId.toString());
    // fcm.subscribeToTopic('client');
    await fcm.getToken().then((token) {
      logger.i('token: $token');
      Singleton.shared.userData!.user!.fcmToken = token;
    }).catchError((err) {
      print(err);
    });
  }

  Future _notificationDetails(RemoteNotification notification) async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        "com.credi.crediapp",
        notification.title!,
        notification.body!,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
        priority: Priority.high,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  Future showNotification(RemoteMessage message) async {
    RemoteNotification notification = message.notification!;
    if (message.data['type'] == 'client') {
      _notification.show(
        0,
        notification.title,
        notification.body,
        await _notificationDetails(notification),
        payload: jsonEncode(message.data),
      );
    }
  }

  void cancel(int id) => _notification.cancel(id);
  void cancelAll() => _notification.cancelAll();

  // static Future showScheduleNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payload,
  //   required DateTime scheduleDate,
  // }) async =>
  //     _notification.zonedSchedule(id, title, body, _scheduleDaily(Time(8)),
  //         await _notificationDetails(),
  //         payload: payload,
  //         androidAllowWhileIdle: true,
  //         uiLocalNotificationDateInterpretation:
  //             UILocalNotificationDateInterpretation.absoluteTime,
  //         matchDateTimeComponents: DateTimeComponents.time);

  // static tz.TZDateTime _scheduleDaily(Time time) {
  //   final now = tz.TZDateTime.now(tz.local);
  //   final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
  //       time.hour, time.minute, time.second);
  //   return scheduleDate.isBefore(now)
  //       ? scheduleDate.add(Duration(days: 1))
  //       : scheduleDate;
  // }

}
