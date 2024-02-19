import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/components/build_all_screen.dart';
import 'package:todo_app/widgets/fall_back_widget.dart';
import 'package:todo_app/widgets/list_view_animation.dart';

import '../../app/global/global.dart';
import '../../shared/components/build_task_item.dart';
import '../../shared/cubit/cubit.dart';
import '../../widgets/custom_divider.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  late TodoAppCubit cubit;

  @override
  void initState() {
    _setup();
    super.initState();
  }

  void _setup() {
    cubit = TodoAppCubit.get(context);
    cubit.cancelGroupNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return BuildViewAllTasks(
      headerLabel: 'All New Tasks',
      phraseLabel: 'Don\'t Give Up🤩',
      sortClick: () => cubit.sortNewTasks(),
      deleteClick: () =>
          cubit.deleteAllTasksWhereStatus(status: Global.isNewTask),
      listViewItem: BlocBuilder<TodoAppCubit, TodoAppStates>(
        buildWhen: (_, current) =>
            current is GetDatabaseState ||
            current is UpdateDatabaseState ||
            current is DeleteDatabaseState ||
            current is SortingListState,
        builder: (context, state) {
          final listNewTasks = cubit.newTasks;

          return ConditionalBuilder(
            condition:
                state is! IsEmptyDatebaseState && listNewTasks.isNotEmpty,
            builder: (context) => ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: listNewTasks.length,
              itemBuilder: (context, index) => ListViewAnimation(
                index: index,
                child: BuildTaskItem(data: listNewTasks[index]),
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
