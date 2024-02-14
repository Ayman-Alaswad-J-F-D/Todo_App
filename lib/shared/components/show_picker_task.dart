import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String> showTimePickerTask(
  BuildContext context,
  TextEditingController timeConttroller,
) async =>
    await showTimePicker(context: context, initialTime: TimeOfDay.now())
        .then(
          (value) => timeConttroller.text = value!.format(context).toString(),
        )
        .catchError((error) => timeConttroller.text = '');

Future<String> showDatePickerTask(
  BuildContext context,
  TextEditingController dateConttroller,
) async =>
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
