import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/tasks_builder.dart';
import '../../shared/cubit/cubit.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoAppCubit, TodoAppStates>(
      builder: (context, state) {
        var tasks = TodoAppCubit.get(context).doneTasks;
        return TasksBuilder(tasks: tasks, isArchive: false);
      },
    );
  }
}
