import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:todo_app/shared/styles/colors.dart';

class LabelWidget extends StatelessWidget {
  const LabelWidget({
    Key? key,
    required this.title,
    this.color = AppColors.black,
    this.fontSize = 16,
    this.fontWeight = FontWeight.bold,
    this.textAlign = TextAlign.start,
    this.italic = false,
    this.spacing,
    this.decoration,
    this.pT = 0.0,
    this.pB = 0.0,
    this.pR = 0.0,
    this.pL = 0.0,
  }) : super(key: key);

  final String title;
  final Color color;
  final double fontSize;
  final double? spacing;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final bool italic;

  final double pT;
  final double pB;
  final double pR;
  final double pL;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: pT,
        bottom: pB,
        left: pL,
        right: pR,
      ),
      child: Text(
        title,
        textAlign: textAlign,
        style: TextStyle(
          color: color,
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          decoration: decoration,
          letterSpacing: spacing,
          fontStyle: italic ? FontStyle.italic : null,
        ),
      ),
    );
  }
}
