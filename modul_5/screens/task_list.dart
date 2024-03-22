import 'package:flutter/material.dart';
import 'package:flutter_project/modul_5/databse/db_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../model/task.dart';
import 'add_task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  // DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Task> _tasks = [];

  DbHelper _dbHelper = DbHelper();

  Future<void> updateUser(Task task, BuildContext context) async {
    int result = await _dbHelper.updateRecord(task);
    if (result > 0) {
      Fluttertoast.showToast(msg: 'Record updated successfully..');
      print('Record updated successfully..');
    } else {
      print('Getting error..');
    }
  }

  Future<void> deleteUser(Task task, BuildContext context) async {
    int result = await _dbHelper.deleteRecord(task);
    if (result > 0) {
      setState(() {
        _tasks.removeWhere((element) => element.id == task.id);
      });
      Fluttertoast.showToast(msg: 'Record Delete successfully..');
      print('$result - Recored Delete successfully');
      // Navigator.pop(context, task);
    } else {
      print('$result - Error');
      // Navigator.pop(context, null);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Management App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: _tasks.length,
          itemBuilder: (context, index) {
            Task task = _tasks[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          task.name,
                          style: TextStyle(fontSize: 22),
                        ),
                        popUpMenu(task),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(task.description,style: TextStyle(fontSize: 15)),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: Text(
                            DateFormat('dd-MM-yyyy').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse('${task.createdAt}'))),
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
              /*child: ListTile(
                title: Text(task.name, style: TextStyle(fontSize: 22)),
                subtitle: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(
                    DateTime.fromMillisecondsSinceEpoch(
                        int.parse('${task.createdAt}')))),
                trailing: popUpMenu(task),
              ),*/
              color: cardColor(task),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Task? task = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(),
                  )) ??
              null;

          if (task != null) {
            setState(() {
              _tasks.insert(0, task);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Future<void> _fetchUserList() async {
    var tempList = await _dbHelper.getAllRecords();
    setState(() {
      _tasks = tempList;
    });
  }

  cardColor(Task task) {
    if (task.completed == 'true') {
      return Colors.grey;
    } else if (task.priority == 'High') {
      return Colors.red;
    } else if (task.priority == 'Average') {
      return Colors.blue;
    } else if (task.priority == 'Low') {
      return Colors.green;
    }
  }

  popUpMenu(Task task) {
    return PopupMenuButton<String>(
      onSelected: (String result) {},
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          onTap: () {
            setState(() {
              task.completed = 'true';
              updateUser(task, context);
            });
          },
          child: Text('Complete Task'),
        ),
        PopupMenuItem<String>(
          onTap: () {
            setState(() {
              deleteUser(task, context);
            });
          },
          child: Text('Delete Task'),
        ),
      ],
    );
  }
}
