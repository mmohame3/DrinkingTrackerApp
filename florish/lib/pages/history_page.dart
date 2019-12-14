import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Florish/database_helper.dart' as database;
import 'package:Florish/globals.dart' as globals;
import 'package:sqflite/sqflite.dart';
import 'package:Florish/home/home_screen_widgets.dart' as mainPage;
import 'package:Florish/models/day_model.dart';

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

  Future<List<Day>> _makeDayList() async {
    List<Day> dayList = List<Day>();

    Database db = await database.DatabaseHelper.instance.database;
    List<Map> result = await db.rawQuery('SELECT * FROM days');
    result.forEach((map) => dayList.add(Day.fromMap(map)));
    return dayList;
  }

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

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Day day = globals.today;
  double maxBACOnDay = 0;
  int waterOnDay = 0;
  List<String> times;
  List<String> types;

  _updateSelectedDay(Day day) {
    setState(() {
      this.day = day;
    });
  }

  Widget dataReturn() {
    return Container(
          padding: EdgeInsets.only(top: 10),
          child: Column(children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                      children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.width / 70),
                        height: MediaQuery.of(context).size.height / 4,
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          'assets/plants/drink${bacToPlant(day.getMaxBac())}water${day.getWaterAtMax()}.png',
                          width: 7 * MediaQuery.of(context).size.width / 24,
                        )),
                    Row(children: <Widget> [
                      Text('${day.totalDrinks} ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${drinkPlural(day)}  |  '),
                      Text('${day.totalWaters} ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${waterPlural(day)}')
                      ])
                  ]),
                  SingleChildScrollView(
                      child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height / 4,
                            maxWidth: MediaQuery.of(context).size.width / 4,
                          ),
                          child: generateTable(day)))
                ])
          ]));
  }

  Widget graphReturn() {
    return Container(
          height: MediaQuery.of(context).size.height / 2,
//          child: Column(children: <Widget> [
//            Text('Your BAC over Time'),
            child: BacChart(day: day)
//        ])
    );
  }

  Widget historyWidgetReturn() {
    Widget historyWidget;
    if (day.typeList.length > 0) {
      historyWidget =
          CarouselWithIndicator(widgetList: [dataReturn(), graphReturn()]);
    } else {
      historyWidget = Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 4),
          child: Text(
            'No data for this day',
            style: TextStyle(color: Colors.grey[600]),
          ));
    }
    return historyWidget;
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
            ),
            color: Color(0xFFF2F2F2),
            child: Column(children: [
              Container(
                  // white background
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 20,
                    right: MediaQuery.of(context).size.width / 20,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white),
                  child: Calendar(
                    parentAction: _updateSelectedDay,
                  )),
              SizedBox(height: MediaQuery.of(context).size.height / 70),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 5 * MediaQuery.of(context).size.height / 12,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white),
                  child: Column(children: [
                    Container(
                        padding: EdgeInsets.only(top: 15, bottom: 5),
                        child: Text(dateToString(day.getDate()),
                            style: TextStyle(fontSize: 16, letterSpacing: 1))),
                    historyWidgetReturn()
                  ]))
            ])));
  }
}

class CarouselWithIndicator extends StatefulWidget {
  final List<Widget> widgetList;
  const CarouselWithIndicator({Key key, this.widgetList}) : super(key: key);

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          widget.widgetList,
          (index, url) {
            return Container(
              width: 4.0,
              height: 4.0,
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 3.0),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.3)),
            );
          },
        ),
      ),
      CarouselSlider(
        items: widget.widgetList,
        aspectRatio: MediaQuery.of(context).size.width /
            (7 * MediaQuery.of(context).size.height / 20),
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
    ]);
  }
}

class BacChart extends StatelessWidget {
  final Day day;
  const BacChart({Key key, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      _createData(),
      animate: false,
      defaultRenderer: new charts.LineRendererConfig(includePoints: true),
        customSeriesRenderers: [
          new charts.PointRendererConfig(
              customRendererId: 'customPoint')
        ]);
  }

