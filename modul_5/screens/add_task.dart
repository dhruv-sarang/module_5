import 'package:flutter/material.dart';
import 'package:flutter_project/modul_5/databse/db_helper.dart';
import 'package:flutter_project/modul_5/model/task.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddTaskScreen extends StatefulWidget {
  Task? task;

  AddTaskScreen({this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String selectPriority = 'High';
  String completedTemp = 'false';

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  DbHelper _dbHelper = DbHelper();

  Future<void> addTask(Task task, BuildContext context) async {
    int result = await _dbHelper.insertRecord(task);
    if (result != -1) {
      task.id = result;
      Fluttertoast.showToast(msg: 'Record save successfully..');
      print('$result - Recored save successfully');
      Navigator.pop(context, task);
    } else {
      print('$result - Error');
      Navigator.pop(context, null);
    }
  }

  void initState() {
    if(widget.task != null){
      _nameController.text = widget.task!.name;
      _descriptionController.text = widget.task!.description;
      selectPriority = widget.task!.priority;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Select Task Priority',
                          style: TextStyle(fontSize: 20)),
                      RadioListTile(
                        value: 'High',
                        groupValue: selectPriority,
                        onChanged: (value) {
                          setState(() {
                            selectPriority = value!;
                          });
                        },
                        title: Text('High'),
                      ),
                      RadioListTile(
                        value: 'Average',
                        groupValue: selectPriority,
                        onChanged: (value) {
                          setState(() {
                            selectPriority = value!;
                          });
                        },
                        title: Text('Average'),
                      ),
                      RadioListTile(
                        value: 'Low',
                        groupValue: selectPriority,
                        onChanged: (value) {
                          setState(() {
                            selectPriority = value!;
                          });
                        },
                        title: Text('Low'),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                width: double.infinity,
                height: 45,
                child: FilledButton(
                  onPressed: () {
                    String name = _nameController.text.trim();
                    String description = _descriptionController.text.trim();

                    print(
                        'Name : $name\n Description: $description\n Priority : ${selectPriority}');

                    Task task = Task(name: name,
                        description: description,
                        priority: selectPriority,
                        completed: completedTemp,
                        createdAt: widget.task != null
                            ? widget.task!.createdAt
                            : DateTime
                            .now()
                            .millisecondsSinceEpoch);
                    if (name.isEmpty || description.isEmpty) {
                      Fluttertoast.showToast(msg: 'Field is Empty');
                      return;
                    }
                    addTask(task, context);
                  },
                  child: Text('Add Task'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
