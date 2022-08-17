import 'package:flutter/material.dart';
class DoneTasks extends StatelessWidget {
  const DoneTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('Done Task',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
      ),
    );
    
  }
}