import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/layout/home_layout.dart';
import 'package:todoapp/shared/bloc_observer.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  

  runApp(const MyApp());

  // last last
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeLayout(),
    );
  }
}
