import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path/path.dart';

import '../configs/keys.dart';

abstract class PlatformsNotification {
  NotificationDetails notificationDetails({
    String? iconNotification,
    Color? color,
  });
}

class PlatformsNotificationImpl implements PlatformsNotification {
  static const defaultNotificationIcon = "splash";

  @override
  NotificationDetails notificationDetails({
    String? iconNotification,
    Color? color,
  }) {
    //* IOS Platform Notification Details
    final iosNotificationDetails = _getIOSNotificationDetails();
    //* Android Platform Notification Details
    final androidNotificationDetails =
        _getAndroidNotificationDetails(iconNotification, color: color);
    return NotificationDetails(
      iOS: iosNotificationDetails,
      android: androidNotificationDetails,
    );
  }

  //* Details for Notification IOS
  DarwinNotificationDetails _getIOSNotificationDetails() =>
      const DarwinNotificationDetails();

  //? Notes for [largeIcon] property :
  /*
    1- File location: Make sure that the image file is located in the res/drawable directory of your Android project.
        The FilePathAndroidBitmap constructor expects the file path to be relative to the project's root directory.
    2- File format: Android only supports certain image formats for notifications.
         Make sure that your image file is in one of the following formats:   JPEG, PNG, or BMP.
    3- File permissions: Make sure that your app has the necessary permissions to access the image file.
        You can check the file permissions by running the ls -l command in the terminal.
    4- Image size: Make sure that the image file is not too large.
        Android has a maximum size limit for notification icons, which is 4096 x 4096 pixels and 1MB in size. 
  */

  //* Details and Style for Notification Android
  AndroidNotificationDetails _getAndroidNotificationDetails(
    String? iconNotification, {
    Color? color,
    String? subText,
  }) {
    final icon = _getIconNotification(iconNotification);
    final largIcon = _getLargIconNotification(iconNotification);

    return AndroidNotificationDetails(
      channel_id, channel_title,
      channelDescription: channel_description,
      ticker: ticker,
      priority: Priority.high,
      importance: Importance.max,
      groupKey: group_key,
      //* Style
      icon: icon,
      colorized: true,
      color: color,
      subText: subText,
      largeIcon: largIcon,
      category: AndroidNotificationCategory.reminder,
    );
  }

  static String? _getIconNotification(String? iconNotification) {
    if (iconNotification == null) return defaultNotificationIcon;
    return iconNotification = _extractIconName(iconNotification);
  }

  static String _extractIconName(String iconPath) =>
      basename(iconPath.split(".")[0]);

  //* When you add a new image in a [drawable] project file .. Please run the app again.
  // just add image name.. without extension '.png, ..etc'.
  static DrawableResourceAndroidBitmap? _getLargIconNotification(
    String? iconNotification,
  ) {
    if (iconNotification == null) return null;
    return const DrawableResourceAndroidBitmap(ICON_APP_NOTIFICATION_);
  }
}
