import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:todo_app/shared/components/tasks_list_builder.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/widgets/fall_back_widget.dart';
import 'package:todo_app/widgets/label_widget.dart';

import '../../shared/styles/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/header.dart';
import '../add_task_screen/add_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secandry,
      body: Stack(
        children: [
          Column(
            children: const [
              Expanded(flex: 2, child: Header()),
              Expanded(flex: 3, child: SizedBox()),
            ],
          ),
          Positioned(
            top: heightScreen(context) / 4.5,
            right: 15,
            left: 15,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomContainer(
                  height: heightScreen(context) * .32,
                  child: BlocBuilder<TodoAppCubit, TodoAppStates>(
                    builder: (context, state) {
                      final newTasks = TodoAppCubit.get(context).newTasks;
                      return ConditionalBuilder(
                        condition: state is! IsEmptyDatebaseState &&
                            newTasks.isNotEmpty,
                        builder: (context) => TasksListBuilder(tasks: newTasks),
                        fallback: (context) => const FallBackWidget(),
                      );
                    },
                  ),
                ),
                const LabelWidget(title: 'Completed', pB: 14, pT: 14),
                CustomContainer(
                  height: heightScreen(context) * .23,
                  child: BlocBuilder<TodoAppCubit, TodoAppStates>(
                    builder: (context, state) {
                      final doneTasks = TodoAppCubit.get(context).doneTasks;
                      return ConditionalBuilder(
                        condition: state is! IsEmptyDatebaseState &&
                            doneTasks.isNotEmpty,
                        builder: (context) =>
                            TasksListBuilder(tasks: doneTasks, isDone: true),
                        fallback: (context) =>
                            const FallBackWidget(isDone: true),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<TodoAppCubit, TodoAppStates>(
            builder: (context, state) {
              final list = TodoAppCubit.get(context);
              if (list.doneTasks.isNotEmpty || list.newTasks.isNotEmpty) {
                return Positioned(
                  bottom: heightScreen(context) * .11,
                  right: 0,
                  left: 0,
                  child: LabelWidget(
                    title: 'Swap To Rigth To Delete or Swap To Left To Archive',
                    spacing: .5,
                    fontSize: 10,
                    color: AppColors.primary.shade400,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
      bottomSheet: CustomButton(
        text: 'Add New Task',
        click: () => context.toScreenAnimation(screen: const AddTaskScreen()),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({
    Key? key,
    required this.height,
    required this.child,
  }) : super(key: key);

  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widthScreen(context),
      height: height,
      duration: const Duration(seconds: 1),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: AppColors.black12,
            blurRadius: 3,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}
