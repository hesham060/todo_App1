import 'package:flutter/cupertino.dart';

class ArchiveTasks extends StatelessWidget {
  const ArchiveTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text('archive Task',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold),),
      ),
    );
    
  }
}