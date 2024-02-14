import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TZDateTimeConfig {
  static tz.TZDateTime? _timeSchedule; // The Format [TZDateTime] in 24 h

  static tz.TZDateTime? get timeScheduleNotification => _timeSchedule;

  static set setTimeScheduleNotification(tz.TZDateTime? value) =>
      _timeSchedule = value;

  static void get initTZDateTime => tz.initializeTimeZones();

  static bool timeScheduleIsValid(String date, String time) =>
      _checkTimeSchedule(date, time);

  static bool _checkTimeSchedule(String date, String time) {
    _timeSchedule = _formatDate(date, time);
    final now = _getTZDateTimeNow();
    log(" TZDateTime Now ", name: now.toString());

    //* It should be after TZ DateTime now in order for notifications to appear on time
    if (_timeSchedule?.isBefore(now) ?? true) {
      log("No This Time is Before ❌", name: _timeSchedule.toString());
      return false;
    }
    log("The Time is Right ✅", name: _timeSchedule.toString());
    return true;
  }

  static tz.TZDateTime _formatDate(String date, String time) {
    //* Format needed for this app
    const format = "MMM d, yyyy HH:mm a";
    time = _checkTime(time);

    //* Date format for formate to [TZDateTime]
    final DateTime alarmDateAndTime =
        DateFormat(format).parse(date + ' ' + time);

    //* Convert To TZDateTime
    final timeSchedulePure = tz.TZDateTime.from(alarmDateAndTime, tz.local);

    log("Alarm Date & Time", name: alarmDateAndTime.toString());

    return timeSchedulePure;
  }

  //* Check time cause the time when it is at [12 PM] should return [00 PM] in [TZDateTime] formate
  static String _checkTime(String time) {
    if (time.split(':')[0] == '12') {
      final h = time.split(':')[0] = '00';
      final m = time.split(':')[1];
      return time = "$h:$m";
    }
    return time;
  }

  static tz.TZDateTime _getTZDateTimeNow() => tz.TZDateTime.now(tz.local);
}
