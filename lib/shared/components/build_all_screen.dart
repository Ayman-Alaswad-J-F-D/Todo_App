import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/styles/colors.dart';

import '../../widgets/confirm_dialog.dart';
import 'background_header.dart';

class BuildViewAllTasks extends StatelessWidget {
  const BuildViewAllTasks({
    Key? key,
    required this.headerLabel,
    required this.phraseLabel,
    required this.sortClick,
    required this.deleteClick,
    required this.listViewItem,
  }) : super(key: key);

  final String headerLabel;
  final String phraseLabel;
  final VoidCallback sortClick;
  final VoidCallback deleteClick;
  final Widget listViewItem;

  @override
  Widget build(BuildContext context) {
    final cubit = TodoAppCubit.get(context);
    return Scaffold(
      backgroundColor: AppColors.secandry,
      body: Column(
        children: [
          Expanded(
            child: BackgroundHeader(
              positionedTop: 15,
              headerLabel: headerLabel,
              leadingIcon: Icons.arrow_back_ios_new_rounded,
              leadingClick: () => Navigator.pop(context),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (cubit.archiveTasks.isNotEmpty ||
                    cubit.doneTasks.isNotEmpty ||
                    cubit.newTasks.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4.0,
                      left: 12.0,
                      right: 6.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PhraseLabel(titleBody: phraseLabel),
                        DeleteButton(deleteClick: deleteClick),
                        SortButton(sortClick: sortClick),
                      ],
                    ),
                  ),

                //* The Tasks List
                Expanded(child: listViewItem),
                //*
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PhraseLabel extends StatelessWidget {
  const PhraseLabel({
    Key? key,
    required this.titleBody,
  }) : super(key: key);

  final String titleBody;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: RichText(
        text: TextSpan(
          text: 'Todo :  ',
          style: TextStyle(
            fontSize: 17.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(
              text: titleBody.characters
                  .getRange(0, titleBody.length - 2)
                  .toString(),
              style: TextStyle(
                color: AppColors.primaryAccent,
                fontSize: 18.sp,
                wordSpacing: 1,
                letterSpacing: 1,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal,
                decoration: TextDecoration.underline,
                decorationStyle: TextDecorationStyle.dotted,
                decorationThickness: 2,
              ),
            ),
            TextSpan(text: '  ${titleBody.characters.last}'),
          ],
        ),
      ),
    );
  }
}

class SortButton extends StatelessWidget {
  const SortButton({
    Key? key,
    required this.sortClick,
  }) : super(key: key);

  final VoidCallback sortClick;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Transform.flip(
        flipX: true,
        child: IconButton(
          icon: const Icon(Icons.format_line_spacing_rounded),
          onPressed: sortClick,
          color: AppColors.primary,
          tooltip: 'Sort Tasks',
        ),
      ),
    );
  }
}

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    Key? key,
    required this.deleteClick,
  }) : super(key: key);

  final VoidCallback deleteClick;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => confirmDialog(
          context: context,
          titleDialog: "Delete Confirmation",
          questionDialog: "Are you sure you want to delete all this tasks ?",
          labelButton: "Delete All",
          color: AppColors.red,
        ).then((isDeleted) {
          if (isDeleted) return deleteClick();
        }),
        color: AppColors.red,
        iconSize: 22,
        tooltip: 'Delete All Tasks',
      ),
    );
  }
}
