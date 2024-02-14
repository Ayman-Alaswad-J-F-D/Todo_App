import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/styles/colors.dart';

import '../../../shared/components/show_picker_task.dart';
import '../../../shared/constants/constants.dart';
import '../../../widgets/custom_text_from_field.dart';
import '../../../widgets/label_widget.dart';

class RowDataAndTimeTextField extends StatelessWidget {
  const RowDataAndTimeTextField({
    Key? key,
    required this.dateController,
    required this.timeController,
    required ScrollController scrollController,
  })  : _scrollController = scrollController,
        super(key: key);

  final TextEditingController dateController;
  final TextEditingController timeController;
  final ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: widthScreen(context) / 2.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*  Field Date Task *//
              const LabelWidget(title: 'Date', pB: 8),
              CustomTextFormField(
                hintText: DateFormat.yMMMd().format(DateTime.now()),
                colorHintText: AppColors.greyS400,
                textEditingController: dateController,
                typeInput: TextInputType.none,
                filledNeed: true,
                suffixIcon: Icons.calendar_today_outlined,
                readOnly: true,
                validate: (text) {
                  if (text!.isEmpty) {
                    return 'Please Enter The Date';
                  }
                  return null;
                },
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  showDatePickerTask(context, dateController).then(
                    (_) => FocusScope.of(context).nextFocus(),
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(
          width: widthScreen(context) / 2.3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //*  Field Time Task *//
              const LabelWidget(title: 'Time', pB: 8),
              CustomTextFormField(
                // focusNode: _focusTime,
                hintText: DateFormat.jm().format(DateTime.now()),
                colorHintText: AppColors.greyS400,
                textEditingController: timeController,
                typeInput: TextInputType.none,
                filledNeed: true,
                suffixIcon: Icons.access_time,
                readOnly: true,
                validate: (text) {
                  if (text!.isEmpty) {
                    return 'Please Enter The Time';
                  }
                  return null;
                },
                onTap: () {
                  SystemChannels.textInput.invokeMethod('TextInput.hide');
                  showTimePickerTask(context, timeController).then(
                    (_) {
                      FocusScope.of(context).nextFocus();
                      Future.delayed(
                        const Duration(milliseconds: 700),
                        () => _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent + 20,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInCubic,
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
