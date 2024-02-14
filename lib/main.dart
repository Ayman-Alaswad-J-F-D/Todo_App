import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_app/app/global/global.dart';
import 'package:todo_app/app/injection_contaner/di.dart' as di;
import 'package:todo_app/modules/home/home_screen.dart';
import 'package:todo_app/shared/function/listen_to_notification.dart';
import 'package:todo_app/shared/theme/light_theme.dart';

import 'shared/bloc_observer.dart';
import 'shared/cubit/cubit.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await di.initAppModules();
  Bloc.observer = MyBlocObserver();
  runApp(const TodoApp());
}

class TodoApp extends StatefulWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    listenToNotification();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: const HomeScreen(),
      builder: (_, child) {
        return BlocProvider(
          create: (context) => TodoAppCubit()..createDatabase(),
          child: MaterialApp(
            navigatorKey: Global.globalNavigatorKey,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            home: child,
          ),
        );
      },
    );
  }
}
