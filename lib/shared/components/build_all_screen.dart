import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import 'package:todo_app/shared/styles/colors.dart';

import 'background_header.dart';

class BuildViewAllTasks extends StatelessWidget {
  const BuildViewAllTasks({
    Key? key,
    required this.headerLabel,
    required this.phraseLabel,
    required this.listViewItem,
  }) : super(key: key);

  final String headerLabel;
  final String phraseLabel;
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
                  PhraseLabel(titleBody: phraseLabel),

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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
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
