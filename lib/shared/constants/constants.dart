import 'package:flutter/material.dart';

const String assets = 'assets';
const String imagePath = 'assets/svg';

class Constants {
  const Constants._();

  static const String categoryEventIcon = '$imagePath/category_event.svg';
  static const String categoryGoalIcon = '$imagePath/category_goal.svg';
  static const String categoryTaskIcon = '$imagePath/category_task.svg';

  static const List<String> listSvgIcons = [
    categoryTaskIcon,
    categoryGoalIcon,
    categoryEventIcon,
  ];
}

double heightScreen(context) => MediaQuery.of(context).size.height;
double widthScreen(context) => MediaQuery.of(context).size.width;
