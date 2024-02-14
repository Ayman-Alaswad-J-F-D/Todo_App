import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class Global {
  static final GetIt getIt = GetIt.instance;

  static final GlobalKey<NavigatorState> _navigatorkey =
      GlobalKey(debugLabel: "main navigator");

  static GlobalKey<NavigatorState> get globalNavigatorKey => _navigatorkey;

  static String get isNewTask => _getTaskStatus(TaskStatus.NEW);
  static String get isDoneTask => _getTaskStatus(TaskStatus.DONE);

  static String _getTaskStatus(TaskStatus status) {
    switch (status) {
      case TaskStatus.NEW:
        return 'new';
      case TaskStatus.DONE:
        return 'done';
    }
  }
}

// ignore: constant_identifier_names
enum TaskStatus { NEW, DONE }
