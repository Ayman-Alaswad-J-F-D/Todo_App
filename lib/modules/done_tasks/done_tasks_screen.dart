import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/build_all_screen.dart';
import 'package:todo_app/widgets/list_view_animation.dart';

import '../../app/global/global.dart';
import '../../shared/components/build_task_item.dart';
import '../../shared/cubit/cubit.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/fall_back_widget.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = TodoAppCubit.get(context);
    return BuildViewAllTasks(
      headerLabel: 'All Completed Tasks',
      phraseLabel: 'You Did It🔥',
      sortClick: () => cubit.sortDoneTasks(),
      deleteClick: () =>
          cubit.deleteAllTasksWhereStatus(status: Global.isDoneTask),
      listViewItem: BlocBuilder<TodoAppCubit, TodoAppStates>(
        buildWhen: (previous, current) =>
            current is CreateDatabaseState ||
            current is UpdateDatabaseState ||
            current is DeleteDatabaseState ||
            current is SortingListState,
        builder: (context, state) {
          final listDoneTasks = cubit.doneTasks;

          return ConditionalBuilder(
            condition:
                state is! IsEmptyDatebaseState && listDoneTasks.isNotEmpty,
            builder: (context) => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: listDoneTasks.length,
              itemBuilder: (context, index) => ListViewAnimation(
                index: index,
                child: BuildTaskItem(data: listDoneTasks[index], isDone: true),
              ),
              separatorBuilder: (context, index) => CustomDivider(index: index),
            ),
            fallback: (context) => const FallBackWidget(isDone: true),
          );
        },
      ),
    );
  }
}
