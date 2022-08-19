import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/shared/cubit/cubit.dart';
import 'package:todoapp/shared/cubit/states.dart';
import '../shared/components/component.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  var titlecontroller = TextEditingController();
  var datecontroller = TextEditingController();
  var timecontroller = TextEditingController();
  var formKey = GlobalKey<FormState>();

  var scafoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertedToDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scafoldKey,
            appBar: AppBar(title: Text(cubit.title[cubit.currentIndex])),
            body: ConditionalBuilder(
              condition: state is!AppLoadingDataFromDatabaseState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) => Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShown!) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDataToDatabase(
                        title: titlecontroller.text,
                        time: timecontroller.text,
                        date: datecontroller.text);
                    // insertDataToDatabase(
                    //   title: titlecontroller.text,
                    //   time: timecontroller.text,
                    //   date: datecontroller.text,
                    // ).then((value) {
                    //   getDataFromDatabase( database).then((value) {
                    //     Navigator.pop(context);
                    //     // setState(() {
                    //     //   tasks = value;
                    //     //   fabIcon = Icons.edit;
                    //     //   isBottomSheetShown = false;
                    //     //   print(tasks);
                    //     // });
                    //   });
                    // });
                  }
                } else {
                  scafoldKey.currentState!
                      .showBottomSheet(
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
                                            timecontroller.text = value!
                                                .format(context)
                                                .toString();
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
                                          lastDate:
                                              DateTime.parse('2022-12-31'),
                                        ).then((value) {
                                          datecontroller.text =
                                              DateFormat.yMMMd().format(
                                                  value!); //package intl
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                      .closed
                      .then((value) {
                        cubit.changeBottomSheetState(
                            isShow: false, icon: Icons.edit);
                      });

                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(cubit.fabIcon),
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                // setState(() {
                //   currentIndex = index;
                // });
                AppCubit.get(context).changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.menu), label: 'New Task'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_box_rounded), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive), label: 'Archived'),
              ],
              currentIndex: AppCubit.get(context).currentIndex,
              elevation: 12,
            ),
          );
        },
      ),
    );
  }
}
