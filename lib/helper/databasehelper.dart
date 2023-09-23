import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

import '../models/alarms.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await initDatabase();

  Future<Database> initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'myAlarmsDatabase.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      '''
      CREATE TABLE MyAlarms (
        ID STRING NOT NULL,
        Hour INTEGER NOT NULL,
        MIN INTEGER NOt NULL,
        DAYS STRING NOT NULL,
        TONE STRING NOT NULL,
        isEnable INTEGER,
        Volume DOUBLE
      )
    ''',
    );
  }

  Future<List<Alarms>> getData() async {
    Database db = await instance.database;
    var alarms = await db.query('MyAlarms');
    List<Alarms> alarmsList =
        alarms.isNotEmpty ? alarms.map((c) => Alarms.fromMap(c)).toList() : [];
    return alarmsList;
  }

  Future<int> addIntoDatabase(Alarms alarm) async {
    print("one new entry");
    Database db = await instance.database;
    return await db.insert('MyAlarms', alarm.toMap());
  }

  Future<int> deleteFromDatabase(Alarms alarm) async {
    Database db = await instance.database;
    return await db.delete(
      'MyAlarms',
      where: 'ID = ? ',
      whereArgs: [
        alarm.id,
      ],
    );
  }

  Future<int> updateDatabase(Alarms alarm) async {
    Database db = await instance.database;
    return await db.update('MyAlarms', alarm.toMap(),
        where: "ID= ?", whereArgs: [alarm.id]);
  }
}
