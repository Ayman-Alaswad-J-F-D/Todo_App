import 'package:flutter/material.dart';

import '../shared/styles/colors.dart';

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  final bool value;
  final Function(bool?) onChange;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: value,
      onChanged: onChange,
      checkColor: AppColors.white,
      activeColor: const Color(0xff4A3780),
      side: const BorderSide(color: AppColors.primary, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
