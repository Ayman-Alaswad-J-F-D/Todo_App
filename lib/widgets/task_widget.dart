import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/shared/function/check_image.dart';

import 'custom_check_box.dart';
import 'label_widget.dart';
import 'time_task.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    Key? key,
    required this.taskTitle,
    required this.taskTime,
    required this.image,
    required this.checkBoxValue,
    required this.onChange,
    this.isDoneTask = false,
  }) : super(key: key);

  final String taskTitle;
  final String taskTime;
  final String image;
  final bool isDoneTask;
  final Function(bool?) onChange;
  final bool checkBoxValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Opacity(
        opacity: isDoneTask ? .4 : 1,
        child: ListTile(
          enabled: false,
          contentPadding:
              const EdgeInsets.only(left: 14, bottom: 5, top: 5, right: 10),
          minLeadingWidth: 30.w,
          leading: checkImage(context, image: image),
          title: LabelWidget(
            title: taskTitle,
            fontWeight: FontWeight.bold,
            decoration: isDoneTask ? TextDecoration.lineThrough : null,
            pB: 5,
          ),
          subtitle: TimeTask(
            time: taskTime,
            decoration: isDoneTask ? TextDecoration.lineThrough : null,
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
