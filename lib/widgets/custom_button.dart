import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/shared/styles/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.click,
    required this.text,
  }) : super(key: key);

  final Function()? click;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 6),
      child: ElevatedButton(
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(35.r),
          ),
          padding: const EdgeInsets.all(6),
          minimumSize: Size(double.infinity, 44.spMin),
          textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        onPressed: click,
      ),
    );
  }
}