  /// Builds the list of DateTimes and BACs for the graph.
  ///
  /// returns the TimeSeries with these values.
  List<charts.Series<TimeSeriesBac, DateTime>> _createData() {
    List<TimeSeriesBac> bacData = new List<TimeSeriesBac>();
    List<TimeSeriesBac> drinkData = new List<TimeSeriesBac>();

    /// Gets the list of indices of the values in the database
    /// corresponding to drinks (not waters).
    List<int> justDrinksIndices = getDrinkIndices();

    /// Checks if there were drinks on this day
    if (justDrinksIndices.length > 0) {
      DateTime currentDrinkDateTime;
      int currentDrinkMinutes;
      int i = 0;
      String date = day.getDate();
      int year = getYear(date);
      int month = getMonth(date);
      int dayNum = getDay(date);

      while (i < justDrinksIndices.length) {

        currentDrinkDateTime = getCurrentDrinkDateTime(i, justDrinksIndices, year, month, dayNum);

        bacData.add(new TimeSeriesBac(
            currentDrinkDateTime,
            day.constantBACList[i] / 100));

        currentDrinkMinutes = (day.hourList[justDrinksIndices[i]]) * 60 +
            day.minuteList[justDrinksIndices[i]];

        /// If it's on the last drink, the loop stops here
        if (i + 1 == justDrinksIndices.length) {
          break;
        }

        /// Uses the time difference between the current drink and
        /// the next to calculate how far the BAC dropped over that
        /// period of time.
        double timeDifferenceHours = getCurrentAndNextTimeDiff(i, justDrinksIndices);
        if (getNextDrinkDateTime(i, justDrinksIndices, year, month, dayNum).isAfter(getTimeWhenBacHitZero(i, currentDrinkDateTime))){
          /// add point where bac first fell to 0
          DateTime whenBacHitZero = getTimeWhenBacHitZero(i, currentDrinkDateTime);
          bacData.add(new TimeSeriesBac(whenBacHitZero, 0));
        }

        DateTime nextDrinkDateTime = getNextDrinkDateTime(i, justDrinksIndices, year, month, dayNum);
        double bacBeforeNextDrink = (day.constantBACList[i] / 100) - (timeDifferenceHours * 0.15);
        bacBeforeNextDrink = bacBeforeNextDrink < 0 ? 0.0 : bacBeforeNextDrink;

        /// The dropped BAC is added to the TimeSeries before the
        /// next drink (at the DateTime of the next drink)
        bacData.add(new TimeSeriesBac(
            nextDrinkDateTime, bacBeforeNextDrink));

        i++;
      }

      /// After [justDrinkIndices] has been looped over, points are
      /// added at the user's current BAC and where their BAC first
      /// fell to zero (if needed)
      DateTime currentTime = DateTime.now();
      double lastTimeDifferenceHours;

      /// if [day] is a past day, the [currentTime] is set to the [globals.resetTime]
      /// and the [timeDifference] is the time between the last drink and the reset.
      if (currentTime.hour >= globals.resetTime &&
          mainPage.dateTimeToString(currentTime) != day.getDate()){
        lastTimeDifferenceHours = getResetTimeDifference(currentDrinkMinutes) / 60;
        currentTime = new DateTime(year, month, dayNum, globals.resetTime, 0, 0).add(Duration(days: 1));
      }

      /// if [day] is still the current day (in reality), then [timeDifference]
      /// is set to the time between the last drink and now.
      else {
        lastTimeDifferenceHours = getCurrentTimeDifference(currentDrinkMinutes) / 60;
      }

      double currentBAC = (day.constantBACList[i] / 100) -
          (lastTimeDifferenceHours * 0.15);

      /// if the [currentBAC] has fallen to zero, then another point is added
      /// at the time when it first fell to zero.
      if (currentBAC < 0){
        /// given the slope (0.15) and the last coordinate we get [minutesForBacToFallToZero]
        DateTime whenBacHitZero = getTimeWhenBacHitZero(i, currentDrinkDateTime);
        bacData.add(new TimeSeriesBac(whenBacHitZero, 0));
        currentBAC = 0;
      }

      bacData.add(new TimeSeriesBac(currentTime, currentBAC));
    }

    return [
      new charts.Series<TimeSeriesBac, DateTime>(
        id: 'BAC',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesBac bac, _) => bac.time,
        measureFn: (TimeSeriesBac bac, _) => bac.bac,
        data: bacData,
      ),
    ];
  }

  /// Calculate the DateTime when BAC would fall to zero
  /// after a particular drink at [drinkListIndex] and
  /// [currentDrinkDateTime].
  ///
  /// The [hoursForBacToFallToZero] calculation is from
  /// slope = (y1-y2)/(x1-x2) where slope = -.15,
  /// y1 = bac, x1 = [currentDrinkDateTime], and y2 = 0
  DateTime getTimeWhenBacHitZero(int drinkListIndex, DateTime currentDrinkDateTime){
    double hoursForBacToFallToZero = ((day.constantBACList[drinkListIndex] / 100) / 0.15);
    int minutesForBacToFallToZero = (hoursForBacToFallToZero * 60).round();
    DateTime xInterceptBAC = currentDrinkDateTime.add(Duration(minutes: minutesForBacToFallToZero));

    return xInterceptBAC;
  }
  /// Returns the DateTime corresponding to the drink at
  /// position [drinkListIndex] in [justDrinksIndices]
  DateTime getCurrentDrinkDateTime(int drinkListIndex, List<int> justDrinksIndices, int year, int month, int dayNum){
    DateTime currentDrinkDateTime = DateTime(
        year, month, dayNum, day.hourList[justDrinksIndices[drinkListIndex]],
        day.minuteList[justDrinksIndices[drinkListIndex]], 0);

    /// adjusts [currentDrinkDateTime] based on [globals.resetTime]
    currentDrinkDateTime =
    day.hourList[justDrinksIndices[drinkListIndex]] < globals.resetTime ?
    currentDrinkDateTime.add(Duration(days: 1))
        : currentDrinkDateTime;

    return currentDrinkDateTime;
  }

  /// Returns the DateTime corresponding to the drink at
  /// position [i] + 1 in [justDrinksIndices]
  DateTime getNextDrinkDateTime(int i, List<int> justDrinksIndices, int year, int month, int dayNum) {
    DateTime nextDrinkDateTime = DateTime(
        year, month, dayNum, day.hourList[justDrinksIndices[i + 1]],
        day.minuteList[justDrinksIndices[i + 1]], 0);

    /// adjusts [nextDrinkDateTime] based on [globals.resetTime]
    nextDrinkDateTime =
    day.hourList[justDrinksIndices[i + 1]] < globals.resetTime ?
    nextDrinkDateTime.add(Duration(days: 1))
        : nextDrinkDateTime;

    return nextDrinkDateTime;
  }

  /// Returns the difference between the drink at position [i]
  /// and that at [i] + 1 in hours.
  getCurrentAndNextTimeDiff(int i, List<int> justDrinksIndices){
    int currentDrinkMinutes = (day.hourList[justDrinksIndices[i]]) * 60 +
        day.minuteList[justDrinksIndices[i]];
    int nextDrinkMinutes = (day.hourList[justDrinksIndices[i + 1]] * 60) +
        day.minuteList[justDrinksIndices[i + 1]];

    /// If [currentDrinkMinutes] > [nextDrinkMinutes] then the
    /// "next drink" occurred after midnight and [timeDifferenceHours]
    /// is adjusted based on that.
    double timeDifferenceHours =
    currentDrinkMinutes > nextDrinkMinutes
        ? ((1440 - currentDrinkMinutes) + nextDrinkMinutes) / 60
        : (nextDrinkMinutes - currentDrinkMinutes) / 60;

    return timeDifferenceHours;
  }


  /// Gets the list of indices corresponding to drinks
  ///
  /// These indices correspond to just the day's drinks
  /// across [day.typeList], [day.hourList], and [day.minuteList]
  List<int> getDrinkIndices(){
    List<int> justDrinksIndices = new List<int>();
    for (int j = 0; j < day.typeList.length; j++){
      if (day.typeList[j] == 1) {
        justDrinksIndices.add(j);
      }
    }
    return justDrinksIndices;
  }

  /// The time difference between [currentDrinkMinutes] and
  /// the day's [globals.resetTime] is calculated and returned
  /// in minutes.
  int getResetTimeDifference(int currentDrinkMinutes){
    int resetTimeInMinutes = globals.resetTime * 60;

    int timeBetweenLastDrinkAndReset;
    if (currentDrinkMinutes > resetTimeInMinutes) {
      timeBetweenLastDrinkAndReset = resetTimeInMinutes + (1440 - currentDrinkMinutes);
    }
    else {
      timeBetweenLastDrinkAndReset = resetTimeInMinutes - currentDrinkMinutes;
    }

    return timeBetweenLastDrinkAndReset;
  }

  /// The time difference between [currentDrinkMinutes] and
  /// the day's the current time is calculated and returned
  /// in minutes.
  int getCurrentTimeDifference(int currentDrinkMinutes){
    DateTime currentTime = DateTime.now();
    int currentTimeMinutes = (currentTime.hour) * 60 + currentTime.minute;

    int timeBetweenLastDrinkAndNow;
    if (currentDrinkMinutes > currentTimeMinutes) {
      timeBetweenLastDrinkAndNow = currentTimeMinutes + (1440 - currentDrinkMinutes);
    }
    else {
      timeBetweenLastDrinkAndNow = currentTimeMinutes - currentDrinkMinutes;
    }

    return timeBetweenLastDrinkAndNow;
  }
}

