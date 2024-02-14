import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;

Widget checkImage({required String image, double? width = 40}) {
  return p.extension(image) == '.svg'
      ? SvgPicture.asset(image, width: width?.w)
      : _circleImage(image, width);
}

Widget _circleImage(image, double? width) {
  final bytes = base64Decode(image);
  return CircleAvatar(
    radius: width != null ? (width.w / 2) : 24.r,
    child: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Image.memory(bytes, fit: BoxFit.cover),
    ),
  );
}
