import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:todo_app/shared/components/show_picker_task.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/extension/extension.dart';
import 'package:todo_app/widgets/label_widget.dart';

import '../../widgets/custom_text_from_field.dart';
import '../../shared/constants/constants.dart';
import '../../shared/styles/colors.dart';
import '../../shared/components/background_header.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/show_toast_short.dart';

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
    _clearData();
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

  void _clearData() {
    final cubit = TodoAppCubit.get(context);
    cubit.selected = 0;
    cubit.imageFromCategory = Constants.categoryTask;
    cubit.imageFromGallery = File('');
  }

  @override
  Widget build(BuildContext context) {
    final cubit = TodoAppCubit.get(context);
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;

    return BlocListener<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {
        if (state is InsertDatabaseState) {
          showToastShort(
            context: context,
            text: 'Good Luck',
            state: ToastStates.SUCCESS,
          );
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColors.secandry,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BackgroundHeader(
                headerLabel: 'Add New Task',
                height: heightScreen(context) / 5.5,
                leadingIcon: Icons.clear_rounded,
                leadingClick: () => context.backScreen(),
              ),
              //* Body Screen *//
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: !isKeyboard
                      ? EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 20.h,
                        )
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
                          const LabelWidget(title: 'Title Task', pB: 8, pT: 16),
                          CustomTextFormField(
                            // focusNode: _focusNode,
                            hintText: 'Title Task',
                            textEditingController: titleController,
                            typeInput: TextInputType.text,
                            filledNeed: true,
                            validate: (text) {
                              if (text!.isEmpty) {
                                return 'Please Enter The Title';
                              }
                              return null;
                            },
                          ),
                          //* Row List Category *//
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: BlocBuilder<TodoAppCubit, TodoAppStates>(
                              builder: (context, state) {
                                final isEmptyImage =
                                    cubit.imageFromGallery.path == '';
                                return FittedBox(
                                  child: Row(
                                    children: [
                                      const LabelWidget(title: 'Category'),
                                      SizedBox(width: 24.w),
                                      Row(
                                        children: List<Widget>.generate(
                                          Constants.listSvgIcons.length,
                                          (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10),
                                              child: InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                onTap: () =>
                                                    cubit.select(index),
                                                child: CircleAvatar(
                                                  radius: 21.5.r,
                                                  backgroundColor:
                                                      cubit.selected == index &&
                                                              isEmptyImage
                                                          ? AppColors.primary
                                                          : AppColors.white,
                                                  child: CircleAvatar(
                                                    radius: 20.r,
                                                    backgroundColor:
                                                        AppColors.secandry,
                                                    child: SvgPicture.asset(
                                                      Constants
                                                          .listSvgIcons[index],
                                                      // width: widthScreen(context) / 8.2,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        width: !isEmptyImage ? 40.w : 0,
                                        child: !isEmptyImage
                                            ? CircleAvatar(
                                                radius: 21.5.r,
                                                backgroundColor:
                                                    AppColors.primary,
                                                child: CircleAvatar(
                                                  radius: 20.r,
                                                  backgroundImage: FileImage(
                                                    cubit.imageFromGallery,
                                                  ),
                                                ),
                                              )
                                            : const SizedBox(),
                                      ),
                                      IconButton(
                                        iconSize: 28.r,
                                        color: AppColors.primary,
                                        icon: const Icon(
                                          Icons.add_circle_outline_rounded,
                                        ),
                                        onPressed: () => cubit.pickImage(),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          Row(
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
                                      hintText: 'Date',
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
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        showDatePickerTask(
                                                context, dateController)
                                            .then(
                                          (_) => FocusScope.of(context)
                                              .nextFocus(),
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
                                      hintText: 'Time',
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
                                        SystemChannels.textInput
                                            .invokeMethod('TextInput.hide');
                                        showTimePickerTask(
                                          context,
                                          timeController,
                                        ).then(
                                          (_) {
                                            FocusScope.of(context).nextFocus();
                                            Future.delayed(
                                              const Duration(milliseconds: 700),
                                            ).then(
                                              (_) =>
                                                  _scrollController.animateTo(
                                                _scrollController.position
                                                        .maxScrollExtent +
                                                    20,
                                                duration: const Duration(
                                                  milliseconds: 500,
                                                ),
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
                          ),
                          //*  Field Note Task *//
                          const LabelWidget(title: ' Note', pB: 8, pT: 15),
                          CustomTextFormField(
                            hintText: 'Note ..',
                            minLines: 5,
                            maxLines: 10,
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
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  30.h,
                            ),
                          )
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
                cubit
                    .insertDatabase(
                  title: titleController.text,
                  date: dateController.text,
                  time: timeController.text,
                  note: noteController.text,
                )
                    .then((_) {
                  // titleController.clear();
                  // dateController.clear();
                  // timeController.clear();
                  // noteController.clear();
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
