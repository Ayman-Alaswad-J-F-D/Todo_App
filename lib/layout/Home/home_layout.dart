// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

import '../../shared/components/components.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  Color? background;

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var pageController = PageController();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {
        if (state is InsertDatabaseState) {
          Navigator.pop(context);
        }
        if (state is ChangeBottomSheetOpenState) {
          showToastShort(
            text: 'When Finished, Click on the add button',
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
            title: Text(cubit.title[cubit.currentIndex]),
          ),
          body: ConditionalBuilder(
            condition: state is! GetDatabaseLoadingState,
            builder: (context) => PageView(
                controller: pageController,
                children: cubit.screen,
                onPageChanged: (index) {
                  cubit.chagedIndex(index);
                }),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (cubit.isBottomSheetShow) {
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
              } else {
                scaffoldKey.currentState
                    ?.showBottomSheet(
                      (context) {
                        return addTask(
                          context,
                          formKey,
                          titleController,
                          timeController,
                          dateController,
                        );
                      },
                      elevation: 0,
                      backgroundColor: Colors.white,
                    )
                    .closed
                    .then((value) {
                      cubit.changeBottomSheetStata(
                          isShow: false, icon: Icons.edit);
                    });
                cubit.changeBottomSheetStata(isShow: true, icon: Icons.add);
              }
            },
            child: Icon(cubit.fabIcon),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: Colors.grey.shade100,
            elevation: 0.0,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (page) {
              pageController.jumpToPage(page);
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
