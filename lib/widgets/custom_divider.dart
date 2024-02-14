import 'package:flutter/material.dart';
import 'package:todo_app/shared/styles/colors.dart';
import 'package:todo_app/widgets/list_view_animation.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key? key,
    required this.index,
    this.delayAnimation = 100,
    this.verticalOffsetAnimation = true,
  }) : super(key: key);

  final int index;
  final int delayAnimation;
  final bool verticalOffsetAnimation;

  @override
  Widget build(BuildContext context) {
    return ListViewAnimation(
      index: index,
      delay: delayAnimation,
      verticalOffset: verticalOffsetAnimation,
      child: Divider(
        height: 0,
        thickness: 0.8,
        color: AppColors.purpleOpa,
      ),
    );
  }
}
