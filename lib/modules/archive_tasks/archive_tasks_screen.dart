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
    return BuildViewAllTasks(
      headerLabel: 'Archive Tasks',
      phraseLabel: 'Keep Going🙏',
      listViewItem: BlocBuilder<TodoAppCubit, TodoAppStates>(
        builder: (context, state) {
          final listArchive = TodoAppCubit.get(context).archiveTasks;

          return ConditionalBuilder(
            condition: state is! IsEmptyDatebaseState && listArchive.isNotEmpty,
            builder: (context) => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: listArchive.length,
              itemBuilder: (context, index) => ListViewAnimation(
                index: index,
                child: BuildTaskItem(data: listArchive[index], index: index),
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
