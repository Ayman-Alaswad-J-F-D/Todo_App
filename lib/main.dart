import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Layout/Home/home_layout.dart';
import 'shared/bloc_observer.dart';
import 'shared/cubit/cubit.dart';
import 'shared/styles/colors.dart';
import 'shared/styles/styles.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoAppCubit()..createDatabase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: AppFonts.primaryFont,
          primarySwatch: AppColors.primary,
        ),
        home: HomeLayout(),
      ),
    );
  }
}
