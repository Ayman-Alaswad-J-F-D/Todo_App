import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/app/global/global.dart';
import 'package:todo_app/app/services/local_notifications_service.dart';
import 'package:todo_app/model/task_model.dart';

import '../constants/constants.dart';
import '../constants/strings.dart';

part 'states.dart';

class TodoAppCubit extends Cubit<TodoAppStates> {
  TodoAppCubit() : super(AppInitialState());
  static TodoAppCubit get(context) => BlocProvider.of(context);

  final _localNotificationsService =
      Global.getIt.get<LocalNotificationsService>();

  void cancelNotification(int id, String title) => _localNotificationsService
      .cancelNotificationWhenGoToScreen(id, title: title);

  void cancelGroupNotifications() =>
      _localNotificationsService.cancelGroupNotificationsWhenGoToScreen();

  int selected = 0;
  String imageFromCategory = Constants.categoryTaskIcon;
  File imageFromGallery = File('');

  void selectCategoryIcon(int index) {
    selected = index;
    switch (index) {
      case 0:
        imageFromCategory = Constants.categoryTaskIcon;
        break;
      case 1:
        imageFromCategory = Constants.categoryGoalIcon;
        break;
      case 2:
        imageFromCategory = Constants.categoryEventIcon;
        break;
    }
    if (imageFromGallery.isAbsolute) imageFromGallery = File('');
    emit(SelectedImageState());
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (image == null) return;
      imageFromGallery = File(image.path);
      debugPrint(imageFromGallery.toString());
      emit(SelectedImageState());
    } on PlatformException catch (e) {
      log('Failed to pick image : $e');
    }
  }

  Database? database;
  final List<TaskModel> newTasks = [];
  final List<TaskModel> doneTasks = [];
  final List<TaskModel> archiveTasks = [];
  TaskModel? _lastNewTask;

  void createDatabase() {
    // open the database
    openDatabase('todoDB.db', version: 1, onCreate: (database, version) async {
      // When creating the db, create the table
      log('Database Create', name: 'Create Function');
      await database
          .execute(
            '''CREATE TABLE $tabelTodo 
            (
             $columnId INTEGER PRIMARY KEY,
             $columnTitle TEXT, $columnDate TEXT,
             $columnTime TEXT, $columnStatus TEXT,
             $columnNote TEXT, $columnImage TEXT,
             $columnIsArchive INTEGER
            )
            ''',
          )
          .then((value) => log('Tabel Created', name: 'Create Function'))
          .catchError((error) =>
              log('Database Error', error: error, name: 'Create Function'));
    }, onOpen: (database) {
      log('Database Opened', name: 'Create Function');
      getFromDatabase(database);
    }).then((value) {
      database = value;
      emit(CreateDatabaseState());
    });
  }

  Future<void> insertDatabase({
    required String title,
    required String time,
    required String date,
    required String note,
  }) async {
    //? If Not Selected Image From Gallery => return imageFromCategory
    final String? image = _checkSelectedImage();

    await database?.transaction((txn) async {
      log('Insert To Database', name: 'Insert Function');
      await txn.rawInsert(
        '''
         INSERT INTO $tabelTodo
         (
         $columnTitle, $columnTime, $columnDate, $columnStatus, 
         $columnNote, $columnImage,$columnIsArchive
         ) 
         VALUES("$title","$time","$date","$statusTask","$note","$image",$isArchive)
         ''',
      ).then((count) {
        log('$count Insert is Successfully', name: 'Insert Function');
        getFromDatabase(database).then((_) {
          _scheduleNotificationForNewTask(count, title, time, date);
          if (imageFromGallery.isAbsolute) imageFromGallery = File('');
          emit(InsertDatabaseState());
        });
      }).catchError((error) {
        debugPrint('Error when inserting new record ${error.toString()}');
      });
    });
  }

  String? _checkSelectedImage() => imageFromGallery.path.isNotEmpty
      ? _convertImageToBase64()
      : imageFromCategory;

  String _convertImageToBase64() =>
      base64Encode(imageFromGallery.readAsBytesSync());

  void _scheduleNotificationForNewTask(id, titleTask, time, date) {
    _localNotificationsService.scheduleNotification(
      id: id,
      title: titleNotifications,
      body: titleTask,
      time: time,
      date: date,
      iconNotification: _getIconNotification(),
      payload: _lastNewTask!.title,
    );
  }

  String? _getIconNotification() => imageFromGallery.path.isEmpty
      ? imageFromCategory
      : null; //base64Encode(imageFromGallery.readAsBytesSync())

  void updateStatus({required String status, required int id}) async {
    log('Update To Database', name: 'Update Status Function');
    await database!.rawUpdate(
      'UPDATE $tabelTodo SET $columnStatus = ? WHERE $columnId = ?',
      [status, id],
    ).then((_) {
      log('Update is Successfully', name: 'Update Status Function');
      getFromDatabase(database).then((_) => emit(UpdateDatabaseState()));
    });
  }

  void updateToArchive({
    required bool isArchive,
    required int id,
  }) async {
    log('Update To Database', name: 'Update Archive Function');
    await database!.rawUpdate(
      'UPDATE $tabelTodo SET $columnIsArchive = ? WHERE $columnId = ?',
      [isArchive ? 1 : 0, id],
    ).then((_) {
      log('Update is Successfully', name: 'Update Archive Function');
      getFromDatabase(database).then((_) => emit(UpdateDatabaseState()));
    });
  }

  // ! Not Used After
  void updateImage({required String image, required int id}) async {
    await database!.rawUpdate(
      'UPDATE $tabelTodo SET $columnImage = ? WHERE $columnId = ?',
      [image, id],
    ).then(
      (_) => getFromDatabase(database).then((_) => emit(UpdateDatabaseState())),
    );
  }

  void deleteTask({required int id, String? title}) async {
    log('Delete From Database', name: 'Delete Function');
    _localNotificationsService.cancelNotification(id, title: title);
    await database!.rawDelete(
      'DELETE FROM $tabelTodo WHERE $columnId = ?',
      [id],
    ).then((_) {
      log('Delete is Successfully', name: 'Delete Function');
      getFromDatabase(database).then((_) => emit(DeleteDatabaseState()));
    });
  }

  void deleteAllTasksWhereStatus({
    String? status,
    bool isArchive = false,
  }) async {
    if (isArchive) return _deleteAllArchiveTasks();
    _deleteAllNewOrDoneTasks(status);

    _localNotificationsService.cancelAllNotificationsForce();
    log('All notifications have been canceled');
  }

  void _deleteAllArchiveTasks() async {
    await database!.rawDelete(
      'DELETE FROM $tabelTodo WHERE $columnIsArchive = ?',
      [1],
    ).then((_) {
      log('Delete All Tasks is Successfully', name: 'Delete Archive Function');
      getFromDatabase(database).then((_) => emit(DeleteDatabaseState()));
    });
  }

  void _deleteAllNewOrDoneTasks(String? status) async {
    await database!.rawDelete(
      'DELETE FROM $tabelTodo WHERE $columnStatus = ? and $columnIsArchive = ?',
      [status, 0],
    ).then((_) {
      log(
        'Delete All Tasks is Successfully',
        name: 'Delete New or Done Function',
      );
      getFromDatabase(database).then((_) => emit(DeleteDatabaseState()));
    });
  }

  Future<void> getFromDatabase(Database? database) async {
    await database!.rawQuery('SELECT * FROM $tabelTodo').then((value) {
      log('Get Data is Successfully', name: 'Get Data Function');
      _clearTasks();
      if (value.isEmpty) return emit(IsEmptyDatebaseState());
      final tasks = value.map((e) => TaskModel.fromMap(e)).toList();
      _fillTasks(tasks);
      log('Done Added Data to Task List', name: 'Get Data Function');
    }).catchError(
      (error) => log(error.toString(), name: "Error when get from database"),
    );
  }

  void _clearTasks() {
    newTasks.clear();
    doneTasks.clear();
    archiveTasks.clear();
  }

  void _fillTasks(List<TaskModel> tasks) {
    newTasks.addAll(tasks.where((task) => _isNew(task)).toList());
    doneTasks.addAll(tasks.where((task) => _isDone(task)).toList());
    archiveTasks.addAll(tasks.where((task) => task.isArchive).toList());
    _getLastNewTask();
  }

  bool _isNew(TaskModel task) =>
      task.status == Global.isNewTask && !task.isArchive;

  bool _isDone(TaskModel task) =>
      task.status == Global.isDoneTask && !task.isArchive;

  //* Sort out to save the last task Schedule notifications
  void _getLastNewTask() {
    if (newTasks.isEmpty) return;
    newTasks.sort((a, b) => a.id.compareTo(b.id));
    _lastNewTask = newTasks.last;
  }

  bool _newTasksIsAsc = false;
  bool _doneTasksIsAsc = false;
  bool _archiveTasksIsAsc = false;

  void sortNewTasks() {
    _sortLists(newTasks, _newTasksIsAsc);
    _newTasksIsAsc = !_newTasksIsAsc;
  }

  void sortDoneTasks() {
    _sortLists(doneTasks, _doneTasksIsAsc);
    _doneTasksIsAsc = !_doneTasksIsAsc;
  }

  void sortArchiveTasks() {
    _sortLists(archiveTasks, _archiveTasksIsAsc);
    _archiveTasksIsAsc = !_archiveTasksIsAsc;
  }

  void _sortLists(List<TaskModel> listTasks, bool isAscending) {
    if (!isAscending) {
      listTasks.sort((a, b) => b.id.compareTo(a.id));
    } else {
      listTasks.sort((a, b) => a.id.compareTo(b.id));
    }
    emit(SortingListState());
  }

  TaskModel getTaskById(int id) => newTasks.singleWhere(
        (task) => task.id == id,
        orElse: () => _getFromDone(id),
      );

  TaskModel _getFromDone(int id) => doneTasks.singleWhere(
        (task) => task.id == id,
        orElse: () => _getFromArchive(id),
      );

  TaskModel _getFromArchive(int id) =>
      archiveTasks.singleWhere((task) => task.id == id);
}
