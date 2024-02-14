import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:todo_app/app/notification/configs/keys.dart';
import 'package:todo_app/app/notification/configs/notifications_config.dart';
import 'package:todo_app/app/services/local_notifications_service.dart';

import '../../app/global/global.dart';
import '../../modules/all_tasks_screen/all_tasks_screen.dart';
import '../../modules/details_screen/details_screen.dart';

//* For listen to any notification is clicked or not
void listenToNotification() async {
  log("Listen To Notification", name: "START");
  final _notificationConfig = Global.getIt.get<NotificationConfig>();
  _notificationConfig.onClickNotification.stream.listen(
    (payload) async {
      if (payload.containsValue(group_id)) return _goToAllTasksScreen();
      _goToDetailsScreen(payload);
    },
    onDone: () => log("Listen To Notification", name: " END "),
    onError: (error) => log("Listen To Notification: $error", name: "ERROR"),
  );
}

void _goToAllTasksScreen() {
  _navigatorTo(screen: const AllTasksScreen());
  final _notificationService = Global.getIt.get<LocalNotificationsService>();
  _notificationService.cancelGroupNotifications();
}

void _goToDetailsScreen(Map payload) {
  final int id = payload.values.last;
  _navigatorTo(screen: DetailsScreen(taskId: id));
  final String title = payload.values.first;
  final _notificationService = Global.getIt.get<LocalNotificationsService>();
  _notificationService.cancelNotification(id, title: title);
}

void _navigatorTo({required Widget screen}) =>
    Navigator.of(Global.globalNavigatorKey.currentContext!)
        .push(MaterialPageRoute(builder: (context) => screen));
