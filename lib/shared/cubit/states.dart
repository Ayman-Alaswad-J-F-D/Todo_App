part of 'cubit.dart';

abstract class TodoAppStates {}

class AppInitialState extends TodoAppStates {}

class BottomNavBarState extends TodoAppStates {}

class CreateDatabaseState extends TodoAppStates {}

class GetDatabaseState extends TodoAppStates {}

class GetDatabaseLoadingState extends TodoAppStates {}

class InsertDatabaseState extends TodoAppStates {}

class ChangeBottomSheetOpenState extends TodoAppStates {}

class ChangeBottomSheetCloseState extends TodoAppStates {}

class UpdateDatabaseState extends TodoAppStates {}

class DeleteDatabaseState extends TodoAppStates {}

// class SelectImageTrueState extends TodoAppStates {}

// class SelectImageFlaseState extends TodoAppStates {}

class SelectImageRefereshState extends TodoAppStates {}
