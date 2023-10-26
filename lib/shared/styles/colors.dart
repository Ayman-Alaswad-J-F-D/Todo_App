import 'package:flutter/material.dart';

class AppColors {
  static const Color secandry = Color.fromARGB(255, 222, 243, 254);
  static const Color sec = Color(0xffDBECF6);
  static const Color borderColor = Color(0xffE0E0E0);

  // static Color blueOpa = const Color(0xffDBECF6);
  static Color blueOpa = const Color(0xffC7DBE7);
  static Color amberOpa = const Color(0xffFEF5D3);
  static Color purpleOpa = const Color(0xffE7E2F3);

  static const Color white = Colors.white;
  static const Color black = Color(0xff1B1B1D);
  static const Color black12 = Colors.black12;
  static const Color black38 = Colors.black38;
  static const Color black45 = Colors.black45;
  static const Color blueGrey = Colors.blueGrey;
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static Color deepOrangeS300 = Colors.deepOrange.shade300;

  static const Color grey = Colors.grey;
  static final Color greyS100 = Colors.grey.shade100;
  static final Color greyS200 = Colors.grey.shade200;
  static final Color greyS400 = Colors.grey.shade400;
  static final Color greyS600 = Colors.grey.shade600;

  // static const Color primary = Color(0xff4A3780);
  static const MaterialColor primary =
      MaterialColor(_ff4a3780PrimaryValue, <int, Color>{
    50: Color(0xFFE9E7F0),
    100: Color(0xFFC9C3D9),
    200: Color(0xFFA59BC0),
    300: Color(0xFF8073A6),
    400: Color(0xFF655593),
    500: Color(_ff4a3780PrimaryValue),
    600: Color(0xFF433178),
    700: Color(0xFF3A2A6D),
    800: Color(0xFF322363),
    900: Color(0xFF221650),
  });
  static const int _ff4a3780PrimaryValue = 0xFF4A3780;

  static const MaterialColor primaryAccent =
      MaterialColor(_ff4a3780AccentValue, <int, Color>{
    100: Color(0xFFA28CFF),
    200: Color(_ff4a3780AccentValue),
    400: Color(0xFF4F26FF),
    700: Color(0xFF3A0DFF),
  });
  static const int _ff4a3780AccentValue = 0xFF7959FF;
}
