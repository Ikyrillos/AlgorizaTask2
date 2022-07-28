import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sprinty/data/task.dart';
import 'package:style_cron_job/style_cron_job.dart';
// ignore: depend_on_referenced_packages
import 'package:timezone/data/latest.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
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

  void createReminderAndRepeat(DateTime fullTime, Task task) {
    DateTime date = DateFormat.jm().parse(task.endTime.toString());
    var myEndTime = DateFormat("HH:mm").format(date);
    var endHours = int.parse(myEndTime.toString().split(':')[0]);
    var endMinutes = int.parse(myEndTime.toString().split(':')[1]);
    DateTime fullTime2 = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, endHours, endMinutes);

    if (task.reminder == '1 day before') {
      debugPrint("1 d before");

      task.repeat == "Daily"
          ? each.day
              .atHour(fullTime.hour - 24)
              .atMinute(fullTime.minute - 10)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            })
          : each.week
              .onWeekDay(fullTime.day)
              .atHour(fullTime.hour - 24)
              .atMinute(fullTime.minute - 10)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            });
    } else if (task.reminder == "1 hour before") {
      debugPrint("1 h before");
      task.repeat == "Daily"
          ? each.day
              .atHour(fullTime.hour - 1)
              .atMinute(fullTime.minute)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            })
          : each.week
              .onWeekDay(fullTime.day)
              .atHour(fullTime.hour - 1)
              .atMinute(fullTime.minute)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            });
    } else if (task.reminder == "30 minute before") {
      debugPrint("30 minute before");
      task.repeat == "Daily"
          ? each.day
              .atHour(fullTime.hour)
              .atMinute(fullTime.minute - 30)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            })
          : each.week
              .onWeekDay(fullTime.day)
              .atHour(fullTime.hour)
              .atMinute(fullTime.minute - 30)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            });
    } else if (task.reminder == "10 min before") {
      debugPrint("10 min before");
      task.repeat == "Daily"
          ? each.day
              .atHour(fullTime.hour)
              .atMinute(fullTime.minute - 10)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            })
          : each.week
              .onWeekDay(fullTime.day)
              .atHour(fullTime.hour)
              .atMinute(fullTime.minute - 10)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            });
    } else {
      task.repeat == "Daily"
          ? each.minute
              .only((t) => t.minute <= fullTime.minute - 10)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            })
          : each.week
              .onWeekDay(fullTime.day)
              .atHour(fullTime.hour)
              .atMinute(fullTime.minute - 10)
              .atSecond(1)
              .listen((time) {
              displayNotification(title: task.title!, body: task.date!);
            });
    }
  }

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

}
