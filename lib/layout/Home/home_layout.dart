// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                      (context) => addTask(
                        context,
                        formKey,
                        titleConttroller,
                        timeConttroller,
                        dateConttroller,
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
                label: 'Done',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.archive_rounded),
                label: 'Archive',
              ),
            ],
          ),
        );
      },
    );
  }
}
