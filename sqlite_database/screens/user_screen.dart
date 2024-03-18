
import 'package:flutter/material.dart';
import 'package:flutter_project/sqlite_database/database/db_helper.dart';
import 'package:flutter_project/sqlite_database/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserScreen extends StatefulWidget {
  User? user;

  UserScreen({this.user});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
/*  List<String> courses = ['Java', 'Dart', 'Android', 'Python'];
  String? selectedCourse;*/

  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _courseController = TextEditingController();

  DbHelper _dbHelper = DbHelper();

  Future<void> addUser(User user, BuildContext context) async {
    int result = await _dbHelper.insertRecord(user);
    if (result != -1) {
      user.id = result;
      Fluttertoast.showToast(msg: 'Record save successfully..');
      print('$result - Recored save successfully');
      Navigator.pop(context, user);
    } else {
      print('$result - Error');
      Navigator.pop(context, null);
    }
  }

  Future<void> updateUser(User user, BuildContext context) async {
    int result = await _dbHelper.updateRecord(user);
    if (result > 0) {
      Fluttertoast.showToast(msg: 'Record updated successfully..');
      print('Record updated successfully..');
      Navigator.pop(context, user);
    } else {
      print('Getting error..');
      Navigator.pop(context, null);
    }
  }

  @override
  void initState() {
    if(widget.user != null){
      _fNameController.text = widget.user!.fName;
      _lNameController.text = widget.user!.lName;
      _emailController.text = widget.user!.email;
      _contactController.text = widget.user!.contact;
      _courseController.text = widget.user!.course;
    }
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _fNameController,
                        decoration: InputDecoration(labelText: 'First name'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _lNameController,
                        decoration: InputDecoration(labelText: 'Last name'),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email address'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _contactController,
                  decoration: InputDecoration(labelText: 'Contact'),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _courseController,
                  decoration: InputDecoration(labelText: 'Course'),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      String fname = _fNameController.text.trim();
                      String lname = _lNameController.text.trim();
                      String email = _emailController.text.trim();
                      String contact = _contactController.text.trim();
                      String course = _courseController.text.trim();

                      print('''
                      Name : $fname $lname
                      Email : $email
                      Contact : $contact
                      Course : $course
                      ''');
                      User user = User(
                          id: widget.user != null ? widget.user!.id : null,
                          fName: fname,
                          lName: lname,
                          email: email,
                          contact: contact,
                          course: course,
                          createdAt: widget.user != null
                              ? widget.user!.createdAt
                              : DateTime.now().millisecondsSinceEpoch);

                      if (fname.isEmpty || lname.isEmpty || email.isEmpty || contact.isEmpty || course.isEmpty) {
                        Fluttertoast.showToast(msg: 'Field is Empty');
                        return;
                      }

                      if(widget.user!=null){
                        updateUser(user, context);
                      }else{
                        addUser(user, context);
                      }
                      /*Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserListScreen(),
                          ),
                          (route) => false);*/
                    },
                    child: Text(widget.user != null ? 'Update User' : 'Add User'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
