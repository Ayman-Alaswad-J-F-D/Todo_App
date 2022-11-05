import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/Layout/Home/home_layout.dart';
import 'package:todo_app/shared/bloc_observer.dart';

import 'shared/cubit/cubit.dart';

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
          fontFamily: 'Lora',
          primarySwatch: Colors.teal,
        ),
        home:  HomeLayout(),
      ),
    );
  }
}
