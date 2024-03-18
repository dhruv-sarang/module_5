import 'package:flutter/material.dart';
import 'package:flutter_project/sqlite_database/screens/user_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../database/db_helper.dart';
import '../model/user.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> userList = [];
  DbHelper _dbHelper = DbHelper();

  Future<void> deleteUser(User user, BuildContext context) async {
    int result = await _dbHelper.deleteRecord(user);
    if (result > 0) {
      user.id = result;
      setState(() {
        userList.removeWhere((element) => element.id == user.id);
      });
      Fluttertoast.showToast(msg: 'Record Delete successfully..');
      print('$result - Recored Delete successfully');
      Navigator.pop(context, user);
    } else {
      print('$result - Error');
      Navigator.pop(context, null);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User List'),
        ),
        body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (context, index) {
            User user = userList[index];

            return Card(
              elevation: 3,
              child: ListTile(
                onTap: () async {
                  User? mUser = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserScreen(
                            user: user,
                          ),
                        ),
                      ) ??
                      null;

                  if (mUser != null) {
                    var index = userList
                        .indexWhere((element) => element.id == mUser.id);
                    setState(() {
                      userList[index] = mUser;
                    });
                  }
                },
                leading: Icon(
                  Icons.account_circle,
                  size: 50,
                ),
                title: Text('${user.fName} ${user.lName}'),
                subtitle: Text(
                    'Email : ${user.email}\nContact No. : ${user.contact}\nCourse : ${user.course}'),
                trailing: IconButton(
                    onPressed: () {
                      showAlertDialog(context, user);
                    },
                    icon: Icon(Icons.delete)),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            User? user = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserScreen(),
                  ),
                ) ??
                null;

            if (user != null) {
              setState(() {
                userList.insert(0, user);
              });
            }
          },
          child: Icon(Icons.add),
        ));
  }

  Future<void> _fetchUserList() async {
    var tempList = await _dbHelper.getAllRecords();
    setState(() {
      userList = tempList;
    });
  }

  Future<void> showAlertDialog(BuildContext context, User user) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Alert'),
        content: Text('Are you sure you want to Delete...'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteUser(user, context);
            },
            child: Text('Delete'),
          )
        ],
      ),
    );
  }
}



