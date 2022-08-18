import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    // return ListView.separated(
    //     itemBuilder: (context, index) => buildTaskItem(tasks[index]),
    //     separatorBuilder: ((context, index) => Container(
    //           height: 15,
    //         )),
    //     itemCount: tasks.length);
  }
}
