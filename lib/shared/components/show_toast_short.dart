import 'package:flutter/material.dart';
import '../styles/colors.dart';

void showToastShort(
        {required String text, required ToastStates state, required context}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: chooseToastColor(state),
      ),
    );

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = AppColors.green;
      break;
    case ToastStates.ERROR:
      color = AppColors.red;
      break;
    case ToastStates.WARNING:
      color = AppColors.deebOrangeS300;
      break;
  }
  return color;
}
