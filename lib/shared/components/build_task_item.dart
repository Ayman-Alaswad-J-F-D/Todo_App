// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';
import '../styles/colors.dart';
import 'image_widget.dart';
import 'info_task.dart';

class BuildTaskItem extends StatelessWidget {
  const BuildTaskItem({
    Key? key,
    this.isDone,
    this.isArchive,
    required this.model,
  }) : super(key: key);

  final Map model;
  final bool? isDone, isArchive;

  @override
  Widget build(BuildContext context) {
    var cubit = TodoAppCubit.get(context);

    return Dismissible(
      key: Key(model['id'].toString()),
      background: backTrash(mainAxisAlignment: MainAxisAlignment.start),
      secondaryBackground: backTrash(mainAxisAlignment: MainAxisAlignment.end),
      onDismissed: (direction) => cubit.deleteTask(id: model['id']),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (context) => confirmDialog(context),
        );
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20,
          bottom: 20,
          top: 20,
          end: 10,
        ),
        child: Row(
          children: [
            ImageWidget(model: model),
            const SizedBox(width: 18.0),
            InfoTask(model: model),
            const SizedBox(width: 6),
            const SizedBox(
              height: 20,
              width: 5,
              child: VerticalDivider(color: AppColors.grey, thickness: 0.2),
            ),
            isArchive!
                ? IconButton(
                    splashColor: AppColors.deebOrangeS200,
                    icon: Icon(
                      Icons.check_box_rounded,
                      color: AppColors.deebOrangeS300,
                    ),
                    onPressed: () =>
                        cubit.updateStatus(status: 'done', id: model['id']),
                  )
                : const SizedBox(),
            isDone!
                ? IconButton(
                    splashColor: AppColors.greyS200,
                    icon: const Icon(
                      Icons.archive_rounded,
                      color: AppColors.black38,
                    ),
                    onPressed: () =>
                        cubit.updateStatus(status: 'archive', id: model['id']),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

Widget backTrash({mainAxisAlignment}) {
  return Container(
    color: AppColors.red,
    child: Padding(
      padding: const EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: const [
          Icon(Icons.delete, color: AppColors.white),
          Text('Move to trash', style: TextStyle(color: AppColors.white)),
        ],
      ),
    ),
  );
}

Widget confirmDialog(BuildContext context) {
  return AlertDialog(
    title: const Text(
      "Delete Confirmation",
      style: TextStyle(color: AppColors.red),
    ),
    content: SizedBox(
      width: MediaQuery.of(context).size.width / 1.3,
      child: Text(
        "Are you sure you want to delete this task ?",
        style: TextStyle(color: AppColors.greyS600),
      ),
    ),
    actions: [
      FlatButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text("Cancel"),
      ),
      FlatButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text(
          "Delete",
          style: TextStyle(color: AppColors.red),
        ),
      ),
    ],
  );
}
