import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/app/notification/repositories/local_notifications_repo.dart';

abstract class LocalNotificationsService {
  void popupNotification({
    int? id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  });

  void scheduleNotification({
    required int id,
    required String date,
    required String time,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  });

  void periodicNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
    RepeatInterval? repeatingTime = RepeatInterval.everyMinute,
  });

  void cancelNotification(int id, {String? title});

  void cancelNotificationWhenGoToScreen(int id, {String? title});

  void cancelGroupNotifications();

  void cancelGroupNotificationsWhenGoToScreen();

  void cancelAllNotificationsForce();
}

class LocalNotificationsServiceImpl implements LocalNotificationsService {
  final LocalNotification _notification;
  LocalNotificationsServiceImpl(this._notification);

  //* Simple Notification
  @override
  void popupNotification({
    int? id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  }) =>
      _notification.simpleNotificationType(
        id: id,
        title: title,
        body: body,
        iconNotification: iconNotification,
        payload: payload,
      );

  //* Schedule Notification
  @override
  void scheduleNotification({
    required int id,
    required String date,
    required String time,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
  }) =>
      _notification.scheduleNotificationType(
        id: id,
        date: date,
        time: time,
        title: title,
        body: body,
        payload: payload,
        iconNotification: iconNotification,
      );

  //* Periodic notification at regular interval
  @override
  void periodicNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
    String? iconNotification,
    RepeatInterval? repeatingTime = RepeatInterval.everyMinute,
  }) =>
      _notification.periodicNotificationType(
        id: id,
        title: title,
        body: body,
        iconNotification: iconNotification,
        repeatingTime: repeatingTime,
        payload: payload,
      );

  @override
  void cancelNotification(int id, {String? title}) =>
      _notification.cancelNotification(id, title: title);

  @override
  void cancelNotificationWhenGoToScreen(int id, {String? title}) =>
      _notification.cancelNotificationWhenGoToScreen(id, title: title);

  @override
  void cancelGroupNotifications() => _notification.cancelGroupNotifications();

  @override
  void cancelGroupNotificationsWhenGoToScreen() =>
      _notification.cancelGroupNotificationsWhenGoToScreen();

  @override
  void cancelAllNotificationsForce() => _notification.cancelAllNotifications();
}
