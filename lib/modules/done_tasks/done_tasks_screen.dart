import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/shared/components/build_all_screen.dart';
import 'package:todo_app/widgets/list_view_animation.dart';

import '../../shared/components/build_task_item.dart';
import '../../shared/cubit/cubit.dart';
import '../../widgets/custom_divider.dart';
import '../../widgets/fall_back_widget.dart';

class DoneTasksScreen extends StatelessWidget {
  const DoneTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildViewAllTasks(
      headerLabel: 'All Done Tasks',
      phraseLabel: 'You Did It🔥',
      listViewItem: BlocBuilder<TodoAppCubit, TodoAppStates>(
        builder: (context, state) {
          final listDone = TodoAppCubit.get(context).doneTasks;

          return ConditionalBuilder(
            condition: state is! IsEmptyDatebaseState && listDone.isNotEmpty,
            builder: (context) => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: listDone.length,
              itemBuilder: (context, index) => ListViewAnimation(
                index: index,
                child: BuildTaskItem(
                  data: listDone[index],
                  isDone: true,
                  index: index,
                ),
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
