import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/build_all_screen.dart';
import 'package:todo_app/widgets/list_view_animation.dart';

import '../../shared/components/build_task_item.dart';
import '../../shared/cubit/cubit.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/fall_back_widget.dart';

class ArchiveTasksScreen extends StatelessWidget {
  const ArchiveTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = TodoAppCubit.get(context);
    return BuildViewAllTasks(
      headerLabel: 'Archive Tasks',
      phraseLabel: 'Keep Going🙏',
      sortClick: () => cubit.sortArchiveTasks(),
      deleteClick: () => cubit.deleteAllTasksWhereStatus(isArchive: true),
      listViewItem: BlocBuilder<TodoAppCubit, TodoAppStates>(
        buildWhen: (previous, current) =>
            current is CreateDatabaseState ||
            current is UpdateDatabaseState ||
            current is DeleteDatabaseState ||
            current is SortingListState,
        builder: (context, state) {
          final listArchiveTasks = cubit.archiveTasks;

          return ConditionalBuilder(
            condition:
                state is! IsEmptyDatebaseState && listArchiveTasks.isNotEmpty,
            builder: (context) => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: listArchiveTasks.length,
              itemBuilder: (context, index) => ListViewAnimation(
                index: index,
                child: BuildTaskItem(data: listArchiveTasks[index]),
              ),
              separatorBuilder: (context, index) => CustomDivider(index: index),
            ),
            fallback: (context) => const FallBackWidget(),
          );
        },
      ),
    );
  }
}
