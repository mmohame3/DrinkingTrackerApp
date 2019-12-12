import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Florish/models/day_model.dart';


class DatabaseHelper {

  static final _databaseName = "CalendarDatabase_3.db";
  static final _databaseVersion = 2;

  static final tableDays = "days";
  static final columnDay = "day";
  static final columnHourList = 'hourlist';
  static final columnMinuteList = 'minutelist';
  static final columnTypeList = 'typelist';
  static final columnConstantBACList = 'constantBACList';
  static final columnMaxBAC = 'maxBAC';
  static final columnMBWater = 'wateratmaxBAC';
  static final columnDrinkCount = "totaldrinkcount";
  static final columnWaterCount = "totalwatercount";
  static final columnHydratio = "hydratio";
  static final columnYesterHydratio = "yesterhydratio";
  static final columnLastBAC = "lastBAC";

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableDays (
              $columnDay TEXT PRIMARY KEY,
                $columnHourList BLOB NOT NULL,
                $columnMinuteList BLOB NOT NULL,
                $columnTypeList BLOB NOT NULL,
                $columnConstantBACList BLOB NOT NULL,
                $columnMaxBAC REAL NOT NULL,
                $columnMBWater INTEGER NOT NULL,
                $columnDrinkCount INTEGER NOT NULL,
                $columnWaterCount INTEGER NOT NULL,
                $columnHydratio REAL NOT NULL,
                $columnYesterHydratio REAL NOT NULL,
                $columnLastBAC REAL NOT NULL
              )
              ''');
    await db.execute('CREATE TABLE inputTable (id INTEGER PRIMARY KEY, feet INTEGER, inch INTEGER, weight INTEGER, gender TEXT)');
  }

  saveInputInformation(inputTable) async {
    var connection = await database;
    await connection.delete('inputTable');
    return await connection.insert('inputTable', inputTable);
  }

  Future<void> insertDay(Day day) async {
    Database db = await database;
    await db.insert(tableDays, day.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDay(Day day) async {
    final db = await database;

    await db.update(tableDays, day.toMap(),
        where: "day = ?", whereArgs: [day.date]);
  }

  Future<void> deleteDay(String date) async {
    Database db = await instance.database;
    print("deleted?");
    return await db
        .delete(tableDays, where: '$columnDay = ?', whereArgs: [date]);
  }

  Future<void> resetDay(String date) async {
    Day newDay = Day(date: date, hourList: new List<int>(), minuteList: new List<int>(),
        typeList: new List<int>(), constantBACList: new List<int>(), maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0,
        totalWaters: 0, hydratio: 0.0, yesterHydratio: 0.0,
        lastBAC: 0.0);
    updateDay(newDay);
  }

  Future<Day> getDay(String date) async {
    Database db = await instance.database;
    List result =
    await db.query(tableDays, where: '$columnDay = ?', whereArgs: [date]);
    return result.isNotEmpty ? Day.fromMap(result.first) : Null ;
  }

  getInputInformation() async {
    var _connection = await database;
    return await _connection.query('inputTable');
  }

}