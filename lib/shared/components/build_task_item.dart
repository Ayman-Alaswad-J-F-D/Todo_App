// ignore_for_file: deprecated_member_use, file_names
import 'package:flutter/material.dart';

import '../cubit/cubit.dart';
import '../styles/colors.dart';
import 'constants.dart';

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
      onDismissed: (direction) => cubit.deleteData(id: model['id']),
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
            Stack(
              alignment: Alignment.topRight,
              children: [
                CircleAvatar(
                  radius: 37.0,
                  child: model['image'] != '' ? null : Text('${model['time']}'),
                  backgroundImage:
                      model['image'] != '' ? AssetImage(model['image']) : null,
                ),
                CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.deebOrangeS300,
                  child: IconButton(
                    padding: const EdgeInsets.all(0),
                    icon: const Icon(
                      Icons.edit_sharp,
                      color: AppColors.white,
                      size: 11,
                    ),
                    onPressed: () => showDialog(
                      context: context,
                      builder: (context) =>
                          selectImageToTask(context: context, model: model),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(width: 18.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${model['date']}',
                    style: const TextStyle(color: AppColors.grey),
                  ),
                  Text(
                    model['image'] != '' ? '${model['time']}' : '',
                    style: const TextStyle(color: AppColors.grey),
                  ),
                ],
              ),
            ),
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
    content: Text(
      "Are you sure you want to delete this task ?",
      style: TextStyle(color: AppColors.greyS600),
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

Widget selectImageToTask({context, model}) {
  return AlertDialog(
    title: Text(
      "Select Icon :",
      style: TextStyle(color: AppColors.deebOrangeS300),
    ),
    content: SizedBox(
      height: 160,
      child: GridView.builder(
        itemCount: assetsImage.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        itemBuilder: (context, index) => circleImage(
          id: model['id'],
          context: context,
          image: assetsImage[index],
        ),
      ),
    ),
  );
}

Widget circleImage({required context, required id, required image}) => InkWell(
      child: CircleAvatar(backgroundImage: AssetImage(image), minRadius: 25),
      onTap: () {
        TodoAppCubit.get(context).updateImage(image: image, id: id);
        Navigator.pop(context);
      },
    );
