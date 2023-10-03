import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/components/show_bottom_sheet_to_add_task.dart';
import '../../shared/components/show_toast_short.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/styles/colors.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late final GlobalKey<ScaffoldState> scaffoldKey;
  late final GlobalKey<FormState> formKey;
  late final PageController pageController;
  late final TextEditingController titleController;
  late final TextEditingController timeController;
  late final TextEditingController dateController;

  @override
  void initState() {
    scaffoldKey = GlobalKey<ScaffoldState>();
    formKey = GlobalKey<FormState>();
    pageController = PageController();
    titleController = TextEditingController();
    timeController = TextEditingController();
    dateController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    titleController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoAppCubit, TodoAppStates>(
      listener: (context, state) {
        if (state is InsertDatabaseState) Navigator.pop(context);
        if (state is ChangeBottomSheetOpenState) {
          showToastShort(
            context: context,
            text: 'When Finished, Click on the add button',
            state: ToastStates.WARNING,
          );
        }
      },
      builder: (context, state) {
        final cubit = TodoAppCubit.get(context);
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Text(cubit.title[cubit.currentIndex]),
          ),
          body: ConditionalBuilder(
            condition: state is! GetDatabaseLoadingState,
            builder: (context) => PageView(
              children: cubit.screen,
              controller: pageController,
              onPageChanged: (index) => cubit.chagedIndex(index),
            ),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()),
          ),
          floatingActionButton: floatingActionButton(cubit),
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0.0,
            items: cubit.bottomNavigationBarItems,
            currentIndex: cubit.currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppColors.greyS100,
            onTap: (page) => pageController.jumpToPage(page),
          ),
        );
      },
    );
  }

  FloatingActionButton floatingActionButton(TodoAppCubit cubit) {
    return FloatingActionButton(
      child: Icon(cubit.fabIcon),
      onPressed: () => cubit.isBottomSheetShow
          ? validateToInsert(
              cubit: cubit,
              formKey: formKey,
              titleController: titleController,
              timeController: timeController,
              dateController: dateController,
            )
          : showBottomsheetToAddTask(
              cubit: cubit,
              scaffoldKey: scaffoldKey,
              formKey: formKey,
              titleController: titleController,
              timeController: timeController,
              dateController: dateController,
            ),
    );
  }
}
