import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/task.dart';

class DbHelper {
  static const DB_NAME = 'task.db';
  static const DB_VERSION = 1;

  static const TBL_TASK = 'tasks';

  static const COL_ID = 'id';
  static const COL_NAME = 'name';
  static const COL_DESCRIPTION = 'description';
  static const COL_PRIORITY = 'priority';
  static const COL_COMPLETED = 'completed';
  static final COL_CREATED_AT = 'createdAt';


  DbHelper._internal();

  static DbHelper _instance = DbHelper._internal();

  factory DbHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database?> getDatabase() async {
    _database ??= await createDatabase();
    return _database;
  }

  Future<Database?> createDatabase() async {
    var dbPath = await getDatabasesPath();
    var dbName = "task.db";

    print('database path : ${dbPath}');
    print('database name : ${dbName}');

    var path = join(dbPath, dbName);
    print('actual path : ${path}');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $TBL_TASK('
            '$COL_ID INTEGER PRIMARY KEY AUTOINCREMENT,'
            '$COL_NAME TEXT NOT NULL,'
            '$COL_DESCRIPTION TEXT NOT NULL,'
            '$COL_PRIORITY TEXT NOT NULL,'
            '$COL_COMPLETED TEXT NOT NULL,'
            '$COL_CREATED_AT INTEGER)');
      },
    );
  }

  Future<int> insertRecord(Task task) async {
    Database? db = await getDatabase();
    if(db!=null){
      return db.insert(TBL_TASK, task.toMap());
    }
    return -1;
  }

  Future<List<Task>> getAllRecords() async {
    Database? db = await getDatabase();

    // List<Map<String, dynamic>> mapList = await db!.query(TBL_USER, orderBy: "$COL_CREATED_AT DESE");
    List<Map<String, dynamic>> mapList = await db!
        .rawQuery('SELECT * FROM $TBL_TASK ORDER BY $COL_CREATED_AT DESC');
    return List.generate(
        mapList.length, (index) => Task.fromMap(mapList[index]))
        .toList(); // converting map object into dart object
  }

  Future<int> updateRecord(Task task) async {
    Database? db = await getDatabase();

    if (db != null) {
      // return db.rawUpdate('SELECT * FROM $TBL_TASK SET $COL_COMPLETED = "true" WHERE $COL_ID = [user.id] ');
      return db.update(
        TBL_TASK,
        {COL_COMPLETED: 'true'},
        where: '$COL_ID = ?',
        whereArgs: [task.id],
      );
    }
    return 0;
  }

  Future<int> deleteRecord(Task task) async {
    Database? db = await getDatabase();

    if(db != null){
      return db.delete(TBL_TASK, where: "$COL_ID =?", whereArgs: [task.id]);
    }
    return 0;
  }


}
