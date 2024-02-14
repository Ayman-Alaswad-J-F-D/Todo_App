import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app/app/notification/configs/keys.dart';

abstract class GroupNotifications {
  Future<NotificationDetails> groupNotificationDetails({
    String? iconNotification,
    Color? color,
  });

  Future<AndroidNotificationDetails> getGroupAndroidNotificationDetails({
    String? iconNotification,
    Color? color,
  });

  InboxStyleInformation getGroupNotificationInbox({
    String label,
    String summaryText,
  });

  set addTitelGroup(String? value);

  set removeTitelGroup(String? title);

  int get getInboxNotificationsTitelsGroupLength;

  void clearInboxNotificationsTitlesGroup();
}

class GroupNotificationsImpl implements GroupNotifications {
  @override
  Future<NotificationDetails> groupNotificationDetails({
    String? iconNotification,
    Color? color,
  }) async {
    //* IOS Notification Details
    const iosNotificationDetails = DarwinNotificationDetails();
    //* Android Notification Details
    final androidNotificationDetails = await getGroupAndroidNotificationDetails(
      iconNotification: iconNotification,
      color: color,
    );
    return NotificationDetails(
      iOS: iosNotificationDetails,
      android: androidNotificationDetails,
    );
  }

  @override
  Future<AndroidNotificationDetails> getGroupAndroidNotificationDetails({
    String? iconNotification,
    Color? color,
  }) async {
    // final icon = await PathToImage.clipImage(iconNotification);
    // final largIcon = icon != null ? ByteArrayAndroidBitmap(icon) : null;
    try {
      return AndroidNotificationDetails(
        channel_group_id, channel_group_title,
        channelDescription: channel_description,
        //* Style
        colorized: true,
        color: color,
        //* For Make Notification as Group
        playSound: false,
        groupKey: group_key,
        setAsGroupSummary: true,
        styleInformation: getGroupNotificationInbox(),
        // groupAlertBehavior: GroupAlertBehavior.children,
        number: _inboxNotificationsTitlesGroup.length,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  InboxStyleInformation getGroupNotificationInbox({
    String label = "Your Tasks",
    String summaryText = "New Tasks",
  }) =>
      InboxStyleInformation(
        _inboxNotificationsTitlesGroup,
        contentTitle: label,
        summaryText: summaryText,
      );

  final _inboxNotificationsTitlesGroup = <String>[];

  @override
  set addTitelGroup(String? value) {
    if (value != null) _inboxNotificationsTitlesGroup.add(value);
  }

  @override
  set removeTitelGroup(String? title) {
    if (title != null) _inboxNotificationsTitlesGroup.remove(title);
  }

  @override
  int get getInboxNotificationsTitelsGroupLength =>
      _inboxNotificationsTitlesGroup.length;

  @override
  void clearInboxNotificationsTitlesGroup() =>
      _inboxNotificationsTitlesGroup.clear();
}
