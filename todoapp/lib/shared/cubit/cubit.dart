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
        getDataFromDatabase(database);
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
        emit(AppInsertedToDatabaseState());

        getDataFromDatabase(database);
      }).catchError((error) {
        print('error when raw inserted to table ${error.toString()}');
        return null;
      });
    });
  }

  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];
    emit(AppLoadingDataFromDatabaseState());
    database.rawQuery('SELECT * FROM tasks').then(
      (value) {
        value.forEach(((element) {
          if (element['status'] == 'new')
            newTasks.add(element);
          else if (element['status'] == 'done')
            doneTasks.add(element);
          else
            archivedTasks.add(element);
        }));
        emit(
          AppGetDataFromDatabaseState(),
        );
      },
    );
  }

  bool? isBottomSheetShown = false;
  IconData? fabIcon = Icons.edit;

  void changeBottomSheetState(
      {@required bool? isShow, @required IconData? icon}) {
    isBottomSheetShown = isShow;
    fabIcon = icon;

    emit(AppChangeBottomSheetState());
  }

  void updateData({@required String? status, @required int? id}) {
    database?.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
          getDataFromDatabase(database);
      emit(AppUpdateDataFromDatabaseState());
    });
  }
}
