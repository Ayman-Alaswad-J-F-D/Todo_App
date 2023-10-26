import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/modules/splash_screen/splash_screen.dart';
import 'package:todo_app/shared/styles/colors.dart';

import 'shared/bloc_observer.dart';
import 'shared/cubit/cubit.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return BlocProvider(
          create: (context) => TodoAppCubit()..createDatabase(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              // fontFamily: AppFonts.primaryFont,
              primarySwatch: AppColors.primary,
              bottomSheetTheme: const BottomSheetThemeData(
                backgroundColor: Colors.transparent,
              ),
            ),
            home: child,
          ),
        );
      },
      child: const SplashScreen(),
    );
  }
}
