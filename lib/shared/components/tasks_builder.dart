import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../styles/colors.dart';
import 'build_task_item.dart';

class TasksBuilder extends StatelessWidget {
  const TasksBuilder({
    Key? key,
    required this.tasks,
    this.isDone = true,
    this.isArchive = true,
  }) : super(key: key);

  final List<Map> tasks;
  final bool isDone;
  final bool isArchive;

  @override
  Widget build(BuildContext context) {
    return ConditionalBuilder(
      condition: tasks.isNotEmpty,
      builder: (context) {
        return ListView.separated(
          itemCount: tasks.length,
          itemBuilder: (context, index) => BuildTaskItem(
            model: tasks[index],
            isDone: isDone,
            isArchive: isArchive,
          ),
          separatorBuilder: (context, index) =>
              const Divider(indent: 20, height: 10),
        );
      },
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.menu_open_rounded, size: 80, color: AppColors.black45),
            SizedBox(height: 20),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(color: AppColors.grey),
            )
          ],
        ),
      ),
    );
  }
}
