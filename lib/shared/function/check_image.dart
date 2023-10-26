import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path/path.dart' as p;

Widget checkImage({required image, double? width = 40}) {
  return p.extension(image) == '.png' ||
          p.extension(image) == '.jpg' ||
          p.extension(image) == '.jpeg'
      ? CircleAvatar(
          backgroundImage: FileImage(File(image)),
          radius: width != null ? (width.w / 2) : 24.r,
        )
      : SvgPicture.asset(image, width: width?.w);
}