class TimeSeriesBac {
  final DateTime time;
  final double bac;

  TimeSeriesBac(this.time, this.bac);
}

String drinkPlural(Day day) {
  if (day.totalDrinks > 1) {
    return 'drinks';
  } else if (day.totalDrinks == 1) {
    return 'drink';
  }
}

String waterPlural(Day day) {
  if (day.totalWaters > 1) {
    return 'waters';
  } else if (day.totalWaters == 1) {
    return 'water';
  }
}

String minutesIntToString(int minutes) {
  String minuteString = minutes.toString();
  if (minuteString.length < 2) {
    minuteString = '0' + minutes.toString()[0];
  }
  return minuteString;
}

String minutesStringToString(String minutes) {
  String minuteString = minutes.toString();
  if (minuteString.length < 2) {
    minuteString = '0' + minutes.toString()[0];
  }
  return minuteString;
}


String timeString(int minutes, int hour) {
  String ampm = 'am';
  if (hour == 12) ampm = 'pm';
  if (hour > 12) {
    hour -= 12;
    ampm = 'pm';
  }
  if (hour == 0) hour = 12;
  return '$hour:' + minutesIntToString(minutes) + " " + ampm;
}

int bacToPlant(double bac) {
  bac = bac >= 0.12 ? 0.12 : bac; // sets BAC equal to 0.12 if >= 0.12
  int plantNum = (5 * (bac / .12)).floor();
  plantNum = plantNum > 4 ? 4 : plantNum;
  return plantNum;
}

