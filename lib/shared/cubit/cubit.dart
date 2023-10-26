// ignore_for_file: import_of_legacy_library_into_null_safe, avoid_print, equal_keys_in_map

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/model/task_model.dart';

import '../constants/constants.dart';

part 'states.dart';

class TodoAppCubit extends Cubit<TodoAppStates> {
  TodoAppCubit() : super(AppInitialState());
  static TodoAppCubit get(context) => BlocProvider.of(context);

  int selected = 0;
  String imageFromCategory = Constants.categoryTask;

  File imageFromGallery = File('');

  void select(index) async {
    selected = index;
    switch (index) {
      case 0:
        imageFromCategory = Constants.categoryTask;
        break;
      case 1:
        imageFromCategory = Constants.categoryGoal;
        break;
      case 2:
        imageFromCategory = Constants.categoryEvent;
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
      print(imageFromGallery);

      emit(SelectedImageState());
    } on PlatformException catch (e) {
      print('Failed to pick image : $e');
    }
  }

  Database? database;
  List<TaskModel> newTasks = [];
  List<TaskModel> doneTasks = [];
  List<TaskModel> archiveTasks = [];

  final String tabelTodo = 'tasks';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnTime = 'time';
  final String columnDate = 'date';
  final String columnStatus = 'status';
  final String columnNote = 'note';
  final String columnImage = 'image';

  late final Image appIcon;

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
             $columnNote TEXT, $columnImage TEXT
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

  String? checkSelectedImage() {
    String? image = imageFromGallery.path != '' ? imageFromGallery.path : null;
    image ??= imageFromCategory;
    log('Image Is : => ' + image);
    return image;
  }

  Future<void> insertDatabase({
    String? title,
    String? time,
    String? date,
    String? note,
    // String? image,
  }) async {
    //? If Not Selected Image From Gallery  => is null
    String? image = checkSelectedImage();

    await database?.transaction((txn) async {
      log('Insert To Database', name: 'Insert Function');

      await txn
          .rawInsert(
        'INSERT INTO $tabelTodo($columnTitle, $columnTime, $columnDate, $columnStatus, $columnNote, $columnImage) VALUES("$title","$time","$date","new","$note","$image")',
      )
          .then((value) {
        log('$value Insert is Successfully', name: 'Insert Function');
        emit(InsertDatabaseState());
        getFromDatabase(database);
      }).catchError((error) {
        print('Error when inserting new record ${error.toString()}');
      });
    });
  }

  void updateStatus({
    required String status,
    required int id,
    bool? isChecked,
  }) async {
    log('Update To Database', name: 'Update Function');
    await database!.rawUpdate(
      'UPDATE $tabelTodo SET $columnStatus = ? WHERE id = ?',
      [status, id],
    ).then((value) {
      log('Update is Successfully', name: 'Update Function');
      getFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }

  // ! Not Used After
  void updateImage({required String image, required int id}) async {
    await database!.rawUpdate(
        'UPDATE $tabelTodo SET $columnImage = ? WHERE id = ?',
        [image, id]).then((value) {
      print(image);
      print(value);
      getFromDatabase(database);
      emit(UpdateDatabaseState());
    });
  }

  void deleteTask({required int id}) async {
    log('Delete From Database', name: 'Delete Function');
    await database!
        .rawDelete('DELETE FROM $tabelTodo WHERE id = ?', [id]).then((value) {
      log('Delete is Successfully', name: 'Delete Function');
      getFromDatabase(database);
      emit(DeleteDatabaseState());
    });
  }

  void getFromDatabase(Database? database) async {
    emit(GetDatabaseLoadingState());
    log('Get All Data From Database', name: 'Get Data Function');
    await database!.rawQuery('SELECT * FROM $tabelTodo').then((value) {
      //* This Query is return to all data from database .. meaning a to list new/done/archive
      //* => if condition don't true
      //? Therefore, the condition was met only when the database was created
      log('Get Data is Successfully', name: 'Get Data Function');
      if (value.isEmpty) {
        emit(IsEmptyDatebaseState());
        return;
      }
      newTasks.clear();
      doneTasks.clear();
      archiveTasks.clear();
      log('Start Add Data to Task List', name: 'Get Data Function');
      for (var element in value) {
        final task = TaskModel.fromMap(element);
        switch (task.status) {
          case 'new':
            newTasks.add(task);
            break;

          case 'done':
            doneTasks.add(task);
            break;

          default:
            archiveTasks.add(task);
            break;
        }
      }
      log('Done Added Data to Task List', name: 'Get Data Function');
      emit(GetDatabaseState());
    });
  }
}
