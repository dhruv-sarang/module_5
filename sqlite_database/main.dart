import 'package:flutter/material.dart';
import 'package:flutter_project/sqlite_database/screens/user_list_screen.dart';

import 'database/db_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      home: UserListScreen(),
    );
  }
}
