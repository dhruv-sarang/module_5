import 'package:flutter/material.dart';
import 'package:flutter_project/modul_5/screens/task_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: TaskListScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
