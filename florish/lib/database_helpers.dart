import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
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
final String columnSession = "sessionlist";
final String columnHydratio = "todayhydratio";
final String columnYesterHydratio = "yesterhydratio";

class Day {
  String date;
  List<int> hourList;
  List<int> minuteList;
  List<int> typeList;
  double maxBAC;
  int waterAtMaxBAC;
  int totalDrinks;
  int totalWaters;
  List<int> sessionList;
  double hydratio;
  double yesterHydratio;

  Day(
      {this.date,
      this.hourList,
      this.minuteList,
      this.typeList,
      this.maxBAC,
      this.waterAtMaxBAC,
      this.totalDrinks,
      this.totalWaters,
      this.sessionList,
      this.hydratio,
      this.yesterHydratio});

  Day.fromMap(Map<String, dynamic> map) {
    date = map[columnDay];
    hourList = map[columnHourList];
    minuteList = map[columnMinuteList];
    typeList = map[columnTypeList];
    maxBAC = map[columnMaxBAC];
    waterAtMaxBAC = map[columnMBWater];
    totalDrinks = map[columnDrinkCount];
    totalWaters = map[columnWaterCount];
    sessionList = map[columnSession];
    hydratio = map[columnHydratio];
    yesterHydratio = map[columnYesterHydratio];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDay: date,
      columnHourList: hourList,
      columnMinuteList: minuteList,
      columnTypeList: typeList,
      columnMaxBAC: maxBAC,
      columnMBWater: waterAtMaxBAC,
      columnDrinkCount: totalDrinks,
      columnWaterCount: totalWaters,
      columnSession: sessionList,
      columnHydratio: hydratio,
      columnYesterHydratio: yesterHydratio
    };

    return map;
  }

  @override
  String toString() {
    return 'Day {date: $date, hourList: $hourList, minuteList: $minuteList, typeList: $typeList, '
        'maxBAC: $maxBAC, waterAtMaxBAC: $waterAtMaxBAC,'
        'totalDrinks: $totalDrinks, totalWaters: $totalWaters, '
        'session: $sessionList, todayhydratio: $hydratio, yesterhydratio: $yesterHydratio}';
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

  int getWaterAtMax() {
    if (this.waterAtMaxBAC >= 5) {
      return 5;
    }return this.waterAtMaxBAC;
  }

  int getTotalDrinks() {
    return this.totalDrinks;
  }

  int getTotalWaters() {
    return this.totalWaters;
  }

  double getHydratio() {
    return this.hydratio;
  }

  double getYesterHydratio() {
    return this.yesterHydratio;
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

  void addStartEnd(int i){
    this.sessionList.add(i);
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

  void setHydratio(double ratio) {
    this.hydratio = ratio;
  }

  void setYesterHydratio(double ratio) {
    this.yesterHydratio = ratio;
  }

//  void addSession(int start) {
//    this.session.add(start);
//  }
}

class DatabaseHelper {

  static final _databaseName = "CalendarDatabase_3.db";
  static final _databaseVersion = 2;

  static final tableDays = "days";
  static final columnDay = "day";
  static final columnHourList = 'hourlist';
  static final columnMinuteList = 'minutelist';
  static final columnTypeList = 'typelist';
  static final columnMaxBAC = 'maxBAC';
  static final columnMBWater = 'WateratmaxBAC';
  static final columnDrinkCount = "totaldrinkcount";
  static final columnWaterCount = "totalwatercount";
  static final columnSession = "sessionlist";
  static final columnHydratio = "todayhydratio";
  static final columnYesterHydratio = "yesterhydratio";

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
                $columnMaxBAC REAL NOT NULL,
                $columnMBWater INTEGER NOT NULL,
                $columnDrinkCount INTEGER NOT NULL,
                $columnWaterCount INTEGER NOT NULL,
                $columnSession BLOB NOT NULL,
                $columnHydratio REAL NOT NULL,
                $columnYesterHydratio REAL NOT NULL 
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
    Database db = await instance.database;
    print(new List<int>());
    print([]);
    Day newDay = Day(date: date, hourList: new List<int>(), minuteList: new List<int>(),
        typeList: new List<int>(), maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0,
        totalWaters: 0, sessionList: new List<int>(), hydratio: 0.0, yesterHydratio: 0.0);
    updateDay(newDay);
  }

  Future<Day> getDay(String date) async {
    Database db = await instance.database;
    List result =
        await db.query(tableDays, where: '$columnDay = ?', whereArgs: [date]);
    //Day dayone = result[0];
    //print("day from map: ${Day.fromMap(result.first)}");
    return result.isNotEmpty ? Day.fromMap(result.first) : Null ;
    //return dayone;
  }

  getInputInformation() async {
    var _connection = await database;
    return await _connection.query('inputTable');
  }

}
