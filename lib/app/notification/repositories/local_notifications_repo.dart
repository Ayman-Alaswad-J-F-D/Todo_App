import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/app/notification/configs/keys.dart';
import 'package:todo_app/app/notification/configs/notifications_config.dart';
import 'package:todo_app/app/notification/configs/tz_date_time_config.dart';
import 'package:todo_app/app/notification/repositories/group_notifications_repo.dart';
import 'package:todo_app/app/notification/repositories/platforms_notificatoin_repo.dart';
import 'package:todo_app/shared/styles/colors.dart';

abstract class LocalNotification {
  Future<void> simpleNotificationType({
    int? id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  });
  Future<void> scheduleNotificationType({
    required int id, //=> required Unique ID
    required String date,
    required String time,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  });
  Future<void> periodicNotificationType({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
    RepeatInterval? repeatingTime = RepeatInterval.everyMinute,
  });

  Future<void> cancelNotification(int id, {String? title});

  Future<void> cancelNotificationWhenGoToScreen(int id, {String? title});

  Future<void> cancelGroupNotifications();

  Future<void> cancelGroupNotificationsWhenGoToScreen();

  Future<void> cancelAllNotifications();
}

class LocalNotificationImpl implements LocalNotification {
  final PlatformsNotification _platformsNotificationRepo;
  final GroupNotifications _groupNotificationRepo;
  final NotificationConfig _notificationConfig;

  LocalNotificationImpl(
    this._platformsNotificationRepo,
    this._groupNotificationRepo,
    this._notificationConfig,
  );

  final String titleGroupNotifications = "Reminder";
  final String bodyGroupNotifications = "Tasks The Day";

  //? id: [Special ID] If you need push multi Notifications or cancel any notification you want.
  //! example if you using [Schedule Notification].
  //? title: For [title] notification.
  //? body: For [body] notification.
  //? payload: The data that you want to receive when you click on the notification.
  //! example [Navigator to a page with data]. if you want..

  @override
  Future<void> simpleNotificationType({
    int? id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  }) async {
    try {
      await _notificationConfig.flutterLocalNotificationsPlugin.show(
        id!,
        title,
        body,
        _platformsNotificationRepo.notificationDetails(
          iconNotification: iconNotification,
          color: AppColors.purpleOpa,
        ),
        payload: payload,
      );
      if (_isFirstNotification()) return;
      await _notificationConfig.flutterLocalNotificationsPlugin.show(
        group_id,
        titleGroupNotifications,
        bodyGroupNotifications,
        await _groupNotificationRepo.groupNotificationDetails(
          color: AppColors.primary,
        ),
        payload: payload,
      );
    } catch (e) {
      log(e.toString(), name: "Error when Simpel Notification");
    }
  }

  @override
  Future<void> scheduleNotificationType({
    required int id,
    required String date,
    required String time,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  }) async {
    try {
      if (!TZDateTimeConfig.timeScheduleIsValid(date, time)) return;
      _addTitleForInboxGroup(body);
      await _notificationConfig.flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        TZDateTimeConfig.timeScheduleNotification!,
        _platformsNotificationRepo.notificationDetails(
          iconNotification: iconNotification,
          color: AppColors.purpleOpa,
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        // matchDateTimeComponents: DateTimeComponents.time,
      );
      if (_isFirstNotification()) return;
      await _notificationConfig.flutterLocalNotificationsPlugin.zonedSchedule(
        group_id,
        titleGroupNotifications,
        bodyGroupNotifications,
        TZDateTimeConfig.timeScheduleNotification!,
        await _groupNotificationRepo.groupNotificationDetails(
          iconNotification: iconNotification,
          color: AppColors.primary,
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      log(e.toString(), name: "Error when Schedule Notification");
    }
  }

  void _addTitleForInboxGroup(String? value) =>
      _groupNotificationRepo.addTitelGroup = value;

  bool _isFirstNotification() =>
      _groupNotificationRepo.getInboxNotificationsTitelsGroupLength <= 1;

  @override
  Future<void> periodicNotificationType({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
    RepeatInterval? repeatingTime = RepeatInterval.everyMinute,
  }) async {
    try {
      await _notificationConfig.flutterLocalNotificationsPlugin
          .periodicallyShow(
        id,
        title,
        body,
        repeatingTime!,
        _platformsNotificationRepo.notificationDetails(
          iconNotification: iconNotification,
          color: AppColors.purpleOpa,
        ),
        payload: payload,
      );
      await _notificationConfig.flutterLocalNotificationsPlugin
          .periodicallyShow(
        group_id,
        titleGroupNotifications,
        bodyGroupNotifications,
        repeatingTime,
        await _groupNotificationRepo.groupNotificationDetails(
          color: AppColors.primary,
        ),
        payload: payload,
      );
    } catch (e) {
      log(e.toString(), name: "Error when Periodic Notification");
    }
  }

  @override
  Future<void> cancelNotification(int id, {String? title}) async {
    await _cancelNotificationById(id);
    _removeTitleGroup(title);
  }

  @override
  Future<void> cancelNotificationWhenGoToScreen(int id, {String? title}) async {
    if (await _isPendingNotification(id)) return;
    if (await _isActiveNotification(id)) {
      await _cancelNotificationById(id);
      _removeTitleGroup(title);
    }
  }

  @override
  Future<void> cancelGroupNotifications() async {
    await _cancelNotificationById(group_id);
    _clearInboxGroupTitle();
  }

  @override
  Future<void> cancelGroupNotificationsWhenGoToScreen() async {
    if (await _isPendingNotification(group_id)) return;
    if (await _isActiveNotification(group_id)) {
      await _cancelNotificationById(group_id);
      _clearInboxGroupTitle();
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    await _notificationConfig.flutterLocalNotificationsPlugin.cancelAll();
    _clearInboxGroupTitle();
  }

  Future<void> _cancelNotificationById(int id) async =>
      await _notificationConfig.flutterLocalNotificationsPlugin.cancel(id);

  void _removeTitleGroup(String? title) =>
      _groupNotificationRepo.removeTitelGroup = title;

  void _clearInboxGroupTitle() =>
      _groupNotificationRepo.clearInboxNotificationsTitlesGroup();

  Future<bool> _isPendingNotification(int id) async => await _notificationConfig
      .getPendingNotifications()
      .then((listPending) => listPending.any((pending) => pending.id == id));

  Future<bool> _isActiveNotification(int id) async => await _notificationConfig
      .getActiveNotifications()
      .then((listActive) => listActive.any((active) => active.id == id));
}
