import 'package:flutter/material.dart';

import '../shared/constants/constants.dart';
import '../shared/styles/colors.dart';
import 'label_widget.dart';

Future confirmDialog({
  required BuildContext context,
  required String titleDialog,
  required String questionDialog,
  required String labelButton,
  required Color color,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      title: LabelWidget(title: titleDialog, color: color),
      content: SizedBox(
        width: widthScreen(context) / 1.2,
        child: LabelWidget(
          title: questionDialog,
          color: AppColors.greyS600,
          fontWeight: FontWeight.normal,
          fontSize: 15,
        ),
      ),
      actions: [
        TextButton(
          child: const LabelWidget(
            title: 'Cancel',
            fontWeight: FontWeight.normal,
          ),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: LabelWidget(title: labelButton, color: color),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  );
}
