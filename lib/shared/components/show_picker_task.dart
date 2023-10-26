import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

Future<String> showTimePickerTask(context, timeConttroller) async =>
    await showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then(
          (value) => timeConttroller.text = value!.format(context).toString(),
        )
        .catchError((error) => timeConttroller.text = '');

Future<String> showDatePickerTask(context, dateConttroller) async =>
    await showDatePicker(
      context: context,
      useRootNavigator: false,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    )
        .then(
          (value) => dateConttroller.text = DateFormat.yMMMd().format(value!),
        )
        .catchError((error) => dateConttroller.text = '');
