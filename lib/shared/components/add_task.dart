import 'package:flutter/material.dart';

import 'custom_test_from_field.dart';
import 'show_picker_task.dart';
import '../styles/colors.dart';

class AddTask extends StatelessWidget {
  const AddTask({
    Key? key,
    required this.formKey,
    required this.titleController,
    required this.timeController,
    required this.dateController,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;
  final TextEditingController titleController;
  final TextEditingController timeController;
  final TextEditingController dateController;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.greyS100,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: textFormFieldItems(context),
          ),
        ),
      ),
    );
  }

  List<Widget> textFormFieldItems(context) => [
        myTextFormField(
          label: 'Task Title',
          typeInput: TextInputType.text,
          prefixIcon: const Icon(Icons.title),
          textEditingController: titleController,
          validate: (value) {
            if (value!.isEmpty) return 'title must not be empty';
            return null;
          },
        ),
        const SizedBox(height: 15),
        myTextFormField(
          label: 'Task Time',
          typeInput: TextInputType.datetime,
          textEditingController: timeController,
          prefixIcon: const Icon(Icons.watch_later_outlined),
          onTap: () => showTimePickerTask(context, timeController),
          validate: (value) {
            if (value!.isEmpty) return 'time must not be empty';
            return null;
          },
        ),
        const SizedBox(height: 15),
        myTextFormField(
          label: 'Task Date',
          typeInput: TextInputType.datetime,
          textEditingController: dateController,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          onTap: () => showDatePickerTask(context, dateController),
          validate: (value) {
            if (value!.isEmpty) return 'date must not be empty';
            return null;
          },
        ),
        const SizedBox(height: 5),
      ];
}
