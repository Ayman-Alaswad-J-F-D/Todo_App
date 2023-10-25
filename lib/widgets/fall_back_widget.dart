import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/styles/colors.dart';

class FallBackWidget extends StatelessWidget {
  const FallBackWidget({
    Key? key,
    this.isDone = false,
  }) : super(key: key);

  final bool isDone;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 2,
            child: Icon(
              Icons.menu_open_rounded,
              color: AppColors.black38,
              size: 60.r,
            ),
          ),
          SizedBox(height: 20.h),
          Flexible(
            child: Text(
              isDone
                  ? 'No Done Task Yet !'
                  : 'No Tasks Yet, Please Add Some Tasks',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }
}
