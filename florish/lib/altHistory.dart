import 'package:flutter/material.dart';
import 'database_helpers.dart' as database;
import 'package:sqflite/sqflite.dart';
import 'globals.dart' as globals;

class AltHistoryPage extends StatefulWidget {
  @override
  _AltHistoryPageState createState() => new _AltHistoryPageState();
}

class _AltHistoryPageState extends State<AltHistoryPage> {
  List<Widget> widgetList = [];

  String getWeekday(String date) {
    String weekday;

    List<String> dateObjects = date.split("/");
    String month = dateObjects[0];
    String day = dateObjects[1];
    String year = dateObjects[2];

    String dateStringToConvert = year + day + month;
    DateTime parsedDate = DateTime.parse(dateStringToConvert);

    int weekdayInt = parsedDate.weekday;
    if (weekdayInt == 1) {
      weekday = 'MONDAY';
    } else if (weekdayInt == 2) {
      weekday = 'TUESDAY';
    } else if (weekdayInt == 3) {
      weekday = 'WEDNESDAY';
    } else if (weekdayInt == 4) {
      weekday = 'THURSDAY';
    } else if (weekdayInt == 5) {
      weekday = 'FRIDAY';
    } else if (weekdayInt == 6) {
      weekday = 'SATURDAY';
    } else if (weekdayInt == 7) {
      weekday = 'SUNDAY';
    }

    return weekday;
  }

  String displayDate(String date) {
    String monthName;

    List<String> dateObjects = date.split("/");
    String month = dateObjects[0];
    String day = dateObjects[1];
    String year = dateObjects[2];

    String dateStringToConvert = year + day + month;
    DateTime parsedDate = DateTime.parse(dateStringToConvert);

    int monthInt = parsedDate.month;
    if (monthInt == 1) {
      monthName = 'January';
    } else if (monthInt == 2) {
      monthName = 'February';
    } else if (monthInt == 3) {
      monthName = 'March';
    } else if (monthInt == 4) {
      monthName = 'April';
    } else if (monthInt == 5) {
      monthName = 'May';
    } else if (monthInt == 6) {
      monthName = 'June';
    } else if (monthInt == 7) {
      monthName = 'July';
    } else if (monthInt == 8) {
      monthName = 'August';
    } else if (monthInt == 9) {
      monthName = 'September';
    } else if (monthInt == 10) {
      monthName = 'October';
    } else if (monthInt == 11) {
      monthName = 'November';
    } else if (monthInt == 12) {
      monthName = 'December';
    }

    return '$monthName ${parsedDate.day}, ${parsedDate.year}';
  }

  Widget makeWidget(database.Day day) {
    return ExpansionTile(
        initiallyExpanded: false,
        backgroundColor: Colors.white,
        title: Container(
            padding: EdgeInsets.only(top: 15, bottom: 15, left: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('${getWeekday(day.getDate())}',
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(displayDate(day.getDate()),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black))),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Image.asset(
                                'assets/images/soloCup.png',
                                width: 20,
                              ),
                              Text(
                                  '    ' +
                                      day.getTotalDrinks().toString() +
                                      '          ',
                                  style: TextStyle(
                                      color:
                                          Colors.black)), //space this with flex
                              Image.asset(
                                'assets/images/waterDrop.png',
                                width: 20,
                              ),
                              Text('    ' + day.getTotalWaters().toString(),
                                  style: TextStyle(color: Colors.black))
                            ]),
                          ])
                    ],
                  ),
                  Image.asset('assets/images/plants/drink0water3.png',
                      height: 80)
                ])),
        children: <Widget>[
          // TODO: fill drop-down with more information
        ]);
  }

  _makeDayList() async {
    List<database.Day> dayList;

    Database db = await database.DatabaseHelper.instance.database;
    List<Map> result = await db.query(database.DatabaseHelper.tableDays);
    result.forEach(
        (map) => dayList.add(database.Day.fromMap(map)));
    return dayList;
  }

  _updateWidgetList() async {
    List<database.Day> dayList = await _makeDayList();
    dayList.forEach((day) => widgetList.add(makeWidget(day)));
  }

  @override
  initState() {
    super.initState();
    _updateWidgetList();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Your Drinking History'),
          backgroundColor: Color(0xFF97B633),
        ),
        backgroundColor: Color(0xFFF2F2F2),
        body: Container(
            padding: EdgeInsets.only(top: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [makeWidget(globals.today)])));
  }
}
