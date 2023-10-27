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
        secondaryBackground:
            data.isArchive ? backDelete(MainAxisAlignment.end) : backArchive(),

        onDismissed: (DismissDirection direction) =>
            onDismissedImpl(direction, cubit),

        confirmDismiss: (DismissDirection direction) async =>
            await confirmDismissImpl(direction, context),

        child: TaskWidget(
          taskTitle: data.title,
          taskTime: data.time,
          image: data.image,
          opacity: isDone ? .4 : 1,
          checkBoxValue: data.status == 'done',
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
    );
  }

//* Confirm & Dismissed Method
  Future<bool?> confirmDismissImpl(DismissDirection direction, context) async {
    if (direction == DismissDirection.endToStart && !data.isArchive) {
      return await confirmDialogArchive(context);
    } else {
      return await confirmDialogDelete(context);
    }
  }

  void onDismissedImpl(DismissDirection direction, TodoAppCubit cubit) {
    if (direction == DismissDirection.endToStart && !data.isArchive) {
      cubit.updateArchive(isArchive: true, id: data.id);
    } else {
      cubit.deleteTask(id: data.id);
    }
  }
}

//* Style Confirm Dialog Method
Future confirmDialogDelete(context) => confirmDialog(
      context: context,
      titleDialog: 'Delete Confirmation',
      questionDialog: 'Are you sure you want to delete this task ?',
      labelButton: 'DELETE',
      color: AppColors.red,
    );

Future confirmDialogArchive(context) => confirmDialog(
      context: context,
      titleDialog: 'Archive Confirmation',
      questionDialog: 'Are you want to Add this task to archive ?',
      labelButton: 'ADD',
      color: AppColors.primary.shade400,
    );

Future confirmDialog({
  required BuildContext context,
  required String titleDialog,
  required String questionDialog,
  required String labelButton,
  required Color color,
}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
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
    ),
  );
}

//* Style Background Dismissible Widget
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
