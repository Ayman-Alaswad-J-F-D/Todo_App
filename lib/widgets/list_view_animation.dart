import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../shared/constants/constants.dart';

class ListViewAnimation extends StatelessWidget {
  const ListViewAnimation({
    Key? key,
    required this.index,
    this.delay = 100,
    this.slideDuration = 600,
    this.horizontalOffset,
    this.verticalOffset = true,
    required this.child,
  }) : super(key: key);

  final bool verticalOffset;
  final int index;
  final int delay;
  final int slideDuration;
  final double? horizontalOffset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: Duration(milliseconds: delay),
      child: SlideAnimation(
        duration: Duration(milliseconds: slideDuration),
        curve: Curves.fastLinearToSlowEaseIn,
        horizontalOffset:
            !verticalOffset ? horizontalOffset ?? widthScreen(context) : null,
        verticalOffset: verticalOffset ? 600.0 : null,
        child: child,
      ),
    );
  }
}
