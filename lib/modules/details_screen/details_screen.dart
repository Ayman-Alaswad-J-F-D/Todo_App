import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/model/task_model.dart';
import 'package:todo_app/shared/components/background_header.dart';
import 'package:todo_app/shared/constants/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/widgets/label_widget.dart';

import '../../shared/function/check_image.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  final int taskId;

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TaskModel task;
  late TodoAppCubit cubit;

  @override
  void initState() {
    _setup();
    super.initState();
  }

  void _setup() {
    cubit = TodoAppCubit.get(context);
    task = cubit.getTaskById(widget.taskId);
    cubit.cancelNotification(task.id, task.title);
  }

  Color _containerColor(TaskModel task) {
    switch (task.image) {
      case Constants.categoryEventIcon:
        return AppColors.purpleOpa;

      case Constants.categoryGoalIcon:
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
              positionedTop: 15,
              leadingIcon: Icons.arrow_back_ios_new_rounded,
              leadingClick: () => context.backScreen(),
            ),
          ),
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: SizedBox(
                            child: checkImage(
                              context,
                              image: task.image,
                              width: widthScreen(context) / 3.8,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                            padding: EdgeInsets.all(12.0.w),
                            decoration: BoxDecoration(
                              color: _containerColor(task),
                              shape: BoxShape.circle,
                            ),
                            child: LabelWidget(
                              title: '${task.id}',
                              color: AppColors.primary,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    LabelWidget(
                      title: task.title,
                      color: AppColors.primary,
                      textAlign: TextAlign.center,
                      fontSize: 22,
                      pT: 16,
                      pB: 16,
                    ),
                    CardWidget(
                      title: 'Note :',
                      info: task.note,
                      width: widthScreen(context),
                      color: _containerColor(task),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CardWidget(
                          title: 'Date :',
                          info: task.date,
                          color: _containerColor(task),
                        ),
                        CardWidget(
                          title: 'Time :',
                          info: task.time,
                          color: _containerColor(task),
                        ),
                      ],
                    ),
                    CardWidget(
                      title: 'Status :',
                      info: '${task.status.toUpperCase()}  Task',
                      fontSize: 17,
                      color: _containerColor(task),
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
