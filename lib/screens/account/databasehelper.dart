import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;

class DbHelper {
  static Database? _database;

  static const String DB_name = "user.db";
  static const String Table_user = "user";
  static const int version = 1;

  static const String C_UserId = 'userid';
  static const String C_UserName = 'username';
  static const String C_Email = 'email';
  static const String C_Mobile = 'mobile';
  static const String C_Password = 'password';

  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  Future<Database> get database async {
    if(_database != null) {
      return _database!;
    }
    _database = await initDb();
    return _database!;
  }

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_name);
    var db = await openDatabase(path, version: version, onCreate: _onCreate);
    return db;
  }

  Future _onCreate(Database db, int intversion) async {
    await db.execute('''CREATE TABLE $Table_user(
    $C_UserId INTEGER PRIMARY KEY AUTOINCREMENT,
    $C_UserName TEXT,
    $C_Email TEXT,
    $C_Mobile TEXT,
    $C_Password TEXT
    )''');
    print("Table Create Successfully..!!");
  }

  Future<int> insertUser(String name, String email, String mobile, String password) async {
    final db = await database;
    var result = await db.insert(Table_user, {
      C_UserName: name,
      C_Email: email,
      C_Mobile: mobile,
      C_Password: sha256.convert(utf8.encode(password)).toString()
    });
    return result;
  }

  Future<List<Map<String, dynamic>>> queryAllUsers() async {
    final db = await database;
    var result = await db.query(Table_user);
    return result;
  }

  Future<Map<String, dynamic>?> queryUserByEmail(String emailOrMobile) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT * FROM $Table_user WHERE $C_Email = ? OR $C_Mobile = ? 
    LIMIT 1
    ''', [emailOrMobile, emailOrMobile]);

    if(results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }

  Future<Map<String, dynamic>?> fetchUserDataByEmaiORMOB(String email) async {
    Database db = await instance.database;

    List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT * FROM $Table_user WHERE $C_Email = ? OR $C_Mobile = ? 
    LIMIT 1
    ''', [email, email]);

    if(results.isNotEmpty) {
      return results.first;
    } else {
      return null;
    }
  }
}