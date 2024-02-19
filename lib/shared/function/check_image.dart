import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget checkImage(context, {required String image, double width = 42}) {
  return image.split('.').last == 'svg'
      ? SvgPicture.asset(image, width: width.w)
      : _circleImage(context, image, width);
}

Widget _circleImage(BuildContext context, String image, double width) {
  final bytes = base64Decode(image);
  return CircleAvatar(
    radius: (width / 2).r,
    child: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.memory(
        bytes,
        height: 150.h,
        fit: BoxFit.cover,
        cacheHeight: (150 * MediaQuery.of(context).devicePixelRatio).round(),
      ),
    ),
  );
}
