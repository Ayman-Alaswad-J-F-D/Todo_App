import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../shared/styles/colors.dart';
import '../shared/styles/styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    required this.textEditingController,
    required this.typeInput,
    this.label,
    this.radius = 6.0,
    this.gapPadding = 5.0,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconColor = AppColors.primary,
    this.suffixPressed,
    this.onSubmit,
    this.onChange,
    this.onTap,
    this.validate,
    this.isPassword = false,
    this.readOnly = false,
    this.filledNeed = false,
    this.fillColor = AppColors.white,
    this.colorText = AppColors.primary,
    this.hintText,
    this.colorHintText,
    this.fontSizeHintText = 14,
    this.fontSizeText = 14,
    this.clickEnabled = true,
    this.minLines,
    this.maxLines,
    this.focusNode,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final TextInputType typeInput;
  final String? label;
  final double radius;
  final double gapPadding;
  final Icon? prefixIcon;
  final IconData? suffixIcon;
  final Color? suffixIconColor;
  final Function()? suffixPressed;
  final Function()? onSubmit;
  final Function(String)? onChange;
  final Function()? onTap;
  final String? Function(String?)? validate;
  final bool isPassword;
  final bool readOnly;
  final bool filledNeed;
  final Color fillColor;
  final Color colorText;
  final String? hintText;
  final Color? colorHintText;
  final double? fontSizeHintText;
  final double fontSizeText;
  final bool clickEnabled;
  final int? minLines;
  final int? maxLines;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(fontSize: fontSizeText.sp, color: colorText),
      focusNode: focusNode,
      readOnly: readOnly,
      enabled: clickEnabled,
      minLines: minLines,
      maxLines: maxLines,
      onTap: onTap,
      onChanged: onChange,
      validator: validate,
      controller: textEditingController,
      keyboardType: typeInput,
      obscureText: isPassword,
      // style: const TextStyle(color: Colors.indigo),
      decoration: InputDecoration(
        errorMaxLines: 2,
        errorStyle: TextStyle(fontSize: 12.sp),
        filled: filledNeed,
        fillColor: fillColor,
        labelText: label,
        labelStyle: const TextStyle(fontFamily: AppFonts.primaryFont),
        hintText: hintText,
        hintStyle: TextStyle(
          color: colorHintText,
          fontSize: fontSizeHintText?.sp,
        ),
        border: OutlineInputBorder(
          gapPadding: gapPadding,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          gapPadding: gapPadding,
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(
            color: AppColors.borderColor,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          gapPadding: gapPadding,
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          gapPadding: gapPadding,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          borderSide: const BorderSide(
            color: AppColors.red,
            width: 1.5,
          ),
        ),

        prefixIcon: prefixIcon,
        // suffixIconColor: suffixIconColor,
        suffixIcon: suffixIcon != null
            ? IconButton(
                onPressed: suffixPressed,
                icon: Icon(suffixIcon, color: suffixIconColor),
              )
            : null,
      ),
    );
  }
}
