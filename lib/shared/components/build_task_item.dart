import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/app/global/global.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/modules/details_screen/details_screen.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/widgets/show_toast_short.dart';

import '../../widgets/confirm_dialog.dart';
import '../../widgets/task_widget.dart';
import '../cubit/cubit.dart';
import '../styles/colors.dart';

class BuildTaskItem extends StatelessWidget {
  const BuildTaskItem({
    Key? key,
    required this.data,
    this.isDone = false,
  }) : super(key: key);

  final TaskModel data;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final cubit = TodoAppCubit.get(context);

    return SlidableAutoCloseBehavior(
      child: GestureDetector(
        onTap: () => context.toScreen(
          screen: DetailsScreen(taskId: data.id),
        ),
        child: Slidable(
          key: Key(data.id.toString()),
          startActionPane: ActionPane(
            motion: const DrawerMotion(),
            extentRatio: isDone ? 0.5 : 0.3,
            children: [
              if (data.isArchive)
                DeleteAction(taskId: data.id)
              else
                ArchiveAction(taskId: data.id),
              if (isDone) UndoAction(taskId: data.id),
            ],
          ),
          endActionPane: ActionPane(
            extentRatio: 0.3,
            motion: const BehindMotion(),
            children: [DeleteAction(taskId: data.id)],
          ),
          child: TaskWidget(
            taskTitle: data.title,
            taskTime: data.time,
            image: data.image,
            isDoneTask: isDone,
            checkBoxValue: data.status == Global.isDoneTask,
            onChange: (isCheck) {
              if (isCheck!) {
                cubit.updateStatus(id: data.id, status: Global.isDoneTask);
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
      ),
    );
  }
}

class UndoAction extends StatelessWidget {
  const UndoAction({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  final int taskId;
  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      label: 'Undo',
      padding: EdgeInsets.zero,
      icon: CupertinoIcons.arrow_uturn_right_circle_fill,
      backgroundColor: AppColors.primary.shade400,
      onPressed: (ctx) => _dismissible(ctx, Actions.undo, taskId),
    );
  }
}

class DeleteAction extends StatelessWidget {
  const DeleteAction({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  final int taskId;
  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      label: 'Delete',
      padding: EdgeInsets.zero,
      icon: CupertinoIcons.delete_solid,
      backgroundColor: AppColors.red,
      onPressed: (ctx) => _dismissible(ctx, Actions.delete, taskId),
    );
  }
}

class ArchiveAction extends StatelessWidget {
  const ArchiveAction({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  final int taskId;
  @override
  Widget build(BuildContext context) {
    return SlidableAction(
      label: 'Archive',
      padding: EdgeInsets.zero,
      icon: Icons.archive_rounded,
      foregroundColor: AppColors.grey,
      backgroundColor: AppColors.greyS200,
      onPressed: (ctx) => _dismissible(ctx, Actions.archive, taskId),
    );
  }
}

enum Actions { undo, delete, archive }

Future<void> _dismissible(
  BuildContext context,
  Actions action,
  int taskId,
) async {
  final cubit = TodoAppCubit.get(context);
  switch (action) {
    case Actions.undo:
      cubit.updateStatus(status: Global.isNewTask, id: taskId);
      return showToastShort(
        text: 'Undo Task',
        context: context,
        state: ToastStates.WARNING,
      );
    case Actions.delete:
      return _confirmDialogDelete(context).then(
        (isConfirm) {
          if (!isConfirm) return;
          cubit.deleteTask(id: taskId);
        },
      );
    case Actions.archive:
      return _confirmDialogArchive(context).then(
        (isConfirm) {
          if (!isConfirm) return;
          cubit.updateToArchive(isArchive: true, id: taskId);
        },
      );
  }
}

//* Style Confirm Dialog Method
Future _confirmDialogDelete(context) => confirmDialog(
      context: context,
      titleDialog: 'Delete Confirmation',
      questionDialog: 'Are you sure you want to delete this task ?',
      labelButton: 'DELETE',
      color: AppColors.red,
    );

Future _confirmDialogArchive(context) => confirmDialog(
      context: context,
      titleDialog: 'Archive Confirmation',
      questionDialog: 'Are you want to Add this task to archive ?',
      labelButton: 'ADD',
      color: AppColors.greyS600,
    );
