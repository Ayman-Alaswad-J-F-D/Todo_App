import 'package:flutter/material.dart';

const String assets = 'assets';
const String imagePath = 'assets/svg';

class Constants {
  const Constants._();

  static const String appIcon = '$assets/app_icon/icon.png';
  static const String splashIcon = '$assets/splash_icon.png';

  static const String categoryEvent = '$imagePath/categoryEvent.svg';
  static const String categoryGoal = '$imagePath/categoryGoal.svg';
  static const String categoryTask = '$imagePath/categoryTask.svg';

  static const List<String> listSvgIcons = [
    categoryTask,
    categoryGoal,
    categoryEvent,
  ];

  static const List<String> assetsImage = [
    '$assets/eat_image.png',
    '$assets/play_image.png',
    '$assets/watching_image.png',
    '$assets/sport_image.png',
    '$assets/code_image.png',
    '$assets/driving_image.png',
    '$assets/tool-image.png',
    '$assets/pencil_image.png',
    '$assets/work_image.png',
    '$assets/plane_image.png',
  ];
}

double heightScreen(context) => MediaQuery.of(context).size.height;
double widthScreen(context) => MediaQuery.of(context).size.width;
