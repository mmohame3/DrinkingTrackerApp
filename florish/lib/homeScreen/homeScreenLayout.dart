import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:timer_builder/timer_builder.dart';
import 'package:Florish/helpers/database_helpers.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:Florish/pages/PersonalInformation.dart';
import 'package:Florish/popups.dart';
import 'package:Florish/helpers/notifications.dart';
import 'package:Florish/homeScreen/drinkButton.dart';
import 'package:Florish/homeScreen/waterButton.dart';


final int resetTime = 12; //resets counters on this hour
final double maxBAC = 0.12;
final int numberOfDrinkPlants = 5;
final int numberOfWaterPlants = 6;
final double bacDropPerHour = .015;



class Plant extends StatefulWidget {
  @override
  _PlantState createState() => new _PlantState();
}

class _PlantState extends State<Plant> {
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
    initializeNotifications();

  }

  getInputInformation() async {
    var _inputInformation = await getInputInformation();
    _inputInformation.forEach((input) {
      globals.selectedFeet = input['feet'];
      globals.selectedInches = input['inch'];
      globals.selectedWeight = input['weight'];
      globals.selectedSex = input['gender'];
    });
  }

// Sets up the plant and BAC
  _PlantState() {
    determineDay().then((day) => setState(() {
      globals.today = day;

      // DateTime now = DateTime.now().toUtc().add(
      //   Duration(seconds:30),
      // );
      // singleNotification(
      //   now,
      //   "Notification",
      //   "This is a notification",
      //   98123871,
      // );
      updateImageAndBAC('assets/images/plants/drink0water0.png');
      getDayEnded();
    }));
  }

  // builds the "column" (almost our entire app)
  // with: bac counter, bac picture, plant image, and buttons
  @override
  Widget build(context) {
    return TimerBuilder.periodic(Duration(seconds: 5), builder: (context) {
      determineDay().then((day) => setState(() {
        globals.today = day;
        updateImageAndBAC('assets/images/plants/drink0water0.png');
        dbHelper.updateDay(globals.today);
      }));

      return Column(
        children: [
          Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width / 12),
            child: Row(
              children: [
                Spacer(
                  flex: 2,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                          'BAC:',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      Text(
                        '${globals.bac.toStringAsFixed(3)}%',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    decoration: new BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[700],
                          blurRadius: 5,
                          spreadRadius: -MediaQuery.of(context).size.width / 70,
                          offset: Offset(0, 0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: IconButton(
                        iconSize: MediaQuery.of(context).size.width / 7,
                        icon: Image.asset(
                          'assets/images/bacButton.png',
//                    width: MediaQuery.of(context).size.width/,
                        ),
                        onPressed: () {
                          showBACPopup(context);
                        }))
              ],
            ),
          ),
          Spacer(
            flex: 5,
          ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.width / 9),
                child: Image.asset(globals.imageName,
                    width: MediaQuery.of(context).size.width / 2),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: new DrinkButton(
                        parentActionUpdates: updateImageAndBAC),
                  ),
                  Expanded(
                    child: new WaterButton(
                      parentAction: updateImageAndBAC,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width / 25))
        ],
      );
    });
  }
}


// TODO: here are a lot of helper functions re: calculating bac and work with Day objects

// sets the bac global to the new bac and updates the max bac
// sets the plant's image name to a new path
updateImageAndBAC(String path) {
  globals.bac = _bacMath(_dbListToTimeList());
  globals.imageName =
  'assets/images/plants/drink${bacToPlant(globals.bac)}water${waterToPlant()}.png';
  if (globals.bac >= globals.today.getMaxBac()) {
    globals.today.setMaxBac(globals.bac);
    globals.today.setWatersAtMaxBac(waterToPlant());
  }
  endSession();
}

