import 'package:flutter/material.dart';

import '../styles/colors.dart';
import '../cubit/cubit.dart';
import 'add_task.dart';

void showBottomsheetToAddTask({
  required TodoAppCubit cubit,
  scaffoldKey,
  formKey,
  titleController,
  timeController,
  dateController,
}) {
  scaffoldKey.currentState
      ?.showBottomSheet(
        (context) => AddTask(
          formKey: formKey,
          titleController: titleController,
          timeController: timeController,
          dateController: dateController,
        ),
        elevation: 0,
        backgroundColor: AppColors.white,
      )
      .closed
      .then((value) {
    cubit.changeBottomSheetStata(isShow: false, icon: Icons.edit);
  });
  cubit.changeBottomSheetStata(isShow: true, icon: Icons.add);
}

void validateToInsert({
  required TodoAppCubit cubit,
  formKey,
  titleController,
  timeController,
  dateController,
}) {
  if (formKey.currentState!.validate()) {
    cubit.insertDatabase(
      title: titleController.text,
      time: timeController.text,
      date: dateController.text,
    );
    titleController.clear();
    timeController.clear();
    dateController.clear();
  }
}
