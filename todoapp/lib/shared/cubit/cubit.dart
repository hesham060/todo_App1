import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/shared/cubit/states.dart';

import '../../models/archive_tasks.dart';
import '../../models/done_tasks.dart';
import '../../models/new_tasks.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];
  List<String> title = ['new task', 'done task', 'archive task'];

  void changeIndex(int index) {
    currentIndex = index;
    emit(AppChangeNavBarState());
  }

  Database? database;

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database is created');

        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, date TEXT, time TEXT,status TEXT)')
            .then((value) {
          print('tabel created');
        }).catchError((error) {
          print('Error when creating table ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database is opened');
      },
    ).then((value) {
      database = value;

      emit(AppCreateDatabaseState());
    });
  }

  Future insertDataToDatabase(
      {@required String? title,
      @required String? time,
      @required String? date}) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks( title, date, time, status) VALUES("$title", "$date", "$time", "new")')
          .then((value) {
        print('$value inserted sucessfully');
        getDataFromDatabase(database).then(
          (value) {
            tasks = value;
            emit(AppGetDataFromDatabaseState());
          },
        );

        emit(AppInsertedToDatabaseState());
      }).catchError((error) {
        print('error when raw inserted to table ${error.toString()}');
        return null;
      });
    });
  }

  List<Map> tasks = [];

  Future<List<Map>> getDataFromDatabase(database) async {
    emit(AppLoadingDataFromDatabaseState());
    return await database.rawQuery('SELECT * FROM tasks');
  }

  bool? isBottomSheetShown = false;
  IconData? fabIcon = Icons.edit;

  void changeBottomSheetState(
      {@required bool? isShow, @required IconData? icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }
}
