import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'database_helpers.dart' as database;
import 'main.dart' as main;
import 'globals.dart' as globals;
import 'package:sqflite/sqflite.dart';

class Calendar extends StatefulWidget {
  final ValueChanged<database.Day> parentAction;
  const Calendar({Key key, this.parentAction}) : super(key: key);

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  database.Day day;

  Future<database.Day> determineDay(DateTime date) async {
    List<Map> result;

    Database db = await database.DatabaseHelper.instance.database;
    result = await db.rawQuery('SELECT * FROM days WHERE day=?', [main.dateTimeToString(date)]);

//  getDbResult(todayDate).then((dbResult) =>
//    result = dbResult);
    database.Day day;
    print(result);
    List<int> dbListH, dbListM, dbListT;
    if ((result == null) || (result.isEmpty)) {
      day = new database.Day(
          date: main.dateTimeToString(date),
          hourList: new List<int>(),
          minuteList: new List<int>(),
          typeList: new List<int>(),
          maxBAC: 0.0,
          waterAtMaxBAC: 0,
          totalDrinks: 0,
          totalWaters: 0);
      await db.insert(database.tableDays, day.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return day;
    } else {
//      print("result: ");
//      print(result[0]['hourList']);

      if (result[0]['hourlist'] == null) {
        dbListH = [];
        dbListM = [];
        dbListT = [];
      } else {
        dbListH = new List<int>.from(result[0]['hourlist']);
        dbListM = new List<int>.from(result[0]['minutelist']);
        dbListT = new List<int>.from(result[0]['typelist']);
      }

      day = new database.Day(
          date: result[0]["day"],
          hourList: dbListH,
          minuteList: dbListM,
          typeList: dbListT,
          maxBAC: result[0]['maxBAC'],
          waterAtMaxBAC: result[0]["WateratmaxBAC"],
          totalDrinks: result[0]["totaldrinkcount"],
          totalWaters: result[0]["totalwatercount"]);

      return day;
    }
  }

  static Widget _soberIcon(String day) => Container(
      decoration: BoxDecoration(
          color: Color(0xFFF0F086),
          borderRadius: BorderRadius.all(Radius.circular(1000))),
      child: Center(
          child: Text(
        day,
        style: TextStyle(color: Colors.black),
      )));

  static Widget _tipsyIcon(String day) => Container(
      decoration: BoxDecoration(
          color: Color(0xFFF0BF72),
          borderRadius: BorderRadius.all(Radius.circular(1000))),
      child: Center(
          child: Text(
        day,
        style: TextStyle(color: Colors.black),
      )));

  static Widget _drunkIcon(String day) => Container(
      decoration: BoxDecoration(
          color: Color(0xFFEB9800),
          borderRadius: BorderRadius.all(Radius.circular(1000))),
      child: Center(
          child: Text(
        day,
        style: TextStyle(color: Colors.black),
      )));

  static Widget _veryDrunkIcon(String day) => Container(
      decoration: BoxDecoration(
          color: Color(0xFFC53E3E),
          borderRadius: BorderRadius.all(Radius.circular(1000))),
      child: Center(
          child: Text(
        day,
        style: TextStyle(color: Colors.black),
      )));

  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
  static String noEventText = "No event here";
  String calendarText = noEventText;
  DateTime _currentDate = DateTime.now();

  // Where BAC
  // 0.00–0.03 = Sober; Yellow-Green
  // 0.03—0.06 = Tipsy; Yellow
  // 0.06-0.09 = Drunk; Orange
  // 0.10-0.12 = Very Drunk; Red
  List<DateTime> soberDates;
  List<DateTime> tipsyDates = [DateTime(2019, 10, 30)];
  List<DateTime> drunkDates = [DateTime(2019, 10, 31)];
  List<DateTime> veryDrunkDates = [DateTime(2019, 11, 1)];

  List<List<DateTime>> sortDates() {
    // TODO: write this function
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < soberDates.length; i++) {
      _markedDateMap.add(
          soberDates[i],
          new Event(
              date: soberDates[i],
              icon: _soberIcon(soberDates[i].day.toString())));
    }

    for (int i = 0; i < tipsyDates.length; i++) {
      _markedDateMap.add(
          tipsyDates[i],
          new Event(
              date: tipsyDates[i],
              icon: _tipsyIcon(tipsyDates[i].day.toString())));
    }

    for (int i = 0; i < drunkDates.length; i++) {
      _markedDateMap.add(
          drunkDates[i],
          new Event(
              date: drunkDates[i],
              icon: _drunkIcon(drunkDates[i].day.toString())));
    }

    for (int i = 0; i < veryDrunkDates.length; i++) {
      _markedDateMap.add(
          veryDrunkDates[i],
          new Event(
              date: veryDrunkDates[i],
              icon: _veryDrunkIcon(veryDrunkDates[i].day.toString())));
    }

    return CalendarCarousel(
        selectedDateTime: _currentDate,
        selectedDayButtonColor: Color(0xFF97B633),
        selectedDayTextStyle: TextStyle(color: Colors.black),
        height: 350,
        width: 300,
        daysHaveCircularBorder: null,
        weekendTextStyle: TextStyle(color: Colors.black),
        weekdayTextStyle: TextStyle(color: Colors.black),
        todayTextStyle: TextStyle(color: Colors.black),
        todayButtonColor: Color(0xFFC9D986),
        iconColor: Colors.black,
        headerTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
        ),
        minSelectedDate: DateTime(2019, 8, 1), // TODO: make these infinite!
        maxSelectedDate: DateTime(2022, 12, 31),
        markedDatesMap: _markedDateMap,
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        markedDateMoreShowTotal: null,
        markedDateIconBuilder: (event) {
          return event.icon;
        },

        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate = date);
          determineDay(date);
//          widget.parentAction(day);
        });
  }
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  database.Day day = globals.today;
  double maxBACOnDay = 0;
  int waterOnDay = 0;
  List<String> times;
  List<String> types;

  _updateSelectedDay(database.Day day) {
    setState(() {
      this.day = day;
      print(this.day.toString());
    });
  }

  String typeToImageName(int type) {
    if (type == 1) {
      return 'assets/images/soloCup.png';
    } else {
      return 'assets/images/waterDrop.png';
    }
  }

  String plantNameAtMax() {
    int bac;
    int water;

    if (day.getMaxBac() >= 0.12) {
      bac == 0.12;
    } else {
      bac == day.getMaxBac();
    }

    if (day.getWaterAtMax() >= 5) {
      water == 5;
    } else {
      water == day.getWaterAtMax();
    }
    print('assets/images/plants/drink${bac}water$water.png');
    return 'assets/images/plants/drink${bac}water$water.png';
  }

  String minutesToString(int minutes) {
    if (minutes < 10) {
      return '0$minutes';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Your Drinking History'),
          backgroundColor: Color(0xFF97B633),
        ),
        body: Container(
            // gives calendar space around it
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
//                bottom: MediaQuery.of(context).size.width / 15
            ),
            color: Color(0xFFF2F2F2),
            child: Column(children: [
              Container(
                  // white background
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white),
                  child: Calendar(
                    parentAction: _updateSelectedDay,
                  )),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(children: <Widget>[
                          Image.asset(
                            plantNameAtMax(),
                            width: 150,
                          ),
                          Text(day.getDate()),
                        ]),
                        SingleChildScrollView(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 150,
                                  maxWidth: 150,
                                ),
                                child: Table(
                                    defaultVerticalAlignment:
                                        TableCellVerticalAlignment.middle,
                                    children: [
                                      for (int i = 0;
                                          day.getHours().length > i;
                                          i++)
                                        TableRow(children: [
                                          TableCell(
                                              child: Text(
                                                  day.getHours()[i].toString() +
                                                      ':' +
                                                      day
                                                          .getMinutes()[i]
                                                          .toString())),
//                                                  minutesToString(
//                                                      day.getMinutes()[i]))), // TODO: make minutes 01 instead of 1
                                          TableCell(
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  child: Image.asset(
                                                      typeToImageName(
                                                          day.getTypes()[i]),
                                                      height: 15)))
                                        ])
                                    ])))
                      ]))
            ])));
  }
}