// takes in a list of DateTime objects and calculates the bac
_bacMath(drinkTimeList) {
  DateTime currentTime = DateTime.now();

  double r = 0.615;
  if (globals.selectedSex == 'Male') {
    r = 0.68;
  } else if (globals.selectedSex == 'Female') {
    r = 0.55;
  }

  double oneDrink = (14 / (globals.selectedWeight * 453.592 * r) * 100);
  double fullBAC = globals.today.totalDrinks * oneDrink;
  int i = 0;
  double rolloverBAC = 0.0;
  double toSubtract;
  if (globals.today.totalDrinks > 0) {
    for (i = 0; i < globals.today.totalDrinks - 1; i++) {
      int timeDiff = drinkTimeList[i + 1].difference(drinkTimeList[i]).inSeconds;

      //rollover = amount of bac from drink[i] not digested
      toSubtract = (timeDiff / 3600) * bacDropPerHour <= oneDrink + rolloverBAC ? (timeDiff / 3600) * bacDropPerHour : oneDrink + rolloverBAC;
      rolloverBAC = rolloverBAC + (oneDrink - toSubtract);

      fullBAC = fullBAC - toSubtract;
    }
    double timeSinceLastDrinkHours = (currentTime.difference(drinkTimeList.last).inSeconds / 3600);

    fullBAC = timeSinceLastDrinkHours * bacDropPerHour <= oneDrink + rolloverBAC ?
    fullBAC - (timeSinceLastDrinkHours * bacDropPerHour) : fullBAC - (oneDrink + rolloverBAC);

  }

  double yesterBAC, drinkToNoonTime;

  getYesterInfo().then((list) {
    yesterBAC = list[3];
    drinkToNoonTime = list[4];
  });

  yesterBAC ??= 0.0;
  drinkToNoonTime ??= 0.0;

  DateTime noon = new DateTime(currentTime.year, currentTime.month, currentTime.day, resetTime);
  noon = currentTime.hour < resetTime ? noon.subtract(Duration(days: 1)) : noon;

  int afterNoonDiff = currentTime.difference(noon).inSeconds;
  double beforeNoonDiff = drinkToNoonTime * 3600;

  double totalYesterBAC = (yesterBAC - (((afterNoonDiff + beforeNoonDiff) / 3600) * bacDropPerHour));
  totalYesterBAC = totalYesterBAC < 0 ? 0 : totalYesterBAC;

  double totalBAC = fullBAC + totalYesterBAC;

  return totalBAC;
}

// turns today's hours and minute lists to a list of DateTimes
// (for the ones that correspond to drinks not waters)
_dbListToTimeList() {
  List hours = globals.today.hourList;
  List minutes = globals.today.minuteList;
  List types = globals.today.typeList;
  int i;
  DateTime currentTime = DateTime.now();
  DateTime newTime;
  List<DateTime> timeList = [];
  for (i = 0; i < types.length; i++) {
    // if the drink type is alcohol, the corresponding info
    // is added to the new list of DateTimes

    if (types[i] == 1) {
      // year and month are hard set bc issues arise because
      // of our noon-to-noon system for resetting drinks
      if (currentTime.hour < 12 && hours[i] >= 12) {
        newTime = currentTime.subtract(Duration(days: 1));
      }
      else {
        newTime = currentTime;
      }
      newTime = new DateTime(newTime.year, newTime.month, newTime.day, hours[i], minutes[i]);
      timeList.add(newTime);
    }
  }
  return timeList;
}


Future<void> endSession() async {
  if ((globals.today.sessionList.length != 0) &&
      (globals.today.sessionList.length % 2 != 0)) {
    globals.inSession = true;
  }
  if ((globals.inSession) && (globals.bac == 0.0)) {
    //print("inSession: ${globals.inSession}, start: ${globals.start}");
    globals.inSession = false;
    DateTime now = DateTime.now();
    globals.today.addType(2);
    globals.today.addHour(now.hour);
    globals.today.addMinute(now.minute);
    globals.today.addStartEnd(globals.today.typeList.length - 1);
    //print(globals.today.sessionList);
    await dbHelper.updateDay(globals.today);
  }
}



//takes a DateTime and makes it into the string format
// we use as a database key
String dateTimeToString(DateTime date) {
  String y = date.year.toString();
  String m = date.month.toString();
  String d = date.day.toString();
  return m + "/" + d + "/" + y;
}

// if today's date isn't in the db, adds it
// if it IS in the database, creates a new day from the data there,
// i think this won't result in copies of the same day since in database_helpers
// if there are two of the same day it just replaces the old one
Future<Day> determineDay() async {
  DateTime time = DateTime.now();
  DateTime yesterday = time.subtract(Duration(days: 1));
  Database db = await DatabaseHelper.instance.database;

  if (time.hour < resetTime) {
    time = yesterday;
  }

  String todayDate = dateTimeToString(time);
  List<Map> result =
  await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);

  Day day;
  double yesterHyd;

  if (result == null || result.isEmpty) {
    globals.dayEnded = true;
    getYesterInfo().then((list) {
      yesterHyd = list[1];
    });
    yesterHyd ??= 0.0;

    day = new Day(
        date: todayDate,
        hourList: new List<int>(),
        minuteList: new List<int>(),
        typeList: new List<int>(),
        maxBAC: 0.0,
        waterAtMaxBAC: 0,
        totalDrinks: 0,
        totalWaters: 0,
        sessionList: new List<int>(),
        hydratio: 0.0,
        yesterHydratio: yesterHyd,
        lastBAC: 0.0);

    await db.insert(tableDays, day.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    await getDayEnded();


    return day;
  } else {
    globals.dayEnded = false;

    day = Day.fromMap(result[0]);

    day.sessionList ??= new List<int>();
    day.hourList ??= new List<int>();
    day.minuteList ??= new List<int>();
    day.typeList ??= new List<int>();
    day.hourList = new List<int>.from(day.hourList);
    day.minuteList = new List<int>.from(day.minuteList);
    day.typeList = new List<int>.from(day.typeList);
    day.sessionList = new List<int>.from(day.sessionList);

    return day;
  }
}

