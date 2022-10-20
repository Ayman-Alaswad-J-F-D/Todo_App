// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archive_tasks/archive_tasks_screen.dart';
import '../../modules/done_tasks/done_tasks_screen.dart';
import '../../modules/new_tasks/new_tasks_screen.dart';

part 'states.dart';

class TodoAppCubit extends Cubit<TodoAppStates> {
  TodoAppCubit() : super(AppInitialState());
  static TodoAppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = const [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchiveTasksScreen(),
  ];

  List<String> title = ['New Tasks', 'Done Tasks', 'Archive Tasks'];

  void chagedIndex(int index) {
    currentIndex = index;
    emit(BottomNavBarState());
  }

  bool isBottomSheetShow = false;
  IconData fabIcon = Icons.edit;

  void changeBottomSheetStata({required bool isShow, required IconData icon}) {
    if (isShow) {
      isBottomSheetShow = isShow;
      fabIcon = icon;
      emit(ChangeBottomSheetOpenState());
    } else {
      isBottomSheetShow = isShow;
      fabIcon = icon;
      emit(ChangeBottomSheetCloseState());
    }
  }

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() {
    // open the database
    // ignore: unused_local_variable
    openDatabase('todo.db', version: 1, onCreate: (database, version) async {
      // When creating the db, create the table
      print('database Created');
      await database
          .execute(
            'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)',
          )
          .then((value) => print('Table created'))
          .catchError(
              (error) => print('Error when created table ${error.toString()}'));
    }, onOpen: (database) {
      getFromDatabase(database);
      print('database opened');
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  insertDatabase({String? title, String? time, String? date}) async {
    await database?.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status) VALUES("$title","$time","$date","new")',
      )
          .then((value) {
        print('$value Insert Successfully');
        emit(InsertDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
      return null;
    });
  }

  void updateData({required String status, required int id}) async {
    database!.rawUpdate(
        'UPDATE tasks SET status = ? WHERE id = ?', [status, id]).then((value) {
      getFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }

  void deleteData({required int id}) async {
    database!.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }

  void getFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    emit(GetDatabaseLoadingState());
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      // ignore: avoid_function_literals_in_foreach_calls
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else {
          archiveTasks.add(element);
        }
      });
      emit(GetDatabaseState());
    });
  }
}