String typeToImageName(int type) {
  String path =
      type == 1 ? 'assets/soloCup.png' : 'assets/waterDrop.png';
  return path;
}

String dateToString(String date) {
  String monthName;

  List<String> dateObjects = date.split("/");
  String month = minutesStringToString(dateObjects[0]);
  String day = minutesStringToString(dateObjects[1]);
  String year = dateObjects[2];

  String dateStringToConvert = year + month + day;
  DateTime parsedDate = DateTime.parse(dateStringToConvert);

  int monthInt = parsedDate.month;
  if (monthInt == 1) {
    monthName = 'JANUARY';
  } else if (monthInt == 2) {
    monthName = 'FEBRUARY';
  } else if (monthInt == 3) {
    monthName = 'MARCH';
  } else if (monthInt == 4) {
    monthName = 'APRIL';
  } else if (monthInt == 5) {
    monthName = 'MAY';
  } else if (monthInt == 6) {
    monthName = 'JUNE';
  } else if (monthInt == 7) {
    monthName = 'JULY';
  } else if (monthInt == 8) {
    monthName = 'AUGUST';
  } else if (monthInt == 9) {
    monthName = 'SEPTEMBER';
  } else if (monthInt == 10) {
    monthName = 'OCTOBER';
  } else if (monthInt == 11) {
    monthName = 'NOVEMBER';
  } else if (monthInt == 12) {
    monthName = 'DECEMBER';
  }

  return '$monthName ${parsedDate.day}, ${parsedDate.year}';
}

int getMonth(String date) {
  List<String> dateObjects = date.split("/");
  return int.parse(dateObjects[0]);
}

int getDay(String date) {
  List<String> dateObjects = date.split("/");
  return int.parse(dateObjects[1]);
}

int getYear(String date) {
  List<String> dateObjects = date.split("/");
  return int.parse(dateObjects[2]);
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }
  return result;
}

DateTime stringToDateTime(String date, int hour, int minutes) {
  List<String> dateObjects = date.split("/");
  String month = minutesStringToString(dateObjects[0]);
  String day = minutesStringToString(dateObjects[1]);
  String year = dateObjects[2];

  DateTime dateTime = DateTime.parse(year +
      month +
      day +
      ' ' +
      minutesIntToString(hour) +
      ':' +
      minutesIntToString(minutes) +
      ':00');
  return dateTime;
}

Widget generateTable(Day day) {
  List rows = List<Row>();
  for (int i = 0; day.getHours().length > i; i++) {
    rows.add(new Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(timeString(day.getMinutes()[i], day.getHours()[i])),
        Container(
            padding: EdgeInsets.all(5),
            child: Image.asset(typeToImageName(day.getTypes()[i]), height: 20))
      ],
    ));
  }

  return ListView(children: rows);
}

