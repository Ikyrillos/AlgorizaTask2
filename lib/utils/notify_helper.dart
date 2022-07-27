import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sprinty/data/task.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  initializeNotification() async {
    configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      onNotification.add(payload);
    });
  }

  // new static schedule notification
  void showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime scheduleDate,
  }) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduleDate, tz.local),
        await _notificationDetails(),
        payload: payload,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        androidAllowWhileIdle: true);
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    Get.dialog(const Text('my notification'));
  }

  Future selectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    } else {
      debugPrint("Notification Done");
    }
    Get.to(() => Container());
  }

  void displayNotification(
      {int id = 0, required String title, required String body}) async {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
        'your channel id', 'your channel name',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: 'It could be anything you pass',
    );
  }

// NOt Working
  // void scheduledNotification(int hours, int minutes, Task task) async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'scheduled title',
  //       'theme changes 5 seconds ago',
  //       convertTime(hours, minutes),
  //       const NotificationDetails(
  //           android: AndroidNotificationDetails(
  //         'your channel id',
  //         'your channel name',
  //       )),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }

  // tz.TZDateTime convertTime(int hours, int minutes) {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduleDate =
  //       tz.TZDateTime(tz.local, now.year, now.month, now.day, hours, minutes);
  //   if (scheduleDate.isBefore(now)) {
  //     scheduleDate = scheduleDate.add(Duration(seconds: 5));
  //   }
  //   return scheduleDate;
  // }

  static Future configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
// Logger.log('Timezone: $timeZoneName', className: '$AppConfig');
    try {
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
// Failed to get timezone or device is GMT or UTC, assign generic timezone
      const String fallback = 'Africa/Egypt';
// Logger.log('Could not get a legit timezone, setting as $fallback',
// className: '$AppConfig');
      tz.setLocalLocation(tz.getLocation(fallback));
    }
  }

  // new static schedule notification

}
