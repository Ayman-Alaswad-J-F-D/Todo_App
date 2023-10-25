import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/build_all_screen.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/widgets/fall_back_widget.dart';
import 'package:todo_app/widgets/list_view_animation.dart';

import '../../shared/components/build_task_item.dart';
import '../../shared/cubit/cubit.dart';
import '../../widgets/custom_divider.dart';

class AllTasksScreen extends StatelessWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BuildViewAllTasks(
      headerLabel: 'All Tasks',
      phraseLabel: 'Don\'t Give Up🤩',
      listViewItem: BlocBuilder<TodoAppCubit, TodoAppStates>(
        builder: (context, state) {
          final listNew = TodoAppCubit.get(context).newTasks;

          return ConditionalBuilder(
            condition: state is! IsEmptyDatebaseState && listNew.isNotEmpty,
            builder: (context) => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: listNew.length,
              itemBuilder: (context, index) => ListViewAnimation(
                index: index,
                horizontalOffset: widthScreen(context),
                child: BuildTaskItem(data: listNew[index], index: index),
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
