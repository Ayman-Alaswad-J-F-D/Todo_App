// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:todo_app/model/task_model.dart';

import 'package:todo_app/modules/details_screen/details_screen.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/widgets/label_widget.dart';
import 'package:todo_app/widgets/show_toast_short.dart';

import '../../widgets/task_widget.dart';
import '../cubit/cubit.dart';
import '../styles/colors.dart';

class BuildTaskItem extends StatelessWidget {
  const BuildTaskItem({
    Key? key,
    required this.data,
    required this.index,
    this.isDone = false,
    this.isArchive = false,
  }) : super(key: key);

  final TaskModel data;
  final int index;
  final bool isDone;
  final bool isArchive;

  @override
  Widget build(BuildContext context) {
    final cubit = TodoAppCubit.get(context);

    return GestureDetector(
      onTap: () => context.toScreen(
        screen: DetailsScreen(model: data, index: index),
      ),
      child: Dismissible(
        // key: Key(index.toString()),
        key: UniqueKey(),
        background: backDelete(MainAxisAlignment.start),
        secondaryBackground: data.status == 'archive'
            ? backDelete(MainAxisAlignment.end)
            : backArchive(),

        onDismissed: (DismissDirection direction) =>
            onDismissedImpl(direction, cubit),

        confirmDismiss: (DismissDirection direction) async =>
            await confirmDismissImpl(direction, context),

        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TaskWidget(
                    taskTitle: data.title,
                    taskTime: data.time,
                    image: data.image,
                    opacity: isDone ? .4 : 1,
                    checkBoxValue: data.status == 'new' ? false : true,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    onChange: (isCheck) {
                      if (isCheck!) {
                        cubit.updateStatus(id: data.id, status: 'done');
                        showToastShort(
                          text: 'Done',
                          state: ToastStates.Done,
                          context: context,
                          padLeft: widthScreen(context) / 2.5,
                          padRight: widthScreen(context) / 2.5,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> confirmDismissImpl(
    DismissDirection direction,
    BuildContext context,
  ) async {
    if (direction == DismissDirection.startToEnd) {
      return await confirmDelete(context);
    } else {
      if (data.status == 'archive') {
        return await confirmDelete(context);
      } else {
        return await confirmArchive(context);
      }
    }
  }

  void onDismissedImpl(DismissDirection direction, TodoAppCubit cubit) {
    if (direction == DismissDirection.endToStart) {
      if (data.status == 'archive') {
        cubit.deleteTask(id: data.id);
      } else {
        cubit.updateStatus(status: 'archive', id: data.id);
      }
    } else {
      cubit.deleteTask(id: data.id);
    }
  }
}

Widget backDismissible({
  required MainAxisAlignment mainAxisAlignment,
  required Color color,
  required IconData icon,
  required String label,
  bool reverse = false,
}) {
  return Container(
    color: color,
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        if (!reverse) Icon(icon, color: AppColors.white),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: LabelWidget(
            title: label,
            color: AppColors.white,
            fontWeight: FontWeight.normal,
            fontSize: 15,
          ),
        ),
        if (reverse) Icon(icon, color: AppColors.white),
      ],
    ),
  );
}

Widget confirmDialog({
  required BuildContext context,
  required String titleDialog,
  required String questionDialog,
  required String labelButton,
  required Color color,
}) {
  return AlertDialog(
    title: LabelWidget(title: titleDialog, color: color),
    content: SizedBox(
      width: widthScreen(context) / 1.2,
      child: LabelWidget(
        title: questionDialog,
        color: AppColors.greyS600,
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
    ),
    actions: [
      FlatButton(
        child: const LabelWidget(
          title: 'Cancel',
          fontWeight: FontWeight.normal,
        ),
        onPressed: () => Navigator.of(context).pop(false),
      ),
      FlatButton(
        child: LabelWidget(title: labelButton, color: color),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    ],
  );
}

Future confirmDelete(context) => showDialog(
      context: context,
      builder: (context) => confirmDialog(
        context: context,
        titleDialog: 'Delete Confirmation',
        questionDialog: 'Are you sure you want to delete this task ?',
        labelButton: 'DELETE',
        color: AppColors.red,
      ),
    );

Future confirmArchive(context) => showDialog(
      context: context,
      builder: (context) => confirmDialog(
        context: context,
        titleDialog: 'Archive Confirmation',
        questionDialog: 'Are you want to Add this task to archive ?',
        labelButton: 'ADD',
        color: AppColors.primary.shade400,
      ),
    );

Widget backDelete(MainAxisAlignment mainAxisAlignment) => backDismissible(
      label: 'Move To Trash',
      mainAxisAlignment: mainAxisAlignment,
      icon: Icons.delete,
      color: AppColors.red,
    );

Widget backArchive() => backDismissible(
      label: 'Move To Archive',
      mainAxisAlignment: MainAxisAlignment.end,
      icon: Icons.archive_rounded,
      color: AppColors.greyS400,
      reverse: true,
    );
