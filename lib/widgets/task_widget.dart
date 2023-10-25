import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/shared/function/check_image.dart';

import 'custom_check_box.dart';
import 'time_task.dart';
import 'label_widget.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    Key? key,
    required this.taskTitle,
    required this.taskTime,
    required this.image,
    required this.checkBoxValue,
    required this.onChange,
    this.opacity = 1,
    this.decoration,
  }) : super(key: key);

  final String taskTitle;
  final String taskTime;
  final String image;
  final double opacity;
  final TextDecoration? decoration;
  final Function(bool?) onChange;
  final bool checkBoxValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Opacity(
        opacity: opacity,
        child: ListTile(
          enabled: false,
          contentPadding:
              const EdgeInsets.only(left: 14, bottom: 5, top: 5, right: 10),
          minLeadingWidth: 30.w,
          leading: checkImage(image: image),
          title: LabelWidget(
            title: taskTitle,
            fontWeight: FontWeight.bold,
            decoration: decoration,
            pB: 5,
          ),
          subtitle: TimeTask(
            time: taskTime,
            decoration: decoration,
          ),
          trailing: CustomCheckBox(
            value: checkBoxValue,
            onChange: onChange,
          ),
        ),
      ),
    );
  }
}
