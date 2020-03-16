import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tenderapp/model/profile.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE Profile(sha1 TEXT, public TEXT, birthday TEXT, address TEXT, phone TEXT, email TEXT, picture TEXT)");
  }

  Future<int> saveProfile(Profile profile) async {
    var dbClient = await db;
    int res = await dbClient.insert("Profile", profile.toJson());
    return res;
  }

  Future<List<Profile>> getProfile() async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery('SELECT * FROM Profile');
    List<Profile> employees = new List();
    for (int i = 0; i < list.length; i++) {
      var profile = new Profile(
          list[i]["sha1"],
          list[i]["public"],
          list[i]["birthday"],
          list[i]["address"],
          list[i]["phone"],
          list[i]["email"],
          list[i]["picture"]);
      employees.add(profile);
    }
    print(employees.length);
    return employees;
  }
}
