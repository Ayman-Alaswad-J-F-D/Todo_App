import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/tasks_builder.dart';
import '../../shared/cubit/cubit.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoAppCubit, TodoAppStates>(
      builder: (context, state) {
        var tasks = TodoAppCubit.get(context).archiveTasks;
        return TasksBuilder(tasks: tasks, isDone: false);
      },
    );
  }
}
