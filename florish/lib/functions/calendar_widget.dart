import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:Florish/home/home_screen_widgets.dart' as mainPage;
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/database_helper.dart' as database;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:Florish/models/day_model.dart';
import 'package:Florish/pages/calendar_page.dart';


/// Generates a Calendar Widget.
///
/// [parentAction] is called when a user selects a day on the calendar. Then,
/// the calendar updates its display to show information about the selected day.
class Calendar extends StatefulWidget {
  final ValueChanged<Day> parentAction;
  const Calendar({Key key, this.parentAction}) : super(key: key);

  @override
  _CalendarState createState() => new _CalendarState();
}

class _CalendarState extends State<Calendar> {
  _CalendarState() {
    determineDay(DateTime.now()).then((calendarSelectedDay) => setState(() {
      globals.today = calendarSelectedDay;
    }));
  }

  /// Determines which day is selected and returns the given Day object as a Future
  Future<Day> determineDay(DateTime date) async {
    Database db = await database.DatabaseHelper.instance.database;
    String selectedDate = mainPage.dateTimeToString(date);
    List<Map> result =
    await db.rawQuery('SELECT * FROM days WHERE day=?', [selectedDate]);

    Day day;
    double yesterHyd;

    if (result == null || result.isEmpty) {
      Future<List> yesterInfo = mainPage.getYesterInfo();
      yesterInfo.then((list) {
        yesterHyd = list[1];
      });
      yesterHyd ??= 0.0;

      day = new Day(
          date: selectedDate,
          hourList: new List<int>(),
          minuteList: new List<int>(),
          typeList: new List<int>(),
          constantBACList: new List<int>(),
          maxBAC: 0.0,
          waterAtMaxBAC: 0,
          totalDrinks: 0,
          totalWaters: 0,
          hydratio: 0.0,
          yesterHydratio: yesterHyd,
          lastBAC: 0.0);

      await db.insert(tableDays, day.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      return day;
    } else {
// alternate (read: better) way #2
      day = Day.fromMap(result[0]);

      day.hourList ??= new List<int>();
      day.minuteList ??= new List<int>();
      day.typeList ??= new List<int>();
      day.constantBACList ??= new List<int>();
      day.hourList = new List<int>.from(day.hourList);
      day.minuteList = new List<int>.from(day.minuteList);
      day.typeList = new List<int>.from(day.typeList);

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
  List<DateTime> soberDates = [];
  List<DateTime> tipsyDates = [];
  List<DateTime> drunkDates = [];
  List<DateTime> veryDrunkDates = [];

  /// Returns a list of all Day objects in the database
  Future<List<Day>> _makeDayList() async {
    List<Day> dayList = List<Day>();

    Database db = await database.DatabaseHelper.instance.database;
    List<Map> result = await db.rawQuery('SELECT * FROM days');
    result.forEach((map) => dayList.add(Day.fromMap(map)));
    return dayList;
  }

  /// Sorts days into different color ranges depending on the maxBac of that day
  _sortDates() async {
    double threeQuartersMax = (3 * globals.maxBAC) / 4;
    double halfMax = globals.maxBAC / 2;
    double quarterMax = globals.maxBAC / 4;

    List<Day> dayList = await _makeDayList();

    for (int i = 0; i < dayList.length; i++)
      if (dayList[i].maxBAC > 0.00 && dayList[i].maxBAC < quarterMax)
        soberDates.add(stringToDateTime(dayList[i].getDate()));
      else if (dayList[i].maxBAC >= quarterMax && dayList[i].maxBAC < halfMax)
        tipsyDates.add(stringToDateTime(dayList[i].getDate()));
      else if (dayList[i].maxBAC >= halfMax &&
          dayList[i].maxBAC < threeQuartersMax)
        drunkDates.add(stringToDateTime(dayList[i].getDate()));
      else if (dayList[i].maxBAC >= threeQuartersMax)
        veryDrunkDates.add(stringToDateTime(dayList[i].getDate()));
  }

  @override
  /// Generates a [CalendarCarousel] that displays dates in different colors
  /// according to sortDates()
  Widget build(BuildContext context) {
    _sortDates();
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
        selectedDayBorderColor: Colors.black,
        selectedDayButtonColor: Colors.white,
        selectedDayTextStyle: TextStyle(color: Colors.black),
        height: 19 * MediaQuery.of(context).size.height / 48,
        daysHaveCircularBorder: true,
        weekendTextStyle: TextStyle(color: Colors.black),
        weekdayTextStyle: TextStyle(color: Colors.black),
        todayTextStyle: TextStyle(color: Colors.black),
        todayButtonColor: Colors.white,
        todayBorderColor: Colors.black26,
        iconColor: Colors.black,
        headerTextStyle: TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.black,
        ),
        headerMargin: EdgeInsets.all(5),
        markedDateIconMargin: 0,
        markedDatesMap: _markedDateMap,
        markedDateShowIcon: true,
        markedDateIconMaxShown: 1,
        markedDateMoreShowTotal: null,
        markedDateIconBuilder: (event) {
          return event.icon;
        },
        onDayPressed: (DateTime date, List<Event> events) {
          this.setState(() => _currentDate =
              date); // changes the day that the calendar shows as selected
          determineDay(date).then((day) {
            widget.parentAction(day);
          });
        });
  }

  /// Converts the string stored in a Day object to a DateTime object
  DateTime stringToDateTime(String date) {
    List<String> dateObjects = date.split("/");
    String month = dateObjects[0];
    String day = minutesStringToString(dateObjects[1]);
    String year = dateObjects[2];

    String dateStringToConvert = year + month + day;
    DateTime parsedDate = DateTime.parse(dateStringToConvert);

    return parsedDate;
  }
}