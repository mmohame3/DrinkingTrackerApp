//import 'package:calendarro/date_utils.dart';
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
//    String todayDate = main.dateTimeToString(DateTime.now());

    Database db = await database.DatabaseHelper.instance.database;
    List<Map> result = await db.rawQuery('SELECT * FROM days WHERE day=?', [date]);
//    database.Day day;

    if (result.isEmpty) {
      day = new database.Day(date: main.dateTimeToString(date), hourList: [], minuteList: [], typeList: [], maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0, totalWaters: 0);
      await db.insert(database.tableDays, day.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      print(day); // TODO: remove
      return day;
    }
    else {
      day = new database.Day(date: result[0]["day"], hourList: new List<int>.from(result[0]['hourlist']), minuteList: new List<int>.from(result[0]['minutelist']),
          typeList: new List<int>.from(result[0]['typelist']), maxBAC: result[0]['maxBAC'], waterAtMaxBAC: result[0]["WateratmaxBAC"],
          totalDrinks: result[0]["totaldrinkcount"], totalWaters: result[0]["totalwatercount"]);
      print(day); // TODO: remove
      return day;
    }
  }

  static Widget _veryDrunkIcon(String day) => Container(
      decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Center(
          child: Text(
        day,
        style: TextStyle(color: Colors.black),
      )));

  EventList<Event> _markedDateMap = new EventList<Event>(events: {});
  static String noEventText = "No event here";
  String calendarText = noEventText;
  DateTime _currentDate = DateTime.now();
  List<DateTime> veryDrunkDates = [
    DateTime(2019, 11, 1),
    DateTime(2019, 10, 31)
  ];

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < veryDrunkDates.length; i++) {
      _markedDateMap.add(
          veryDrunkDates[i],
          new Event(
              date: veryDrunkDates[i],
              title: 'Event 5',
              icon: _veryDrunkIcon(veryDrunkDates[i].day.toString())));
    }
    return CalendarCarousel(
      selectedDateTime: _currentDate,
      selectedDayButtonColor: Color(0xFF97B633),
      selectedDayTextStyle: TextStyle(color: Colors.black),
      weekdayTextStyle: TextStyle(color: Colors.black),
      weekendTextStyle: TextStyle(color: Colors.black),
      height: 325.0,
      width: 300,
      daysHaveCircularBorder: null,
      todayTextStyle: TextStyle(color: Colors.black),
      todayButtonColor: Color(0xFFC9D986),
      iconColor: Colors.black,
      headerTextStyle: TextStyle(fontFamily: 'Montserrat', color: Colors.black),
      markedDatesMap: _markedDateMap,
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateMoreShowTotal: null,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      onDayPressed: (DateTime date, List<Event> events) {
        this.setState(() => refresh(date));
        determineDay(date);
      },
    );
  }

  void refresh(DateTime date) {
    _currentDate = date;
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Your Drinking History'),
          backgroundColor: Color(0xFF97B633),
        ),
        body: Container(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            color: Color(0xFFE6E7E8),
            child: Column(children: [
              Container( // white background
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
//                  color: Colors.white,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),),
                      color: Colors.white),
                  child: Calendar(
                    parentAction: _updateSelectedDay,
                  )),
              Container(
                padding: EdgeInsets.only(top: 20),
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(children: <Widget>[
                      Image.asset(
                        'assets/images/plants/drink1water2.png',
//                        'assets/images/plants/drink${day.getMaxBac}water${day.getWaterAtMax}.png',
                        width: 100,
                      ),
                      Text(day.getDate()),
                    ]),
                    SingleChildScrollView(
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 100,
                              maxWidth: 100,
                            ),
                            child: Table(children: [
                              for (int i = 0; i < day.getHours().length; i++)
                                TableRow(children: [
                                  TableCell(
                                      child: Text(day.getHours()[i].toString() +
                                          ":" +
                                          day.getMinutes()[i].toString())),
                                  TableCell(
                                      child: Text(day.getTypes()[i].toString()))
                                ])
                            ])))
                  ]))
            ])));
  }
}
