import 'dart:typed_data';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';

import 'main.dart';

Future<void> showNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', 'plain body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> showNotificationWithNoBody() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'plain title', null, platformChannelSpecifics,
      payload: 'item x');
}

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancel(0);
}

/// Schedules a notification that specifies a different icon, sound and vibration pattern
Future<void> scheduleNotification(int time) async {
  var scheduledNotificationDateTime =
      DateTime.now().add(Duration(seconds: time));
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'app_icon',
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500);
  var iOSPlatformChannelSpecifics =
      IOSNotificationDetails(sound: "slow_spring_board.aiff");
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      'scheduled title',
      'scheduled body',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

/// Schedules a notification that specifies a different icon, sound and vibration pattern
Future<void> scheduleExpiryNotification(
    int time, DateTime expiryDate, String itemName) async {
  final formatter = DateFormat('yyyy-MM-dd');
  final formattedExpiryDate = formatter.format(expiryDate);
  // final formattedExpiryDate =
  //     formatter.format(DateTime.now().add(Duration(days: 3)));

  var scheduledNotificationDateTime =
      DateTime.now().add(Duration(seconds: time));
  var vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;

  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      'your other channel description',
      icon: 'app_icon',
      vibrationPattern: vibrationPattern,
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500);
  var iOSPlatformChannelSpecifics =
      IOSNotificationDetails(sound: "slow_spring_board.aiff");
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.schedule(
      0,
      '${itemName} expiring on',
      '${formattedExpiryDate}',
      scheduledNotificationDateTime,
      platformChannelSpecifics);
}

Future<void> showNotificationWithNoSound() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'silent channel id', 'silent channel name', 'silent channel description',
      playSound: false, styleInformation: DefaultStyleInformation(true, true));
  var iOSPlatformChannelSpecifics = IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, '<b>silent</b> title', '<b>silent</b> body', platformChannelSpecifics);
}

Future<void> showBigTextNotification() async {
  var bigTextStyleInformation = BigTextStyleInformation(
      'Lorem <i>ipsum dolor sit</i> amet, consectetur <b>adipiscing elit</b>, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      htmlFormatBigText: true,
      contentTitle: 'overridden <b>big</b> content title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      style: AndroidNotificationStyle.BigText,
      styleInformation: bigTextStyleInformation);
  var platformChannelSpecifics =
      NotificationDetails(androidPlatformChannelSpecifics, null);
  await flutterLocalNotificationsPlugin.show(
      0, 'big text title', 'silent body', platformChannelSpecifics);
}

Future<void> showInboxNotification() async {
  var lines = List<String>();
  lines.add('line <b>1</b>');
  lines.add('line <i>2</i>');
  var inboxStyleInformation = InboxStyleInformation(lines,
      htmlFormatLines: true,
      contentTitle: 'overridden <b>inbox</b> context title',
      htmlFormatContentTitle: true,
      summaryText: 'summary <i>text</i>',
      htmlFormatSummaryText: true);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'inbox channel id', 'inboxchannel name', 'inbox channel description',
      style: AndroidNotificationStyle.Inbox,
      styleInformation: inboxStyleInformation);
  var platformChannelSpecifics =
      NotificationDetails(androidPlatformChannelSpecifics, null);
  await flutterLocalNotificationsPlugin.show(
      0, 'inbox title', 'inbox body', platformChannelSpecifics);
}

