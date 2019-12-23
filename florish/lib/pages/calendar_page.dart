import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/models/day_model.dart';
import 'package:Florish/functions/carousel_widget.dart';
import 'package:Florish/functions/bac_chart_widget.dart';
import 'package:Florish/functions/calendar_widget.dart';


/// Creates a page that displays a calendar widget. When a day is selected on
/// the calendar, a widget is displayed in the bottom half of the screen that
/// gives information about the user's bac on the selected day.
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => new _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
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

  /// Creates a display of a plant representing a user's [maxBac], total drinks,
  /// total waters, and a chart of drinks and their respective times
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
                              bottom: MediaQuery.of(context).size.width / 30),
                          height: MediaQuery.of(context).size.height / 4,
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            'assets/plants/drink${bacToPlant(day.getMaxBac())}water${day.getWaterAtMax()}.png',
                            width: 7 * MediaQuery.of(context).size.width / 24,
                          )),
                      Row(children: <Widget>[
                        Text('${day.totalDrinks} ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${drinkPlural(day)}  |  '),
                        Text('${day.totalWaters} ',
                            style: TextStyle(fontWeight: FontWeight.bold)),
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

  /// Creates a widget that formats a graph of a user's bac from a given day
  Widget graphReturn() {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
//          child: Column(children: <Widget> [
//            Text('Your BAC over Time'),
        child: BacChart(day: day)
//        ])
        );
  }

  /// determines whether to return a carousel with information about a selected
  /// [Day] or a 'No data for this day' message
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

/// Returns 'drink' or 'drinks' according on the input number of drinks
String drinkPlural(Day day) {
  String string;
  if (day.totalDrinks > 1 || day.totalDrinks == 0) {
    string = 'drinks';
  } else if (day.totalDrinks == 1) {
    string = 'drink';
  }
  return string;
}

/// Returns 'water' or 'waters' according on the input number of waters
String waterPlural(Day day) {
  String string;
  if (day.totalWaters > 1 || day.totalWaters == 0) {
    string = 'waters';
  } else if (day.totalWaters == 1) {
    string = 'water';
  }
  return string;
}

/// If an input int is one digit, returns a string with a 0 at the beginning
/// (i.e. 2 becomes 02).
String minutesIntToString(int minutes) {
  String minuteString = minutes.toString();
  if (minuteString.length < 2) {
    minuteString = '0' + minutes.toString()[0];
  }
  return minuteString;
}

/// If an input string is one digit, adds a 0 at the beginning of the string
/// (i.e. 2 becomes 02).
String minutesStringToString(String minutes) {
  String minuteString = minutes.toString();
  if (minuteString.length < 2) {
    minuteString = '0' + minutes.toString()[0];
  }
  return minuteString;
}

/// Re-formats hours and minutes to 12-hour time and adds am/pm labels
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

/// Determines which plant corresponds to a given [bac] double
int bacToPlant(double bac) {
  bac = bac >= globals.maxBAC ? globals.maxBAC : bac;
  int plantNum = (globals.numberOfDrinkPlants * (bac / globals.maxBAC)).floor();
  plantNum = plantNum > globals.numberOfDrinkPlants - 1 ? globals.numberOfDrinkPlants - 1 : plantNum;
  return plantNum;
}

/// determines whether a drink stored in the Day's [drinklist] as a 0 or a 1
/// is alcohol or water. If alcohol, it returns the path to a solo cup icon,
/// if water, returns a path to a water drop.
String typeToImageName(int type) {
  String path = type == 1 ? 'assets/soloCup.png' : 'assets/waterDrop.png';
  return path;
}

/// Re-formats the [date] string stored in the Day object (i.e. January 4, 2019)
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

/// Generates a [ListView] that displays a table for each day that
/// displays each drink and time of drink
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
