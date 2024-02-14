import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/modules/all_tasks_screen/all_tasks_screen.dart';
import 'package:todo_app/modules/done_tasks/done_tasks_screen.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/widgets/label_widget.dart';
import 'package:todo_app/widgets/list_view_animation.dart';

import '../../widgets/custom_divider.dart';
import '../constants/constants.dart';
import 'build_task_item.dart';

class TasksListBuilder extends StatelessWidget {
  const TasksListBuilder({
    Key? key,
    required this.tasks,
    this.isDone = false,
  }) : super(key: key);

  final List<TaskModel> tasks;
  final bool isDone;

  int _getLength() {
    return isDone
        ? (tasks.length >= 2 ? 2 : tasks.length)
        : (tasks.length > 4 ? 4 : tasks.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: isDone ? 6 : 7,
          child: ListView.separated(
            // reverse: true,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: _getLength(),
            itemBuilder: (context, index) => ListViewAnimation(
              index: index,
              delay: 800,
              verticalOffset: false,
              horizontalOffset: widthScreen(context) - 30,
              child: BuildTaskItem(data: tasks[index], isDone: isDone),
            ),
            separatorBuilder: (context, index) => CustomDivider(
              index: index,
              delayAnimation: 600,
              verticalOffsetAnimation: false,
            ),
          ),
        ),
        if (tasks.length >= 3)
          Expanded(
            child: TextButton(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              style: TextButton.styleFrom(
                elevation: 12,
                padding: EdgeInsets.zero,
                backgroundColor: AppColors.primary.shade100,
                minimumSize: const Size(double.maxFinite, 20),
                maximumSize: const Size(double.maxFinite, 30),
              ),
              child: const LabelWidget(
                title: 'See All',
                fontSize: 11,
                color: AppColors.primary,
              ),
              onPressed: () => isDone
                  ? context.toScreen(screen: const DoneTasksScreen())
                  : context.toScreen(screen: const AllTasksScreen()),
            ),
          ),
      ],
    );
  }
}
