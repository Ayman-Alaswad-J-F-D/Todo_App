import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/widgets/label_widget.dart';
import '../shared/styles/colors.dart';

void showToastShort({
  required String text,
  required ToastStates state,
  required context,
  double fontSize = 16,
  double? padLeft,
  double? padRight,
}) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: LabelWidget(
          title: text,
          color: AppColors.white,
          fontWeight: FontWeight.w300,
          textAlign: TextAlign.center,
          fontSize: fontSize,
        ),
        backgroundColor: chooseToastColor(state),
        margin: EdgeInsets.only(
          bottom: 55.h,
          left: padLeft ?? widthScreen(context) / 3,
          right: padRight ?? widthScreen(context) / 3,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );

// ignore: constant_identifier_names
enum ToastStates { SUCCESS, Done, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = AppColors.green;
      break;
    case ToastStates.Done:
      color = AppColors.primary;
      break;
    case ToastStates.ERROR:
      color = AppColors.red;
      break;
    case ToastStates.WARNING:
      color = AppColors.deepOrangeS300;
      break;
  }
  return color;
}
