import 'package:flutter/cupertino.dart';

class NewTasks extends StatelessWidget {
  const NewTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('New Task',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
      ),
    );
    
  }
}