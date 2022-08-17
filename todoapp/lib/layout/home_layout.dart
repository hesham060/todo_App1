import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/archive_tasks.dart';
import 'package:todoapp/models/done_tasks.dart';
import 'package:todoapp/models/new_tasks.dart';
import '../shared/components/component.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchiveTasks(),
  ];
  List<String> title = ['new task', 'done task', 'archive task'];
  Database? database;
  bool isBottomSheetShown = false;
  IconData fabIcon = Icons.edit;
  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var formKey = GlobalKey<FormState>();
   List<Map> tasks =[];
  @override
  void initState() {
    super.initState();
    createDatabase();
  }

  var scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scafoldKey,
      appBar: AppBar(title: Text(title[currentIndex])),
      body: screens[currentIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isBottomSheetShown) {
            if (formKey.currentState!.validate()) {
              insertDataToDatabase(
                title: titlecontroller.text,
                time: timecontroller.text,
                date: datecontroller.text,
              ).then((value) {
                
              });
            }
          } else {
            scafoldKey.currentState!.showBottomSheet(
              (context) {
                return Container(
                  color: Colors.grey[100],
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          defaultTextFormField(
                              controller: titlecontroller,
                              labelText: 'Task Title',
                              iconData: Icons.title,
                              type: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'title must be empty';
                                }
                                return null;
                              },
                              ontap: () {
                                print('task title');
                              }),
                          SizedBox(
                            height: 10,
                          ), //title field
                          defaultTextFormField(
                              controller: timecontroller,
                              labelText: 'Task time',
                              iconData: Icons.watch_later_outlined,
                              type: TextInputType.datetime,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'time must not be empty';
                                }
                                return null;
                              },
                              ontap: () {
                                showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now())
                                    .then((value) {
                                  timecontroller.text =
                                      value!.format(context).toString();
                                  print(value.format(context));
                                });
                              }),
                          SizedBox(
                            height: 10,
                          ), //title field

                          defaultTextFormField(
                            controller: datecontroller,
                            labelText: 'Task Date ',
                            iconData: Icons.calendar_month_outlined,
                            type: TextInputType.datetime,
                            validate: (value) {
                              if (value!.isEmpty) {
                                return 'Date must not be empty';
                              }
                              return null;
                            },
                            ontap: () {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.parse('2022-12-31'),
                              ).then((value) {
                                datecontroller.text = DateFormat.yMMMd()
                                    .format(value!); //package intl
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ).closed.then((value) {
                isBottomSheetShown = false;
                setState(() {
                  fabIcon = Icons.edit;
                });
            });
            isBottomSheetShown = true;
            setState(() {
              fabIcon = Icons.add;
            });
          }
        },
        child: Icon(fabIcon),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
          currentIndex = index;
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'New Task'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box_rounded), label: 'Done'),
          BottomNavigationBarItem(icon: Icon(Icons.archive), label: 'Archived'),
        ],
        currentIndex: currentIndex,
        elevation: 12,
      ),
    );
  }

  void createDatabase() async {
    database = await openDatabase(
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
        getDataFromDatabase(database).then((value) {
           tasks=value;
        });
      },
    );
  }

  Future insertDataToDatabase(
      {@required String? title,
      @required String? time,
      @required String? date}) async {
    await database?.transaction((txn) async {
      await txn
          .rawInsert(
              'INSERT INTO tasks( title, date, time, status) VALUES("first task", "0222", "891", "new")')
          .then((value) {
        print('$value inserted sucessfully');
      }).catchError((error) {
        print('error when raw inserted to table ${error.toString()}');
        return null;
      });
    });
  }

  Future<List<Map>> getDataFromDatabase(database)async{
   return  await database.rawQuery(
      'SELECT * FROM tasks'
    );
  }
}