//import 'package:flutter/material.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
//    show CalendarCarousel;
//import 'package:flutter_calendar_carousel/classes/event.dart';
//import 'package:flutter_calendar_carousel/classes/event_list.dart';
//import 'database_helpers.dart' as database;
//import 'main.dart' as main;
//import 'globals.dart' as globals;
//import 'package:sqflite/sqflite.dart';
//
//
//class Calendar extends StatefulWidget {
//  final ValueChanged<database.Day> parentAction;
//  const Calendar({Key key, this.parentAction}) : super(key: key);
//
//  @override
//  _CalendarState createState() => new _CalendarState();
//}
//
//class _CalendarState extends State<Calendar> {
//  database.Day day = globals.today;
//
//  Future<database.Day> determineDay() async {
//    DateTime time = DateTime.now();
//    //DateTime tdn;
//    if (time.hour < 12){
//      time = new DateTime(time.year, time.month, time.day - 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
//    }
//    String todayDate = main.dateTimeToString(time);
//    List<Map> result;
//
//    Database db = await database.DatabaseHelper.instance.database;
//    result = await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);
//
////  getDbResult(todayDate).then((dbResult) =>
////    result = dbResult);
//    database.Day day;
//    print(result);
//    List<int> dbListH, dbListM, dbListT;
//    if ((result == null) || (result.isEmpty)) {
//      day = new database.Day(date: todayDate, hourList: new List<int>(), minuteList: new List<int>(), typeList: new List<int>(), maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0, totalWaters: 0);
//      await db.insert(database.tableDays, day.toMap(),
//          conflictAlgorithm: ConflictAlgorithm.replace);
//      return day;
//    }
//
//    else {
//      print("result: ");
//      print(result[0]['hourList']);
//
//      if (result[0]['hourlist'] == null) {
//        dbListH = [];
//        dbListM = [];
//        dbListT = [];
//      }
//      else {
//        dbListH = new List<int>.from(result[0]['hourlist']);
//        dbListM = new List<int>.from(result[0]['minutelist']);
//        dbListT = new List<int>.from(result[0]['typelist']);
//
//      }
//
//
//      day = new database.Day(date: result[0]["day"], hourList: dbListH, minuteList: dbListM,
//          typeList: dbListT, maxBAC: result[0]['maxBAC'], waterAtMaxBAC: result[0]["WateratmaxBAC"],
//          totalDrinks: result[0]["totaldrinkcount"], totalWaters: result[0]["totalwatercount"]);
//
//      return day;
//    }
//  }
//
////  Future<database.Day> determineDay(DateTime date) async {
////    Database db = await database.DatabaseHelper.instance.database;
////    List<Map> result = await db.rawQuery(
////        'SELECT * FROM days WHERE day=?', [main.dateTimeToString(date)]);
////
////    if (result.isEmpty) {
////      day = new database.Day(
////          date: main.dateTimeToString(date),
////          hourList: [],
////          minuteList: [],
////          typeList: [],
////          maxBAC: 0.0,
////          waterAtMaxBAC: 0,
////          totalDrinks: 0,
////          totalWaters: 0);
////      return day;
////    } else {
////      day = new database.Day(
////          date: result[0]["day"],
////          hourList: new List<int>.from(result[0]['hourlist']),
////          minuteList: new List<int>.from(result[0]['minutelist']),
////          typeList: new List<int>.from(result[0]['typelist']),
////          maxBAC: result[0]['maxBAC'],
////          waterAtMaxBAC: result[0]["WateratmaxBAC"],
////          totalDrinks: result[0]["totaldrinkcount"],
////          totalWaters: result[0]["totalwatercount"]);
////      return day;
////    }
////  }
//
//  static Widget _soberIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFF0F086),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//        day,
//        style: TextStyle(color: Colors.black),
//      )));
//
//  static Widget _tipsyIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFF0BF72),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//        day,
//        style: TextStyle(color: Colors.black),
//      )));
//
//  static Widget _drunkIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFEB9800),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//        day,
//        style: TextStyle(color: Colors.black),
//      )));
//
//  static Widget _veryDrunkIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFC53E3E),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//        day,
//        style: TextStyle(color: Colors.black),
//      )));
//
//  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
//  static String noEventText = "No event here";
//  String calendarText = noEventText;
//  DateTime _currentDate = DateTime.now();
//
//  // Where BAC
//  // 0.00–0.03 = Sober; Yellow-Green
//  // 0.03—0.06 = Tipsy; Yellow
//  // 0.06-0.09 = Drunk; Orange
//  // 0.10-0.12 = Very Drunk; Red
//  List<DateTime> soberDates = [DateTime(2019, 10, 29)];
//  List<DateTime> tipsyDates = [DateTime(2019, 10, 30)];
//  List<DateTime> drunkDates = [DateTime(2019, 10, 31)];
//  List<DateTime> veryDrunkDates = [DateTime(2019, 11, 1)];
//
//  @override
//  Widget build(BuildContext context) {
//    for (int i = 0; i < soberDates.length; i++) {
//      _markedDateMap.add(
//          soberDates[i],
//          new Event(
//              date: soberDates[i],
//              icon: _soberIcon(soberDates[i].day.toString())));
//    }
//
//    for (int i = 0; i < tipsyDates.length; i++) {
//      _markedDateMap.add(
//          tipsyDates[i],
//          new Event(
//              date: tipsyDates[i],
//              icon: _tipsyIcon(tipsyDates[i].day.toString())));
//    }
//
//    for (int i = 0; i < drunkDates.length; i++) {
//      _markedDateMap.add(
//          drunkDates[i],
//          new Event(
//              date: drunkDates[i],
//              icon: _drunkIcon(drunkDates[i].day.toString())));
//    }
//
//    for (int i = 0; i < veryDrunkDates.length; i++) {
//      _markedDateMap.add(
//          veryDrunkDates[i],
//          new Event(
//              date: veryDrunkDates[i],
//              icon: _veryDrunkIcon(veryDrunkDates[i].day.toString())));
//    }
//
//    return CalendarCarousel(
//        selectedDateTime: _currentDate,
//        selectedDayButtonColor: Color(0xFF97B633),
//        selectedDayTextStyle: TextStyle(color: Colors.black),
//        height: 2 * MediaQuery.of(context).size.height / 5,
//        width: 4 * MediaQuery.of(context).size.width / 5,
//        daysHaveCircularBorder: null,
//        weekendTextStyle: TextStyle(color: Colors.black),
//        weekdayTextStyle: TextStyle(color: Colors.black),
//        todayTextStyle: TextStyle(color: Colors.black),
//        todayButtonColor: Color(0xFFC9D986),
//        iconColor: Colors.black,
//        headerTextStyle: TextStyle(
//          fontFamily: 'Montserrat',
//          color: Colors.black,
//        ),
//        minSelectedDate: DateTime(2019, 8, 1), // TODO: make these infinite!
//        maxSelectedDate: DateTime(2022, 12, 31),
//        markedDatesMap: _markedDateMap,
//        markedDateShowIcon: true,
//        markedDateIconMaxShown: 1,
//        markedDateMoreShowTotal: null,
//        markedDateIconBuilder: (event) {
//          return event.icon;
//        },
//        onDayPressed: (DateTime date, List<Event> events) {
//          this.setState(() => _currentDate = date);
//          determineDay();
//        });
//  }
//}
//
//class HistoryPage extends StatefulWidget {
//  @override
//  _HistoryPageState createState() => new _HistoryPageState();
//}
//
//class _HistoryPageState extends State<HistoryPage> {
//  database.Day day = globals.today;
//  double maxBACOnDay = 0;
//  int waterOnDay = 0;
//  List<String> times;
//  List<String> types;
//
////  _updateSelectedDay(database.Day day) {
////    setState(() {
////      this.day = day;
////      print(this.day.toString());
////    });
////  }
//
//  String typeToImageName(int type) {
//    if (type == 1) {
//      return 'assets/images/soloCup.png';
//    } else {
//      return 'assets/images/waterDrop.png';
//    }
//  }
//
//  String plantNameAtMax() {
//    int bac;
//    int water;
//
//    if (day.getMaxBac() >= 0.12) {
//      bac == 0.12;
//    } else {
//      bac == day.getMaxBac();
//    }
//
//    if (day.getWaterAtMax() >= 5) {
//      water == 5;
//    } else {
//      water == day.getWaterAtMax();
//    }
//    print('assets/images/plants/drink${bac}water$water.png');
//    return 'assets/images/plants/drink${bac}water$water.png';
//  }
//
//  String minutesToString(int minutes) {
//    if (minutes < 10) {
//      return '0$minutes';
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Your Drinking History'),
//          backgroundColor: Color(0xFF97B633),
//        ),
//        body: Container(
//            // gives calendar space around it
//            padding: EdgeInsets.only(
//              top: MediaQuery.of(context).size.width / 20,
//              left: MediaQuery.of(context).size.width / 20,
//              right: MediaQuery.of(context).size.width / 20,
////                bottom: MediaQuery.of(context).size.width / 15
//            ),
//            color: Color(0xFFF2F2F2),
//            child: Column(children: [
//              Container(
//                  // white background
//                  padding: EdgeInsets.only(
//                    left: MediaQuery.of(context).size.width / 15,
//                    right: MediaQuery.of(context).size.width / 15,
//                  ),
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(
//                        Radius.circular(10),
//                      ),
//                      color: Colors.white),
//                  child: Calendar(
////                    parentAction: _updateSelectedDay,
//                  )),
//              Container(
//                  padding: EdgeInsets.only(
//                      top: MediaQuery.of(context).size.width / 15),
//                  child: Row(
//                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                      children: <Widget>[
//                        Column(children: <Widget>[
//                          Image.asset(
//                            plantNameAtMax(),
//                            width: MediaQuery.of(context).size.width / 3,
//                          ),
//                          Text(day.getDate()),
//                        ]),
//                        SingleChildScrollView(
//                            child: ConstrainedBox(
//                                constraints: BoxConstraints(
//                                  maxHeight:
//                                      MediaQuery.of(context).size.height / 3,
//                                  maxWidth:
//                                      MediaQuery.of(context).size.width / 3,
//                                ),
//                                child: Table(
//                                    defaultVerticalAlignment:
//                                        TableCellVerticalAlignment.middle,
//                                    children: [
//                                      for (int i = 0;
//                                          day.getHours().length > i;
//                                          i++)
//                                        TableRow(children: [
//                                          TableCell(
//                                              child: Text(
//                                                  day.getHours()[i].toString() +
//                                                      ":" +
//                                                      minutesToString(day.getMinutes()[i]))),
//                                          TableCell(
//                                              child: Container(
//                                                  padding: EdgeInsets.all(5),
//                                                  child: Image.asset(
//                                                      typeToImageName(
//                                                          day.getTypes()[i]),
//                                                      height:
//                                                          MediaQuery.of(context)
//                                                                  .size
//                                                                  .width /
//                                                              9)))
//                                        ])
//                                    ])))
//                      ]))
//            ])));
//  }
//}

//import 'package:flutter/material.dart';
//import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
//    show CalendarCarousel;
//import 'package:flutter_calendar_carousel/classes/event.dart';
//import 'package:flutter_calendar_carousel/classes/event_list.dart';
//import 'database_helpers.dart' as database;
//import 'main.dart' as main;
//import 'globals.dart' as globals;
//import 'package:sqflite/sqflite.dart';
//
//class Calendar extends StatefulWidget {
//  final ValueChanged<database.Day> parentAction;
//  const Calendar({Key key, this.parentAction}) : super(key: key);
//
//  @override
//  _CalendarState createState() => new _CalendarState();
//}
//
//class _CalendarState extends State<Calendar> {
//  database.Day day = globals.today;
//
//  Future<database.Day> determineDay(DateTime date) async {
//    DateTime time = date;
//    //DateTime tdn;
//    if (time.hour < 12){
//      time = new DateTime(time.year, time.month, time.day - 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
//    }
//    String todayDate = main.dateTimeToString(time);
//    List<Map> result;
//
//    Database db = await database.DatabaseHelper.instance.database;
//    result = await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);
//
////  getDbResult(todayDate).then((dbResult) =>
////    result = dbResult);
//    database.Day day;
//    print(result);
//    List<int> dbListH, dbListM, dbListT;
//    if ((result == null) || (result.isEmpty)) {
//      day = new database.Day(date: todayDate, hourList: new List<int>(), minuteList: new List<int>(), typeList: new List<int>(), maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0, totalWaters: 0);
//      await db.insert(database.tableDays, day.toMap(),
//          conflictAlgorithm: ConflictAlgorithm.replace);
//      return day;
//    }
//
//    else {
//      print("result: ");
//      print(result[0]['hourList']);
//
//      if (result[0]['hourlist'] == null) {
//        dbListH = [];
//        dbListM = [];
//        dbListT = [];
//      }
//      else {
//        dbListH = new List<int>.from(result[0]['hourlist']);
//        dbListM = new List<int>.from(result[0]['minutelist']);
//        dbListT = new List<int>.from(result[0]['typelist']);
//
//      }
//
//
//      day = new database.Day(date: result[0]["day"], hourList: dbListH, minuteList: dbListM,
//          typeList: dbListT, maxBAC: result[0]['maxBAC'], waterAtMaxBAC: result[0]["WateratmaxBAC"],
//          totalDrinks: result[0]["totaldrinkcount"], totalWaters: result[0]["totalwatercount"]);
//
//      return day;
//    }
//  }
//
////  Future<database.Day> determineDay(DateTime date) async {
////    Database db = await database.DatabaseHelper.instance.database;
////    List<Map> result = await db.rawQuery(
////        'SELECT * FROM days WHERE day=?', [main.dateTimeToString(date)]);
////
////    if (result.isEmpty) {
////      day = new database.Day(
////          date: main.dateTimeToString(date),
////          hourList: [],
////          minuteList: [],
////          typeList: [],
////          maxBAC: 0.0,
////          waterAtMaxBAC: 0,
////          totalDrinks: 0,
////          totalWaters: 0);
////      return day;
////    } else {
////      day = new database.Day(
////          date: result[0]["day"],
////          hourList: new List<int>.from(result[0]['hourlist']),
////          minuteList: new List<int>.from(result[0]['minutelist']),
////          typeList: new List<int>.from(result[0]['typelist']),
////          maxBAC: result[0]['maxBAC'],
////          waterAtMaxBAC: result[0]["WateratmaxBAC"],
////          totalDrinks: result[0]["totaldrinkcount"],
////          totalWaters: result[0]["totalwatercount"]);
////      return day;
////    }
////  }
//
//  static Widget _soberIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFF0F086),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//            day,
//            style: TextStyle(color: Colors.black),
//          )));
//
//  static Widget _tipsyIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFF0BF72),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//            day,
//            style: TextStyle(color: Colors.black),
//          )));
//
//  static Widget _drunkIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFEB9800),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//            day,
//            style: TextStyle(color: Colors.black),
//          )));
//
//  static Widget _veryDrunkIcon(String day) => Container(
//      decoration: BoxDecoration(
//          color: Color(0xFFC53E3E),
//          borderRadius: BorderRadius.all(Radius.circular(1000))),
//      child: Center(
//          child: Text(
//            day,
//            style: TextStyle(color: Colors.black),
//          )));
//
//  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
//  static String noEventText = "No event here";
//  String calendarText = noEventText;
//  DateTime _currentDate = DateTime.now();
//
//  // Where BAC
//  // 0.00–0.03 = Sober; Yellow-Green
//  // 0.03—0.06 = Tipsy; Yellow
//  // 0.06-0.09 = Drunk; Orange
//  // 0.10-0.12 = Very Drunk; Red
//  List<DateTime> soberDates = [DateTime(2019, 10, 29)];
//  List<DateTime> tipsyDates = [DateTime(2019, 10, 30)];
//  List<DateTime> drunkDates = [DateTime(2019, 10, 31)];
//  List<DateTime> veryDrunkDates = [DateTime(2019, 11, 1)];
//
//  @override
//  Widget build(BuildContext context) {
//    for (int i = 0; i < soberDates.length; i++) {
//      _markedDateMap.add(
//          soberDates[i],
//          new Event(
//              date: soberDates[i],
//              icon: _soberIcon(soberDates[i].day.toString())));
//    }
//
//    for (int i = 0; i < tipsyDates.length; i++) {
//      _markedDateMap.add(
//          tipsyDates[i],
//          new Event(
//              date: tipsyDates[i],
//              icon: _tipsyIcon(tipsyDates[i].day.toString())));
//    }
//
//    for (int i = 0; i < drunkDates.length; i++) {
//      _markedDateMap.add(
//          drunkDates[i],
//          new Event(
//              date: drunkDates[i],
//              icon: _drunkIcon(drunkDates[i].day.toString())));
//    }
//
//    for (int i = 0; i < veryDrunkDates.length; i++) {
//      _markedDateMap.add(
//          veryDrunkDates[i],
//          new Event(
//              date: veryDrunkDates[i],
//              icon: _veryDrunkIcon(veryDrunkDates[i].day.toString())));
//    }
//
//    return CalendarCarousel(
//        selectedDateTime: _currentDate,
//        selectedDayButtonColor: Color(0xFF97B633),
//        selectedDayTextStyle: TextStyle(color: Colors.black),
//        height: 2 * MediaQuery.of(context).size.height / 5,
//        width: 4 * MediaQuery.of(context).size.width / 5,
//        daysHaveCircularBorder: null,
//        weekendTextStyle: TextStyle(color: Colors.black),
//        weekdayTextStyle: TextStyle(color: Colors.black),
//        todayTextStyle: TextStyle(color: Colors.black),
//        todayButtonColor: Color(0xFFC9D986),
//        iconColor: Colors.black,
//        headerTextStyle: TextStyle(
//          fontFamily: 'Montserrat',
//          color: Colors.black,
//        ),
//        minSelectedDate: DateTime(2019, 8, 1), // TODO: make these infinite!
//        maxSelectedDate: DateTime(2022, 12, 31),
//        markedDatesMap: _markedDateMap,
//        markedDateShowIcon: true,
//        markedDateIconMaxShown: 1,
//        markedDateMoreShowTotal: null,
//        markedDateIconBuilder: (event) {
//          return event.icon;
//        },
//        onDayPressed: (DateTime date, List<Event> events) {
//          this.setState(() => _currentDate = date);
//          determineDay(date);
//
//        });
//  }
//}
//
//class HistoryPage extends StatefulWidget {
//  @override
//  _HistoryPageState createState() => new _HistoryPageState();
//}
//
//class _HistoryPageState extends State<HistoryPage> {
//  database.Day day = globals.today;
//  double maxBACOnDay = 0;
//  int waterOnDay = 0;
//  List<String> times;
//  List<String> types;
//
//  _updateSelectedDay(database.Day day) {
//    setState(() {
//      this.day = day;
//      print(this.day.toString());
//    });
//  }
//
//  String typeToImageName(int type) {
//    if (type == 1) {
//      return 'assets/images/soloCup.png';
//    } else {
//      return 'assets/images/waterDrop.png';
//    }
//  }
//
//  String plantNameAtMax() {
//    int bac;
//    int water;
//
//    if (day.getMaxBac() >= 0.12) {
//      bac == 0.12;
//    } else {
//      bac == day.getMaxBac();
//    }
//
//    if (day.getWaterAtMax() >= 5) {
//      water == 5;
//    } else {
//      water == day.getWaterAtMax();
//    }
//    print('assets/images/plants/drink${bac}water$water.png');
//    return 'assets/images/plants/drink${bac}water$water.png';
//  }
//
//  String minutesToString(int minutes) {
//    if (minutes < 10) {
//      return '0$minutes';
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//        appBar: new AppBar(
//          title: new Text('Your Drinking History'),
//          backgroundColor: Color(0xFF97B633),
//        ),
//        body: Container(
//          // gives calendar space around it
//            padding: EdgeInsets.only(
//              top: MediaQuery.of(context).size.width / 20,
//              left: MediaQuery.of(context).size.width / 20,
//              right: MediaQuery.of(context).size.width / 20,
////                bottom: MediaQuery.of(context).size.width / 15
//            ),
//            color: Color(0xFFF2F2F2),
//            child: Column(children: [
//              Container(
//                // white background
//                  padding: EdgeInsets.only(
//                    left: MediaQuery.of(context).size.width / 15,
//                    right: MediaQuery.of(context).size.width / 15,
//                  ),
//                  decoration: BoxDecoration(
//                      borderRadius: BorderRadius.all(
//                        Radius.circular(10),
//                      ),
//                      color: Colors.white),
//                  child: Calendar(
//                    parentAction: _updateSelectedDay,
//                  )),
//              Container(
//                padding: EdgeInsets.only(
//                    top: MediaQuery.of(context).size.width / 15),
//                child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                Column(children: <Widget>[
//                    Image.asset(
//                    plantNameAtMax(),
//                width: MediaQuery.of(context).size.width / 3,
//              ),
//              Text(day.getDate()),
//            ]),
//            SingleChildScrollView(
//                child: ConstrainedBox(
//                    constraints: BoxConstraints(
//                      maxHeight:
//                      MediaQuery.of(context).size.height / 3,
//                      maxWidth:
//                      MediaQuery.of(context).size.width / 3,
//                    ),
//                    child: Table(
//                        defaultVerticalAlignment:
//                        TableCellVerticalAlignment.middle,
//                        children: [
//                    for (int i = 0;
//                    day.getHours().length > i;
//                    i++)
//                TableRow(children: [
//            TableCell(
//            child: Text(
//                day.getHours()[i].toString() +
//                ":" +
//                minutesToString(day.getMinutes()[i]))),
//    TableCell(
//    child: Container(
//    padding: EdgeInsets.all(5),
//    child: Image.asset(
//    typeToImageName(
//    day.getTypes()[i]),
//    height:
//    MediaQuery.of(context)
//        .size
//        .width /
//    9)))
//    ])
//    ])))
//    ]))
//    ])));
//  }
//}
//
////import 'package:flutter/material.dart';
////import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
////    show CalendarCarousel;
////import 'package:flutter_calendar_carousel/classes/event.dart';
////import 'package:flutter_calendar_carousel/classes/event_list.dart';
////import 'database_helpers.dart' as database;
////import 'main.dart' as main;
////import 'globals.dart' as globals;
////import 'package:sqflite/sqflite.dart';
////
////
////class Calendar extends StatefulWidget {
////  final ValueChanged<database.Day> parentAction;
////  const Calendar({Key key, this.parentAction}) : super(key: key);
////
////  @override
////  _CalendarState createState() => new _CalendarState();
////}
////
////class _CalendarState extends State<Calendar> {
////  database.Day day = globals.today;
////
////  Future<database.Day> determineDay() async {
////    DateTime time = DateTime.now();
////    //DateTime tdn;
////    if (time.hour < 12){
////      time = new DateTime(time.year, time.month, time.day - 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
////    }
////    String todayDate = main.dateTimeToString(time);
////    List<Map> result;
////
////    Database db = await database.DatabaseHelper.instance.database;
////    result = await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);
////
//////  getDbResult(todayDate).then((dbResult) =>
//////    result = dbResult);
////    database.Day day;
////    print(result);
////    List<int> dbListH, dbListM, dbListT;
////    if ((result == null) || (result.isEmpty)) {
////      day = new database.Day(date: todayDate, hourList: new List<int>(), minuteList: new List<int>(), typeList: new List<int>(), maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0, totalWaters: 0);
////      await db.insert(database.tableDays, day.toMap(),
////          conflictAlgorithm: ConflictAlgorithm.replace);
////      return day;
////    }
////
////    else {
////      print("result: ");
////      print(result[0]['hourList']);
////
////      if (result[0]['hourlist'] == null) {
////        dbListH = [];
////        dbListM = [];
////        dbListT = [];
////      }
////      else {
////        dbListH = new List<int>.from(result[0]['hourlist']);
////        dbListM = new List<int>.from(result[0]['minutelist']);
////        dbListT = new List<int>.from(result[0]['typelist']);
////
////      }
////
////
////      day = new database.Day(date: result[0]["day"], hourList: dbListH, minuteList: dbListM,
////          typeList: dbListT, maxBAC: result[0]['maxBAC'], waterAtMaxBAC: result[0]["WateratmaxBAC"],
////          totalDrinks: result[0]["totaldrinkcount"], totalWaters: result[0]["totalwatercount"]);
////
////      return day;
////    }
////  }
////
//////  Future<database.Day> determineDay(DateTime date) async {
//////    Database db = await database.DatabaseHelper.instance.database;
//////    List<Map> result = await db.rawQuery(
//////        'SELECT * FROM days WHERE day=?', [main.dateTimeToString(date)]);
//////
//////    if (result.isEmpty) {
//////      day = new database.Day(
//////          date: main.dateTimeToString(date),
//////          hourList: [],
//////          minuteList: [],
//////          typeList: [],
//////          maxBAC: 0.0,
//////          waterAtMaxBAC: 0,
//////          totalDrinks: 0,
//////          totalWaters: 0);
//////      return day;
//////    } else {
//////      day = new database.Day(
//////          date: result[0]["day"],
//////          hourList: new List<int>.from(result[0]['hourlist']),
//////          minuteList: new List<int>.from(result[0]['minutelist']),
//////          typeList: new List<int>.from(result[0]['typelist']),
//////          maxBAC: result[0]['maxBAC'],
//////          waterAtMaxBAC: result[0]["WateratmaxBAC"],
//////          totalDrinks: result[0]["totaldrinkcount"],
//////          totalWaters: result[0]["totalwatercount"]);
//////      return day;
//////    }
//////  }
////
////  static Widget _soberIcon(String day) => Container(
////      decoration: BoxDecoration(
////          color: Color(0xFFF0F086),
////          borderRadius: BorderRadius.all(Radius.circular(1000))),
////      child: Center(
////          child: Text(
////        day,
////        style: TextStyle(color: Colors.black),
////      )));
////
////  static Widget _tipsyIcon(String day) => Container(
////      decoration: BoxDecoration(
////          color: Color(0xFFF0BF72),
////          borderRadius: BorderRadius.all(Radius.circular(1000))),
////      child: Center(
////          child: Text(
////        day,
////        style: TextStyle(color: Colors.black),
////      )));
////
////  static Widget _drunkIcon(String day) => Container(
////      decoration: BoxDecoration(
////          color: Color(0xFFEB9800),
////          borderRadius: BorderRadius.all(Radius.circular(1000))),
////      child: Center(
////          child: Text(
////        day,
////        style: TextStyle(color: Colors.black),
////      )));
////
////  static Widget _veryDrunkIcon(String day) => Container(
////      decoration: BoxDecoration(
////          color: Color(0xFFC53E3E),
////          borderRadius: BorderRadius.all(Radius.circular(1000))),
////      child: Center(
////          child: Text(
////        day,
////        style: TextStyle(color: Colors.black),
////      )));
////
////  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
////  static String noEventText = "No event here";
////  String calendarText = noEventText;
////  DateTime _currentDate = DateTime.now();
////
////  // Where BAC
////  // 0.00–0.03 = Sober; Yellow-Green
////  // 0.03—0.06 = Tipsy; Yellow
////  // 0.06-0.09 = Drunk; Orange
////  // 0.10-0.12 = Very Drunk; Red
////  List<DateTime> soberDates = [DateTime(2019, 10, 29)];
////  List<DateTime> tipsyDates = [DateTime(2019, 10, 30)];
////  List<DateTime> drunkDates = [DateTime(2019, 10, 31)];
////  List<DateTime> veryDrunkDates = [DateTime(2019, 11, 1)];
////
////  @override
////  Widget build(BuildContext context) {
////    for (int i = 0; i < soberDates.length; i++) {
////      _markedDateMap.add(
////          soberDates[i],
////          new Event(
////              date: soberDates[i],
////              icon: _soberIcon(soberDates[i].day.toString())));
////    }
////
////    for (int i = 0; i < tipsyDates.length; i++) {
////      _markedDateMap.add(
////          tipsyDates[i],
////          new Event(
////              date: tipsyDates[i],
////              icon: _tipsyIcon(tipsyDates[i].day.toString())));
////    }
////
////    for (int i = 0; i < drunkDates.length; i++) {
////      _markedDateMap.add(
////          drunkDates[i],
////          new Event(
////              date: drunkDates[i],
////              icon: _drunkIcon(drunkDates[i].day.toString())));
////    }
////
////    for (int i = 0; i < veryDrunkDates.length; i++) {
////      _markedDateMap.add(
////          veryDrunkDates[i],
////          new Event(
////              date: veryDrunkDates[i],
////              icon: _veryDrunkIcon(veryDrunkDates[i].day.toString())));
////    }
////
////    return CalendarCarousel(
////        selectedDateTime: _currentDate,
////        selectedDayButtonColor: Color(0xFF97B633),
////        selectedDayTextStyle: TextStyle(color: Colors.black),
////        height: 2 * MediaQuery.of(context).size.height / 5,
////        width: 4 * MediaQuery.of(context).size.width / 5,
////        daysHaveCircularBorder: null,
////        weekendTextStyle: TextStyle(color: Colors.black),
////        weekdayTextStyle: TextStyle(color: Colors.black),
////        todayTextStyle: TextStyle(color: Colors.black),
////        todayButtonColor: Color(0xFFC9D986),
////        iconColor: Colors.black,
////        headerTextStyle: TextStyle(
////          fontFamily: 'Montserrat',
////          color: Colors.black,
////        ),
////        minSelectedDate: DateTime(2019, 8, 1), // TODO: make these infinite!
////        maxSelectedDate: DateTime(2022, 12, 31),
////        markedDatesMap: _markedDateMap,
////        markedDateShowIcon: true,
////        markedDateIconMaxShown: 1,
////        markedDateMoreShowTotal: null,
////        markedDateIconBuilder: (event) {
////          return event.icon;
////        },
////        onDayPressed: (DateTime date, List<Event> events) {
////          this.setState(() => _currentDate = date);
////          determineDay();
////        });
////  }
////}
////
////class HistoryPage extends StatefulWidget {
////  @override
////  _HistoryPageState createState() => new _HistoryPageState();
////}
////
////class _HistoryPageState extends State<HistoryPage> {
////  database.Day day = globals.today;
////  double maxBACOnDay = 0;
////  int waterOnDay = 0;
////  List<String> times;
////  List<String> types;
////
//////  _updateSelectedDay(database.Day day) {
//////    setState(() {
//////      this.day = day;
//////      print(this.day.toString());
//////    });
//////  }
////
////  String typeToImageName(int type) {
////    if (type == 1) {
////      return 'assets/images/soloCup.png';
////    } else {
////      return 'assets/images/waterDrop.png';
////    }
////  }
////
////  String plantNameAtMax() {
////    int bac;
////    int water;
////
////    if (day.getMaxBac() >= 0.12) {
////      bac == 0.12;
////    } else {
////      bac == day.getMaxBac();
////    }
////
////    if (day.getWaterAtMax() >= 5) {
////      water == 5;
////    } else {
////      water == day.getWaterAtMax();
////    }
////    print('assets/images/plants/drink${bac}water$water.png');
////    return 'assets/images/plants/drink${bac}water$water.png';
////  }
////
////  String minutesToString(int minutes) {
////    if (minutes < 10) {
////      return '0$minutes';
////    }
////  }
////
////  @override
////  Widget build(BuildContext context) {
////    return new Scaffold(
////        appBar: new AppBar(
////          title: new Text('Your Drinking History'),
////          backgroundColor: Color(0xFF97B633),
////        ),
////        body: Container(
////            // gives calendar space around it
////            padding: EdgeInsets.only(
////              top: MediaQuery.of(context).size.width / 20,
////              left: MediaQuery.of(context).size.width / 20,
////              right: MediaQuery.of(context).size.width / 20,
//////                bottom: MediaQuery.of(context).size.width / 15
////            ),
////            color: Color(0xFFF2F2F2),
////            child: Column(children: [
////              Container(
////                  // white background
////                  padding: EdgeInsets.only(
////                    left: MediaQuery.of(context).size.width / 15,
////                    right: MediaQuery.of(context).size.width / 15,
////                  ),
////                  decoration: BoxDecoration(
////                      borderRadius: BorderRadius.all(
////                        Radius.circular(10),
////                      ),
////                      color: Colors.white),
////                  child: Calendar(
//////                    parentAction: _updateSelectedDay,
////                  )),
////              Container(
////                  padding: EdgeInsets.only(
////                      top: MediaQuery.of(context).size.width / 15),
////                  child: Row(
////                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
////                      children: <Widget>[
////                        Column(children: <Widget>[
////                          Image.asset(
////                            plantNameAtMax(),
////                            width: MediaQuery.of(context).size.width / 3,
////                          ),
////                          Text(day.getDate()),
////                        ]),
////                        SingleChildScrollView(
////                            child: ConstrainedBox(
////                                constraints: BoxConstraints(
////                                  maxHeight:
////                                      MediaQuery.of(context).size.height / 3,
////                                  maxWidth:
////                                      MediaQuery.of(context).size.width / 3,
////                                ),
////                                child: Table(
////                                    defaultVerticalAlignment:
////                                        TableCellVerticalAlignment.middle,
////                                    children: [
////                                      for (int i = 0;
////                                          day.getHours().length > i;
////                                          i++)
////                                        TableRow(children: [
////                                          TableCell(
////                                              child: Text(
////                                                  day.getHours()[i].toString() +
////                                                      ":" +
////                                                      minutesToString(day.getMinutes()[i]))),
////                                          TableCell(
////                                              child: Container(
////                                                  padding: EdgeInsets.all(5),
////                                                  child: Image.asset(
////                                                      typeToImageName(
////                                                          day.getTypes()[i]),
////                                                      height:
////                                                          MediaQuery.of(context)
////                                                                  .size
////                                                                  .width /
////                                                              9)))
////                                        ])
////                                    ])))
////                      ]))
////            ])));
////  }
////}
