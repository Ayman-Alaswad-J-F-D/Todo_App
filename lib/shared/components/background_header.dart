import 'package:flutter/material.dart';
import 'package:todo_app/widgets/label_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles/colors.dart';
import '../../widgets/leading_icon_button.dart';

class BackgroundHeader extends StatelessWidget {
  const BackgroundHeader({
    Key? key,
    this.height,
    required this.headerLabel,
    required this.leadingIcon,
    this.fontSize = 18,
    this.positionedTop = 0,
    this.positionedBottom = 0,
    this.fontWeight = FontWeight.bold,
    this.leadingClick,
  }) : super(key: key);

  final double? height;
  final String headerLabel;
  final FontWeight fontWeight;
  final double fontSize;
  final double? positionedTop;
  final double? positionedBottom;
  final IconData leadingIcon;
  final Function()? leadingClick;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black38,
            blurRadius: 2,
            spreadRadius: 2,
            offset: Offset(0, 1),
          )
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: -85,
            left: -100,
            child: Container(
              padding: const EdgeInsets.all(40),
              width: 220.w,
              height: 220.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white38,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            top: -20,
            right: -90,
            child: Container(
              padding: const EdgeInsets.all(35),
              width: 160.w,
              height: 160.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white12,
                    Colors.white24,
                    Colors.white38,
                    Colors.white38,
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: positionedTop,
            bottom: positionedBottom,
            child: LeadingIconButton(
              icon: leadingIcon,
              click: leadingClick,
            ),
          ),
          Positioned(
            top: positionedTop,
            bottom: positionedBottom,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: LabelWidget(
                title: headerLabel,
                textAlign: TextAlign.center,
                color: AppColors.white,
                fontWeight: fontWeight,
                fontSize: fontSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