Future<void> showGroupedNotifications() async {
  var groupKey = 'com.android.example.WORK_EMAIL';
  var groupChannelId = 'grouped channel id';
  var groupChannelName = 'grouped channel name';
  var groupChannelDescription = 'grouped channel description';
  // example based on https://developer.android.com/training/notify-user/group.html
  var firstNotificationAndroidSpecifics = AndroidNotificationDetails(
      groupChannelId, groupChannelName, groupChannelDescription,
      importance: Importance.Max, priority: Priority.High, groupKey: groupKey);
  var firstNotificationPlatformSpecifics =
      NotificationDetails(firstNotificationAndroidSpecifics, null);
  await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
      'You will not believe...', firstNotificationPlatformSpecifics);
  var secondNotificationAndroidSpecifics = AndroidNotificationDetails(
      groupChannelId, groupChannelName, groupChannelDescription,
      importance: Importance.Max, priority: Priority.High, groupKey: groupKey);
  var secondNotificationPlatformSpecifics =
      NotificationDetails(secondNotificationAndroidSpecifics, null);
  await flutterLocalNotificationsPlugin.show(
      2,
      'Jeff Chang',
      'Please join us to celebrate the...',
      secondNotificationPlatformSpecifics);

  // create the summary notification to support older devices that pre-date Android 7.0 (API level 24).
  // this is required is regardless of which versions of Android your application is going to support
  var lines = List<String>();
  lines.add('Alex Faarborg  Check this out');
  lines.add('Jeff Chang    Launch Party');
  var inboxStyleInformation = InboxStyleInformation(lines,
      contentTitle: '2 messages', summaryText: 'janedoe@example.com');
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      groupChannelId, groupChannelName, groupChannelDescription,
      style: AndroidNotificationStyle.Inbox,
      styleInformation: inboxStyleInformation,
      groupKey: groupKey,
      setAsGroupSummary: true);
  var platformChannelSpecifics =
      NotificationDetails(androidPlatformChannelSpecifics, null);
  await flutterLocalNotificationsPlugin.show(
      3, 'Attention', 'Two messages', platformChannelSpecifics);
}

Future<void> cancelAllNotifications() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> showOngoingNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: false);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(0, 'ongoing notification title',
      'ongoing notification body', platformChannelSpecifics);
}

Future<void> repeatNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeating channel id',
      'repeating channel name',
      'repeating description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
      'repeating body', RepeatInterval.EveryMinute, platformChannelSpecifics);
}

Future<void> showDailyAtTime() async {
  var time = Time(10, 0, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'repeatDailyAtTime channel id',
      'repeatDailyAtTime channel name',
      'repeatDailyAtTime description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      'show daily title',
      'Daily notification shown at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
      time,
      platformChannelSpecifics);
}

Future<void> showWeeklyAtDayAndTime() async {
  var time = Time(10, 0, 0);
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'show weekly channel id',
      'show weekly channel name',
      'show weekly description');
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
      0,
      'show weekly title',
      'Weekly notification shown on Monday at approximately ${_toTwoDigitString(time.hour)}:${_toTwoDigitString(time.minute)}:${_toTwoDigitString(time.second)}',
      Day.Monday,
      time,
      platformChannelSpecifics);
}

Future<void> showNotificationWithNoBadge() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'no badge channel', 'no badge name', 'no badge description',
      channelShowBadge: false,
      importance: Importance.Max,
      priority: Priority.High,
      onlyAlertOnce: true);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, 'no badge title', 'no badge body', platformChannelSpecifics,
      payload: 'item x');
}

Future<void> showProgressNotification() async {
  var maxProgress = 5;
  for (var i = 0; i <= maxProgress; i++) {
    await Future.delayed(Duration(seconds: 1), () async {
      var androidPlatformChannelSpecifics = AndroidNotificationDetails(
          'progress channel',
          'progress channel',
          'progress channel description',
          channelShowBadge: false,
          importance: Importance.Max,
          priority: Priority.High,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: maxProgress,
          progress: i);
      var iOSPlatformChannelSpecifics = IOSNotificationDetails();
      var platformChannelSpecifics = NotificationDetails(
          androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
          0,
          'progress notification title',
          'progress notification body',
          platformChannelSpecifics,
          payload: 'item x');
    });
  }
}

Future<void> showIndeterminateProgressNotification() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'indeterminate progress channel',
      'indeterminate progress channel',
      'indeterminate progress channel description',
      channelShowBadge: false,
      importance: Importance.Max,
      priority: Priority.High,
      onlyAlertOnce: true,
      showProgress: true,
      indeterminate: true);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'indeterminate progress notification title',
      'indeterminate progress notification body',
      platformChannelSpecifics,
      payload: 'item x');
}

Future<void> showNotificationWithUpdatedChannelDescription() async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your updated channel description',
      importance: Importance.Max,
      priority: Priority.High,
      channelAction: AndroidNotificationChannelAction.Update);
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0,
      'updated notification channel',
      'check settings to see updated channel description',
      platformChannelSpecifics,
      payload: 'item x');
}

String _toTwoDigitString(int value) {
  return value.toString().padLeft(2, '0');
}
