// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../../shared/components/components.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleConttroller = TextEditingController();
  var timeConttroller = TextEditingController();
  var dateConttroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {
        if (state is InsertDatabaseState) {
          Navigator.pop(context);
        }
        if (state is ChangeBottomSheetOpenState) {
          showToastShort(
            text: 'When finished, click on the add button',
            state: ToastStates.WARNING,
          );
        }
      },
      builder: (context, state) {
        TodoAppCubit cubit = TodoAppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          key: scaffoldKey,
          appBar: AppBar(
            title: Text(
              cubit.title[cubit.currentIndex],
              style: const TextStyle(fontFamily: 'Lora'),
            ),
          ),
          body: ConditionalBuilder(
            condition: state is! GetDatabaseLoadingState,
            builder: (context) => cubit.screen[cubit.currentIndex],
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShow) {
                if (formKey.currentState!.validate()) {
                  cubit.insertDatabase(
                    title: titleConttroller.text,
                    time: timeConttroller.text,
                    date: dateConttroller.text,
                  );
                  titleConttroller.clear();
                  timeConttroller.clear();
                  dateConttroller.clear();
                }
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet(
                      (context) => Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                myTextFormField(
                                  textEditingController: titleConttroller,
                                  typeInput: TextInputType.text,
                                  label: 'Task Title',
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'title must not be empty';
                                    }
                                    return null;
                                  },
                                  prefixIcon: const Icon(Icons.title),
                                ),
                                const SizedBox(height: 15),
                                myTextFormField(
                                  textEditingController: timeConttroller,
                                  typeInput: TextInputType.datetime,
                                  label: 'Task Time',
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    )
                                        .then(
                                      (value) => timeConttroller.text =
                                          value!.format(context).toString(),
                                    )
                                        .catchError((error) {
                                      timeConttroller.text = '';
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'time must not be empty';
                                    }
                                    return null;
                                  },
                                  prefixIcon:
                                      const Icon(Icons.watch_later_outlined),
                                ),
                                const SizedBox(height: 15),
                                myTextFormField(
                                  textEditingController: dateConttroller,
                                  typeInput: TextInputType.datetime,
                                  label: 'Task Date',
                                  onTap: () {
                                    showDatePicker(
                                      useRootNavigator: false,
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-12-01'),
                                    )
                                        .then(
                                      (value) => dateConttroller.text =
                                          DateFormat.yMMMd().format(value!),
                                    )
                                        .catchError((error) {
                                      dateConttroller.text = '';
                                    });
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'date must not be empty';
                                    }
                                    return null;
                                  },
                                  prefixIcon:
                                      const Icon(Icons.calendar_today_outlined),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.white,
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetStata(isShow: false, icon: Icons.edit);
                });

                cubit.changeBottomSheetStata(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey.shade100,
              elevation: 0.0,
              selectedLabelStyle: const TextStyle(fontFamily: 'Lora'),
              unselectedLabelStyle: const TextStyle(fontFamily: 'Lora'),
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.chagedIndex(index);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline_rounded),
                    label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_rounded), label: 'Archive'),
              ]),
        );
      },
    );
  }
}
