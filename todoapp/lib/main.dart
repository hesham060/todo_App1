import 'package:flutter/material.dart';
import 'package:todoapp/layout/home_layout.dart';

void main() {
  // last last
 runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeLayout(),
    
    );
  }
}
