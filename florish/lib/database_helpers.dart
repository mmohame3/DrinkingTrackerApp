import 'dart:async';
import 'dart:io';
import 'package:Florish/globals.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// database table and column names
final String tableDays = "days";
final String columnDay = "day";
final String columnHourList = 'hourlist';
final String columnMinuteList = 'minutelist';
final String columnTypeList = 'typelist';
final String columnMaxBAC = 'maxBAC';
final String columnMBWater = 'WateratmaxBAC';
final String columnDrinkCount = "totaldrinkcount";
final String columnWaterCount = "totalwatercount";

class Day {
  String date;
  List<int> hourList;
  List<int> minuteList;
  List<int> typeList;
  double maxBAC;
  int waterAtMaxBAC;
  int totalDrinks;
  int totalWaters;

  Day({this.date, this.hourList, this.minuteList, this.typeList, this.maxBAC,
  this.waterAtMaxBAC, this.totalDrinks, this.totalWaters});

  Day.fromMap(Map<String, dynamic> map) {
    date = map[columnDay];
    hourList = map[columnHourList];
    minuteList = map[columnMinuteList];
    typeList = map[columnTypeList];
    maxBAC = map[columnMaxBAC];
    waterAtMaxBAC = map[columnMBWater];
    totalDrinks = map[columnDrinkCount];
    totalWaters = map[columnWaterCount];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnDay: date,
      columnHourList: hourList,
      columnMinuteList: minuteList,
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
    return 'Day {date: $date, hourList: $hourList, minuteList: $minuteList, typeList: $typeList, '
        'maxBAC: $maxBAC, waterAtMaxBAC: $waterAtMaxBAC,'
        'totalDrinks: $totalDrinks, totalWaters: $totalWaters}';
  }

  // NOTE: this many getters and setters CANNOT be efficient in a
  // database but this is how we're doing it right now.
  String getDate() {
    return this.date;
  }

  List getHours() {
    return this.hourList;
  }

  List getMinutes() {
    return this.minuteList;
  }

  List getTypes() {
    return this.typeList;
  }

  double getMaxBac() {
    return this.maxBAC;
  }

  int getWaterAtMax(){
    return this.waterAtMaxBAC;
  }

  int getTotalDrinks() {
    return this.totalDrinks;
  }

  int getTotalWaters(){
    return totalWaters;
  }

  void setDate(String date) {
    this.date = date;
  }

  void addHour(int hour) {
    this.hourList.add(hour);
  }

  void addMinute(int minute) {
    this.minuteList.add(minute);
  }

  void addType(int type) {
    this.typeList.add(type);
  }

  void setMaxBac(double mb) {
    this.maxBAC = mb;
  }

  void setWatersAtMaxBac(int wamb) {
    this.waterAtMaxBAC = wamb;
  }

  void setTotalDrinks(int drinks) {
    this.totalDrinks = drinks;
  }

  void setTotalWaters(int waters) {
    this.totalWaters = waters;
  }
}

class DatabaseHelper {
  static final _databaseName = "CalendarDatabase.db";
  static final _databaseVersion = 1;

  static final tableDays = "days";
  static final columnDay = "day";
  static final columnHourList = 'hourlist';
  static final columnMinuteList = 'minutelist';
  static final columnTypeList = 'typelist';
  static final columnMaxBAC = 'maxBAC';
  static final columnMBWater = 'WateratmaxBAC';
  static final columnDrinkCount = "totaldrinkcount";
  static final columnWaterCount = "totalwatercount";

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
              $columnDay TEXT PRIMARY KEY,
                $columnHourList BLOB NOT NULL,
                $columnMinuteList BLOB NOT NULL,
                $columnTypeList BLOB NOT NULL,
                $columnMaxBAC REAL NOT NULL,
                $columnMBWater INTEGER NOT NULL,
                $columnDrinkCount INTEGER NOT NULL,
                $columnWaterCount INTEGER NOT NULL 
              )
              ''');
  }

  Future<void> insertDay(Day day) async {
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

  Future<void> deleteDay(String date) async {
    Database db = await instance.database;
    print("deleted?");
    return await db.delete(tableDays, where: '$columnDay = ?', whereArgs: [date]);
  }

  Future<Day> getDay(String date) async {
    Database db = await instance.database;
    List result =  await db.query(tableDays, where: '$columnDay = ?', whereArgs: [date]);
    Day dayone = result[0];
    return dayone;
  }


//  Future<List> getTimeList(DateTime day) async{
//    Database db = await database;
//    db.query(tableDays, columns: [columnDay, columnTimeList,]);
//  }

}





