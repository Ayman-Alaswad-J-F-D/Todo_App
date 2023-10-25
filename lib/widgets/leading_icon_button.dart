import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/styles/colors.dart';

class LeadingIconButton extends StatelessWidget {
  const LeadingIconButton({
    Key? key,
    required this.icon,
    required this.click,
  }) : super(key: key);

  final IconData icon;
  final Function()? click;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 22.r,
      backgroundColor: AppColors.white,
      child: IconButton(
        icon: Icon(icon),
        color: AppColors.primary,
        iconSize: 18.r,
        onPressed: click,
      ),
    );
  }
}
