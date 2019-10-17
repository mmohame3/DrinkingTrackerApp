import 'dart:io';
import 'package:Florish/globals.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableDays = "days";
final String columnDay = "day";
final String columnTimeList = 'time list';
final String columnTypeList = 'type list';
final String columnMaxBAC = 'maxBAC';
final String columnMBWater = 'Water at maxBAC';
final String columnDrinkCount = "total drink count";
final String columnWaterCount = "total water count";

class Day {
  DateTime date;
  var timeList = [];
  var typeList =[];
  double maxBAC;
  int waterAtMaxBAC;
  int totalDrinks;
  int totalWaters;

  Day();

  Day.fromMap(Map<String, dynamic> map) {
    date = map[columnDay];
    timeList = map[columnTimeList];
    typeList = map[columnTypeList];
    maxBAC = map[columnMaxBAC];
    waterAtMaxBAC = map[columnMBWater];
    totalDrinks = map[drinkCount];
    totalWaters = map[waterCount];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnDay: date,
      columnTimeList: timeList,
      columnTypeList: typeList,
      columnMaxBAC: maxBAC,
      columnMBWater: waterAtMaxBAC,
      columnDrinkCount: totalDrinks,
      columnWaterCount: totalWaters,
    };

    return map;
  }

  @override
  String toString() {
    return 'Day {date: $date, timeList: $timeList, typeList: $typeList, '
        'maxBAC: $maxBAC, waterAtMaxBAC: $waterAtMaxBAC,'
        'totalDrinks: $totalDrinks, totalWaters: $totalWaters}';
  }

}

class DatabaseHelper {
  static final _databaseName = "CalDatabase.db";
  static final _databaseVersion = 1;

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
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableDays (
              $columnDay DAY PRIMARY KEY
                $columnTimeList LIST NOT NULL,
                $columnTypeList LIST NOT NULL,
                $columnMaxBAC DOUBLE NOT NULL,
                $columnMBWater INTEGER NOT NULL,
                $columnDrinkCount INTEGER NOT NULL,
                $columnWaterCount INTEGER NOT NULL, 
              )
              ''');
  }

  Future<void> insert(Day day) async {
    Database db = await database;
    await db.insert(tableDays, day.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateDay(Day day) async {
    final db = await database;

    await db.update(tableDays, day.toMap(),
    where: "day = ?",
    whereArgs: [day.date]);
  }

}