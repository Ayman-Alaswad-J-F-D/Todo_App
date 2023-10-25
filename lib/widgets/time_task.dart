import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeTask extends StatelessWidget {
  const TimeTask({
    Key? key,
    required this.time,
    this.decoration,
  }) : super(key: key);

  final String time;
  final TextDecoration? decoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      time,
      style: TextStyle(fontSize: 14.sp, decoration: decoration),
    );
  }
}