// sets the global variables for yesterday's drinks and waters
// if the day has "ended" as indicated by determine day
Future<void> getDayEnded() async {
  if (globals.dayEnded) {
    Future<List> yesterInfo = getYesterInfo();
    yesterInfo.then((list) {
      globals.yesterWater = list[0].toInt();
      globals.yesterDrink = list[2].toInt();
    });
    print(globals.yesterWater);
    print(globals.yesterDrink);
  }
}

// gets yesterday's data about drinks and bac in the form:
// [yesterday's total waters, yesterday's hydration ratio,
// yesterday's total drinks, yesterday's last bac, hours between reset time and time of last drink]
Future<List<double>> getYesterInfo() async {
  DateTime time = DateTime.now();
  Duration dayLength = Duration(days: 1);
  DateTime yester = time.subtract(dayLength);

  String yesterDate = dateTimeToString(yester);

  Database db = await DatabaseHelper.instance.database;

  List<Map> yesterdayResult =
  await db.rawQuery('SELECT * FROM days WHERE day=?', [yesterDate]);
  double w, yhr, d, ybac, drinkToNoonHours;
  int i;
  if (yesterdayResult.isEmpty || yesterdayResult == null) {
    return [0.0, 0.0, 0.0, 0.0, 0.0];
  }
  else {
    w = yesterdayResult[0]['totalwatercount'].toDouble();
    yhr = yesterdayResult[0]['todayhydratio'];
    d = yesterdayResult[0]["totaldrinkcount"].toDouble();
    ybac = yesterdayResult[0]['lastBAC'];
    i = yesterdayResult[0]['typelist'] == null ? -1 : yesterdayResult[0]['typelist'].lastIndexOf(1);

    drinkToNoonHours = i >= 0 ?
          yesterdayResult[0]['hourlist'][i] + (yesterdayResult[0]['minutelist'][i]/60)
          : 0.0;

    return [w, yhr, d, ybac, 0];
  }
}

// turns the BAC to a plant stage
// where 5 is the number of plant stages we have and .12 is our "max" BAC
int bacToPlant(double bac) {
  int plantNum = (numberOfDrinkPlants * (bac / maxBAC)).round();
  plantNum = plantNum > numberOfDrinkPlants - 1 ? numberOfDrinkPlants - 1 : plantNum;

  return plantNum;
}

// turns the water count to a plant stage
int waterToPlant() {
  DateTime current = DateTime.now();
  int plantNumWater;
  int yesterWater = 0;
  double yesterHyd = 0.0;

  DateTime noon =
  new DateTime(current.year, current.month, current.day, resetTime);
  noon = current.hour < resetTime ? noon.subtract(Duration(days: 1)) : noon;

  Duration diffDuration = current.difference(noon);
  int diff = diffDuration.inMinutes;

  diff = diff < 0 ? -diff : diff; //makes diff positive if it wasn't
  diff = diff < 1 ? 1 : diff; //makes sure diff is at least 1 minute

  Future<List> yesterInfo = getYesterInfo();
  yesterInfo.then((list) {
    yesterWater = list[0].toInt();
    yesterHyd = list[1];
  });
  double ratio =
      (yesterWater - ((diff / 60) * yesterHyd) + globals.today.totalWaters) /
          24;

  globals.today.hydratio = ratio;

  plantNumWater = (numberOfWaterPlants * (ratio / .5)).round();
  plantNumWater = plantNumWater > numberOfWaterPlants - 1 ? numberOfWaterPlants - 1 : plantNumWater;
  plantNumWater = plantNumWater < 0 ? 0 : plantNumWater;

  dbHelper.updateDay(globals.today);
  return plantNumWater;
}

getInputInformation() async {
  var _inputInformation = await dbHelper.getInputInformation();
  _inputInformation.forEach((input) {
    globals.selectedFeet = input['feet'];
    globals.selectedInches = input['inch'];
    globals.selectedWeight = input['weight'];
    globals.selectedSex = input['gender'];
  });
}