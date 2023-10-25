import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/shared/components/background_header.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/widgets/label_widget.dart';

import '../../shared/function/check_image.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({
    Key? key,
    required this.model,
    required this.index,
  }) : super(key: key);

  final TaskModel model;
  final int index;

  Color _containerColor() {
    switch (model.image) {
      case Constants.categoryEvent:
        return AppColors.purpleOpa;

      case Constants.categoryGoal:
        return AppColors.amberOpa;

      default:
        return AppColors.blueOpa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secandry,
      body: Column(
        children: [
          Expanded(
            child: BackgroundHeader(
              headerLabel: 'Details Task',
              leadingIcon: Icons.arrow_back_ios_new_rounded,
              leadingClick: () => context.backScreen(),
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 18),
                          child: SizedBox(
                            child: checkImage(
                              image: model.image,
                              width: widthScreen(context) / 3.8,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                            padding: EdgeInsets.all(15.0.w),
                            decoration: BoxDecoration(
                              color: _containerColor(),
                              shape: BoxShape.circle,
                            ),
                            child: LabelWidget(
                              title: '${index + 1}',
                              color: AppColors.primary,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    LabelWidget(
                      title: model.title,
                      color: AppColors.primary,
                      textAlign: TextAlign.center,
                      fontSize: 22,
                      pT: 18,
                      pB: 18,
                    ),
                    CardWidget(
                      title: 'Note :',
                      info: model.note,
                      width: widthScreen(context),
                      color: _containerColor(),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardWidget(
                          title: 'Date :',
                          info: model.date,
                          color: _containerColor(),
                        ),
                        CardWidget(
                          title: 'Time :',
                          info: model.time,
                          color: _containerColor(),
                        ),
                      ],
                    ),
                    CardWidget(
                      title: 'Status :',
                      info: '${model.status.toUpperCase()}  Task',
                      fontSize: 17,
                      color: _containerColor(),
                      width: widthScreen(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({
    Key? key,
    required this.title,
    required this.info,
    required this.color,
    this.conter = true,
    this.width,
    this.fontColor = AppColors.black,
    this.fontSize = 16,
  }) : super(key: key);

  final String title;
  final String info;
  final Color color;
  final bool conter;
  final double? width;
  final Color fontColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Stack(
        children: [
          Container(
            // width: widthScreen(context),
            constraints: BoxConstraints(
              minWidth: width ?? widthScreen(context) / 2.3,
            ),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
            ),
            child: LabelWidget(
              title: info.isEmpty ? 'Not Found Note !' : info,
              fontWeight: FontWeight.normal,
              textAlign: conter ? TextAlign.center : TextAlign.start,
              color: fontColor,
              fontSize: fontSize,
              pT: 36,
              pB: 12,
            ),
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(8),
            child: LabelWidget(
              title: " $title  ",
              color: AppColors.white,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(6),
                bottomLeft: Radius.circular(6),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
