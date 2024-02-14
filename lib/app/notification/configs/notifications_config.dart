import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todo_app/app/notification/configs/tz_date_time_config.dart';

import 'keys.dart';

abstract class NotificationConfig {
  Future<void> initialize();

  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin;

  BehaviorSubject<Map> get onClickNotification;

  Future<List<PendingNotificationRequest>> getPendingNotifications();

  Future<List<ActiveNotification>> getActiveNotifications();
}

class NotificationConfigImpl implements NotificationConfig {
  const NotificationConfigImpl._();
  static const NotificationConfigImpl instance = NotificationConfigImpl._();

  static final _flutterNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final _onClickNotification = BehaviorSubject<Map>();

  @override
  FlutterLocalNotificationsPlugin get flutterLocalNotificationsPlugin =>
      _flutterNotificationsPlugin;

  @override
  BehaviorSubject<Map> get onClickNotification => _onClickNotification;

  @override
  Future<void> initialize() async {
    try {
      const _initSettingsAndroid =
          AndroidInitializationSettings(ICON_APP_NOTIFICATION_);

      const _initSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
      );
      const _initSettings = InitializationSettings(
        android: _initSettingsAndroid,
        iOS: _initSettingsIOS,
      );
      _requestNotificationsPermission();
      _setupChannel();
      _setupGroupChannel();

      TZDateTimeConfig.initTZDateTime;

      _flutterNotificationsPlugin.initialize(
        _initSettings,
        onDidReceiveNotificationResponse: _onTapNotificationHandler,
        onDidReceiveBackgroundNotificationResponse: _onTapNotificationHandler,
      );

      final _isNotificationAppLaunch =
          await _flutterNotificationsPlugin.getNotificationAppLaunchDetails();

      log("Notifications Configured ✅", name: "Notification Service");
      log(
        "${_isNotificationAppLaunch?.didNotificationLaunchApp}",
        name: "Launched via a notification",
      );
    } catch (e) {
      log(e.toString(), name: "Error in initialize Notification Configured");
    }
  }

  static void _requestNotificationsPermission() async {
    await _flutterNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void _setupChannel() async {
    const _channel = AndroidNotificationChannel(channel_id, channel_title);
    await _flutterNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static void _setupGroupChannel() async {
    const _channelGroup = AndroidNotificationChannelGroup(
      channel_group_id,
      channel_group_title,
    );
    await _flutterNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannelGroup(_channelGroup);
  }

  //* Callback for handling when a notification is triggered while the app is in the foreground. for IOS
  static void _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {}

  //* [onTap] on any notification in Forground of Background. for Android
  @pragma('vm:entry-point')
  static void _onTapNotificationHandler(
    NotificationResponse? notificationResponse,
  ) async {
    final int? notificationID = notificationResponse?.id;
    final String? titleTask = notificationResponse?.payload;
    final Map map = {
      "payload": titleTask.toString(),
      "notificationId": notificationID,
    };
    debugPrint('Notification Payload: $map');
    if (titleTask != null && notificationID != null) {
      _onClickNotification.add(map);
    }
  }

  @override
  Future<List<ActiveNotification>> getActiveNotifications() async =>
      await _flutterNotificationsPlugin.getActiveNotifications().then((value) {
        log(value.length.toString(), name: "Active  Notifications Count");
        return value;
      });

  @override
  Future<List<PendingNotificationRequest>> getPendingNotifications() async =>
      await _flutterNotificationsPlugin
          .pendingNotificationRequests()
          .then((value) {
        log(value.length.toString(), name: "Pending Notifications Count");
        return value;
      });
}
