import 'package:flutter_project/sqlite_database/model/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static const DB_NAME = 'app.db';
  static const DB_VERSION = 1;

  // table
  static const TBL_USER = 'users';

  // Columns
  static final COL_ID = 'id';
  static final COL_FNAME = 'fname';
  static final COL_LNAME = 'lname';
  static final COL_EMAIL = 'email';
  static final COL_CONTACT = 'contact';
  static final COL_COURSE = 'course';
  static final COL_CREATED_AT = 'createdAt';

  DbHelper._internal();
  static DbHelper _instance = DbHelper._internal();

  // factory constructor
  factory DbHelper() {
    return _instance;
  }

  static Database? _database;

  Future<Database?> getDatabase() async {
    _database ??= await createDatabase();
    return _database;
    /*if(_database==null){
      // initialize database by calling openDatabase method
      _database = await createDatabase();
    }*/
  }

  Future<Database?> createDatabase() async {
    var dbPath = await getDatabasesPath();
    var dbName = "app.db";
    print('database path : ${dbPath}');
    print('database name : ${dbName}');

    var path = join(dbPath, dbName);
    print('actual path : ${path}');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('CREATE TABLE $TBL_USER('
            '$COL_ID INTEGER PRIMARY KEY AUTOINCREMENT , '
            '$COL_FNAME TEXT NOT NULL, '
            '$COL_LNAME TEXT NOT NULL, '
            '$COL_EMAIL TEXT, '
            '$COL_CONTACT TEXT,'
            '$COL_COURSE TEXT,'
            '$COL_CREATED_AT INTEGER)');
      },
    );
  }

  Future<int> insertRecord(User user) async {
    Database? db = await getDatabase();
    if(db!=null){
      return db.insert(TBL_USER, user.toMap());
    }
    return -1;
  }

  Future<List<User>> getAllRecords() async {
    Database? db = await getDatabase();

    // List<Map<String, dynamic>> mapList = await db!.query(TBL_USER, orderBy: "$COL_CREATED_AT DESE");
    List<Map<String, dynamic>> mapList = await db!
        .rawQuery('SELECT * FROM $TBL_USER ORDER BY $COL_CREATED_AT DESC');
    return List.generate(
        mapList.length, (index) => User.fromMap(mapList[index]))
        .toList(); // converting map object into dart object
  }

  Future<int> updateRecord(User user) async {
    Database? db = await getDatabase();

    if (db != null) {
      return db.update(TBL_USER, user.toMap(),
          where: "$COL_ID = ?", whereArgs: [user.id]);
    }
    return 0;
  }

  Future<int> deleteRecord(User user) async {
    Database? db = await getDatabase();

    if(db != null){
      return db.delete(TBL_USER, where: "$COL_ID =?", whereArgs: [user.id]);
    }
    return 0;
  }



}
