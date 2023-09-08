import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../styles/styles.dart';

Widget myTextFormField({
  required TextEditingController textEditingController,
  required TextInputType typeInput,
  required String label,
  double radius = 15.0,
  double gapPadding = 5.0,
  Icon? prefixIcon,
  IconData? suffixIcon,
  Function()? suffixPressed,
  Function()? onSubmit,
  Function(String)? onChange,
  Function()? onTap,
  String? Function(String?)? validate,
  bool isPassword = false,
  bool filledneed = false,
  Color fillColor = AppColors.white,
  String? hintText,
  Color? colorHintText,
  double? fintSizeHintText,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      controller: textEditingController,
      keyboardType: typeInput,
      obscureText: isPassword,
      // style: const TextStyle(color: Colors.indigo),
      decoration: InputDecoration(
        filled: filledneed,
        fillColor: filledneed ? fillColor : AppColors.white,
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: AppFonts.primaryFont,
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorHintText,
          fontSize: fintSizeHintText,
        ),
        border: OutlineInputBorder(
          gapPadding: gapPadding,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffixIcon),
              )
            : null,
      ),
    );
