import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../shared/components/background_header.dart';
import '../../shared/constants/constants.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/extension/extension.dart';
import '../../shared/styles/colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_from_field.dart';
import '../../widgets/label_widget.dart';
import '../../widgets/show_toast_short.dart';
import 'components/circle_images_selected.dart';
import 'components/row_date_and_time_text_field.dart';
import 'components/row_list_of_categories.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  // late final FocusNode _focusNode;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController timeController;
  late final TextEditingController dateController;
  late final TextEditingController noteController;
  late final ScrollController _scrollController;
  late final TodoAppCubit cubit;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _dis();
    super.dispose();
  }

  void _init() {
    _reconfigureInput();
    titleController = TextEditingController();
    timeController = TextEditingController();
    dateController = TextEditingController();
    noteController = TextEditingController();
    _scrollController = ScrollController();
  }

  void _dis() {
    titleController.dispose();
    timeController.dispose();
    dateController.dispose();
    noteController.dispose();
    _scrollController.dispose();
  }

  void _reconfigureInput() {
    cubit = TodoAppCubit.get(context);
    cubit.selected = 0;
    cubit.imageFromCategory = Constants.categoryTaskIcon;
    cubit.imageFromGallery = File('');
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final isKeyboard = viewInsets.bottom != 0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.secandry,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BackgroundHeader(
              headerLabel: 'Adding a New Task',
              positionedTop: 10,
              height: heightScreen(context) / 5.5,
              leadingIcon: Icons.clear_rounded,
              leadingClick: () => context.backScreen(),
            ),
            //* Body Screen *//
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: !isKeyboard
                    ? EdgeInsets.only(bottom: viewInsets.bottom + 20.h)
                    : null,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //*  Field Title Task *//
                        const LabelWidget(title: 'Title Task', pB: 8, pT: 14),
                        CustomTextFormField(
                          // focusNode: _focusNode,
                          hintText: 'Title',
                          colorHintText: AppColors.greyS400,
                          textEditingController: titleController,
                          typeInput: TextInputType.text,
                          filledNeed: true,
                          validate: (text) {
                            if (text!.isEmpty) return 'Please Enter The Title';
                            return null;
                          },
                        ),
                        //* Row List Category *//
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 14.0),
                          child: BlocBuilder<TodoAppCubit, TodoAppStates>(
                            buildWhen: (_, current) =>
                                current is SelectedImageState ||
                                current is InsertDatabaseState,
                            builder: (context, state) {
                              final isEmptyImage =
                                  cubit.imageFromGallery.path == '';
                              return FittedBox(
                                child: Row(
                                  children: [
                                    const LabelWidget(title: 'Category'),
                                    SizedBox(width: 24.w),
                                    RowListOfCategories(
                                      cubit: cubit,
                                      isEmptyImage: isEmptyImage,
                                    ),
                                    CircleImageSeleceted(
                                      cubit: cubit,
                                      isEmptyImage: isEmptyImage,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        //*  Field Data & Time Task *//
                        RowDataAndTimeTextField(
                          dateController: dateController,
                          timeController: timeController,
                          scrollController: _scrollController,
                        ),
                        //*  Field Note Task *//
                        const LabelWidget(title: ' Note', pB: 8, pT: 14),
                        CustomTextFormField(
                          minLines: 4,
                          maxLines: 10,
                          hintText: 'Note ..',
                          colorHintText: AppColors.greyS400,
                          textEditingController: noteController,
                          typeInput: TextInputType.text,
                          filledNeed: true,
                          onTap: () => Future.delayed(
                            const Duration(milliseconds: 700),
                          ).then(
                            (_) => _scrollController.animateTo(
                              _scrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInCubic,
                            ),
                          ),
                        ),
                        SizedBox(height: viewInsets.bottom + 35.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 20),
          ],
        ),
        //*  Save Button *//
        bottomSheet: CustomButton(
          text: 'Save',
          click: () {
            if (formKey.currentState!.validate()) {
              final title = titleController.text;
              final date = dateController.text;
              final time = timeController.text;
              final note = noteController.text;
              clearControllers(context);
              cubit.insertDatabase(
                title: title,
                date: date,
                time: time,
                note: note,
              );
            }
          },
        ),
      ),
    );
  }

  void clearControllers(BuildContext context) {
    setState(() {
      titleController.clear();
      dateController.clear();
      timeController.clear();
      noteController.clear();
      showToastShort(
        context: context,
        text: 'Good Luck',
        state: ToastStates.SUCCESS,
      );
    });
  }
}
