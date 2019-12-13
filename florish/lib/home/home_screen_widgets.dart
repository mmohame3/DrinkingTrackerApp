import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:timer_builder/timer_builder.dart';
import 'package:Florish/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:Florish/pages/settings_page.dart';
import 'package:Florish/functions/bac_info_popup.dart';
import 'package:Florish/models/notification.dart';
import 'package:Florish/home/drink_button.dart';
import 'package:Florish/home/water_button.dart';
import 'package:Florish/models/day_model.dart';

/// Contains the widgets on the home page below the app bar
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


// Sets up the plant and BAC
  _PlantState() {
    determineDay().then((day) => setState(() {
      globals.today = day;
      updateImageAndBAC('assets/plants/drink0water0.png');
    }));
  }

  // builds the column with: bac counter, bac picture,
  // plant image, and buttons
  @override
  Widget build(context) {
    return TimerBuilder.periodic(Duration(seconds: 5), builder: (context) {
      determineDay().then((day) => setState(() {
        globals.today = day;
        updateImageAndBAC('assets/plants/drink0water0.png');
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
                          'assets/bacInfoButton.png',
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


// Helper functions re: calculating bac and work with Day objects


/// Updates the plant image and bac
///
/// Changes [globals.bac] and [globals.imageName] based
/// on the output of [_bacMath]. Sets today's maxBAC
/// and watersAtMaxBAC if needed.
updateImageAndBAC(String path) {
  globals.bac = _bacMath(_dbListToTimeList());
  globals.imageName =
  'assets/plants/drink${bacToPlant(globals.bac)}water${waterToPlant()}.png';
  if (globals.bac >= globals.today.getMaxBac()) {
    globals.today.setMaxBac(globals.bac);
    globals.today.setWatersAtMaxBac(waterToPlant());
  }
}

/// Calculates the current BAC
///
/// Based on [drinkTimeList], the [globals.selectedSex],
/// and [globals.selectedWeight], returns the current BAC.
double _bacMath(drinkTimeList) {
  DateTime currentTime = DateTime.now();

  double r = 0.615;
  if (globals.selectedSex == 'Male') {
    r = 0.68;
  } else if (globals.selectedSex == 'Female') {
    r = 0.55;
  }

  /// The amount the user's BAC will rise with every drink
  double oneDrink = (14 / (globals.selectedWeight * 453.592 * r) * 100);

  /// The user's BAC if no time had passed since any of the drinks.
  /// This amount will be decremented based on the time since each drink.
  double fullBAC = globals.today.totalDrinks * oneDrink;

  int i = 0;
  double rolloverBAC = 0.0;
  double toSubtract;

  /// For each drink, [fullBAC] is subtracted from based on
  /// how long ago that drink was had.
  if (globals.today.totalDrinks > 0) {
    for (i = 0; i < globals.today.totalDrinks - 1; i++) {
      int timeDiff = drinkTimeList[i + 1].difference(drinkTimeList[i]).inSeconds;

      /// [toSubtract] is the amount of BAC digested between when drink[i] and drink[i + 1] were had.
      /// if it is greater than the amount of BAC added by drink[i] and the amount of "rollover" BAC
      /// undigested from past drinks, then [toSubtract] is that sum instead.
      toSubtract = (timeDiff / 3600) * globals.bacDropPerHour <= oneDrink + rolloverBAC ? (timeDiff / 3600) * globals.bacDropPerHour : oneDrink + rolloverBAC;

      /// [rolloverBAC] is the amount of bac from drink[i] not digested between
      /// when drink[i] and drink[i + 1] were had.
      rolloverBAC = rolloverBAC + (oneDrink - toSubtract);

      fullBAC = fullBAC - toSubtract;
    }

    /// Does similar calculations as above with the difference between
    /// the last drink and the current time.
    double timeSinceLastDrinkHours = (currentTime.difference(drinkTimeList.last).inSeconds / 3600);

    fullBAC = timeSinceLastDrinkHours * globals.bacDropPerHour <= oneDrink + rolloverBAC ?
    fullBAC - (timeSinceLastDrinkHours * globals.bacDropPerHour) : fullBAC - (oneDrink + rolloverBAC);

  }

  double totalBAC = fullBAC + getYesterBAC();

  return totalBAC;
}

/// Returns the amount of BAC from yesterday's drinks
///
/// Uses [getYesterInfo] and [currentTime] to calculate how
/// much BAC from yesterday would be left undigested.
double getYesterBAC(){
  DateTime currentTime = DateTime.now();
  double yesterBAC, drinkToNoonTime;

  getYesterInfo().then((list) {
    yesterBAC = list[3];
    drinkToNoonTime = list[4];
  });

  yesterBAC ??= 0.0;
  drinkToNoonTime ??= 0.0;

  /// A DateTime object at [globals.resetTime] that,
  /// if it's currently before the resetTime, reflects
  /// the fact that the resetTime for [globals.today]
  /// was actually yesterday
  DateTime resetDateTime = new DateTime(currentTime.year, currentTime.month, currentTime.day, globals.resetTime);
  resetDateTime = currentTime.hour < globals.resetTime ? resetDateTime.subtract(Duration(days: 1)) : resetDateTime;

  int afterNoonDiff = currentTime.difference(resetDateTime).inSeconds;
  double beforeNoonDiff = drinkToNoonTime * 60;

  double totalYesterBAC = (yesterBAC - (((afterNoonDiff + beforeNoonDiff) / 3600) * globals.bacDropPerHour));
  totalYesterBAC = totalYesterBAC <= 0 ? 0 : totalYesterBAC;

  return totalYesterBAC;
}

/// Gets a list of information about yesterday's drinking
///
/// The list contains:
/// 0. yesterday's total waters
/// 1. yesterday's hydratio (the overall waters per hour)
/// 2. yesterday's total drinks (alcohol)
/// 3. the last BAC recorded yesterday
/// 4. the time (in minutes) between the last drink and the reset
/// or all 0s if there was no data yesterday
Future<List<double>> getYesterInfo() async {
  DateTime time = DateTime.now();
  Duration dayLength = Duration(days: 1);
  DateTime yester = time.subtract(dayLength);

  String yesterDate = dateTimeToString(yester);

  Database db = await DatabaseHelper.instance.database;

  List<Map> yesterdayResult = await db.rawQuery('SELECT * FROM days WHERE day=?', [yesterDate]);

  double yesterdayWaters, yesterdayHydratio, yesterdayDrinks, yesterdayLastBAC;
  int lastDrinkToReset;

  if (yesterdayResult.isEmpty || yesterdayResult == null) {
    return [0.0, 0.0, 0.0, 0.0, 0.0];
  }
  else {
    Day yesterday = Day.fromMap(yesterdayResult[0]);
    yesterdayWaters = yesterday.totalWaters.toDouble();
    yesterdayHydratio = yesterday.hydratio;
    yesterdayDrinks = yesterday.totalDrinks.toDouble();
    yesterdayLastBAC = yesterday.lastBAC;

    if (yesterday.typeList != null) {
      if (yesterday.typeList.contains(1)) {
        int lastDrinkIndex = yesterday.typeList.lastIndexOf(1);
        int midnightToLastDrink = yesterday.hourList[lastDrinkIndex] * 60 +
            yesterday.minuteList[lastDrinkIndex];
        int resetTimeMinutes = globals.resetTime * 60;
        int midnight = 1440;


        lastDrinkToReset = resetTimeMinutes - midnightToLastDrink;
        lastDrinkToReset =
        lastDrinkIndex < 0 ? resetTimeMinutes + (midnight - midnightToLastDrink)
            : lastDrinkToReset;
      }
    }
    else {
      lastDrinkToReset = 0;
    }
    return [yesterdayWaters, yesterdayHydratio, yesterdayDrinks, yesterdayLastBAC, lastDrinkToReset.toDouble()];
  }
}


/// Returns a list of DateTime objects for just the drinks
/// in the database.
///
///
List<DateTime>_dbListToTimeList() {
  List hours = globals.today.hourList;
  List minutes = globals.today.minuteList;
  List types = globals.today.typeList;
  int i;
  DateTime currentTime = DateTime.now();
  DateTime newTime;
  List<DateTime> timeList = [];
  for (i = 0; i < types.length; i++) {
    /// If the drinkType is 1, it corresponds to a drink
    if (types[i] == 1) {
      /// If the current time is before the reset and the drink in question isn't,
      /// then the newTime is based on yesterday. If this isn't the case, the newTime
      /// is based on the current time.
      if (currentTime.hour < globals.resetTime && hours[i] >= globals.resetTime) {
        newTime = currentTime.subtract(Duration(days: 1));
      }
      else {
        newTime = currentTime;
      }
      /// [newTime] is adjusted to reflect the hour and minute of drink[i]
      /// then added to the list.
      newTime = new DateTime(newTime.year, newTime.month, newTime.day, hours[i], minutes[i]);
      timeList.add(newTime);
    }
  }
  return timeList;
}


/// Converts a DateTime [date] to a string
///
/// These strings are used as ids in our database
String dateTimeToString(DateTime date) {
  String y = date.year.toString();
  String m = date.month.toString();
  String d = date.day.toString();
  return m + "/" + d + "/" + y;
}



/// Returns the current [day_model.Day] based on the current time.
///
/// If there is no data for today in the database,
/// a new [day_model.Day] is formed with all zeroes.
/// Else, today's data is retrieved from [database_helper.Database]
Future<Day> determineDay() async {
  DateTime time = DateTime.now();
  DateTime yesterday = time.subtract(Duration(days: 1));
  Database db = await DatabaseHelper.instance.database;

  if (time.hour < globals.resetTime) {
    time = yesterday;
  }

  String todayDate = dateTimeToString(time);
  List<Map> result =
  await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);

  Day day;
  double yesterHyd;

  if (result == null || result.isEmpty) {
    /// Set so that [showDayEndedPopup] will be called
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
    day = Day.fromMap(result[0]);

    day.hourList ??= new List<int>();
    day.minuteList ??= new List<int>();
    day.typeList ??= new List<int>();
    day.constantBACList ??= new List<int>();

    day.hourList = new List<int>.from(day.hourList);
    day.minuteList = new List<int>.from(day.minuteList);
    day.typeList = new List<int>.from(day.typeList);
    day.constantBACList = new List<int>.from(day.constantBACList);

    return day;
  }
}

/// Sets [globals.yesterWater] and [globals.yesterDrink]
/// based on yesterday's data so that [day_ended_popup.dart]
/// can show it.
Future<void> getDayEndedPopupInfo() async {
    List yesterList = await getYesterInfo();
    globals.yesterWater = yesterList[0].toInt();
    globals.yesterDrink = yesterList[2].toInt();
}

// turns the BAC to a plant stage
// where 5 is the number of plant stages we have and .12 is our "max" BAC

/// Turns the current [bac] into a plant stage.
///
/// Converts [bac] into a percentage of [globals.maxBAC]
/// and multiplies it by [globals.numberOfDrinkPlants] to
/// get the corresponding plant number.
/// If this plant number is greater than the number of
/// drink plant stages we have, it's capped.
int bacToPlant(double bac) {
  int plantNum = (globals.numberOfDrinkPlants * (bac / globals.maxBAC)).round();
  plantNum = plantNum > globals.numberOfDrinkPlants - 1 ? globals.numberOfDrinkPlants - 1 : plantNum;

  return plantNum;
}

// turns the water count to a plant stage
int waterToPlant() {
  DateTime current = DateTime.now();
  int plantNumWater;
  int yesterWaterCount = 0;
  double yesterHyd = 0.0;
  double idealWatersPerHour = 0.5;

  DateTime noon =
  new DateTime(current.year, current.month, current.day, globals.resetTime);

  noon = current.hour < globals.resetTime ? noon.subtract(Duration(days: 1)) : noon;

  Duration timeSinceNoon = current.difference(noon);
  int timeSinceNoonMinutes = timeSinceNoon.inMinutes;

  timeSinceNoonMinutes = timeSinceNoonMinutes < 0 ? -timeSinceNoonMinutes : timeSinceNoonMinutes; //makes timeSinceNoonMinutes positive if it wasn't
  timeSinceNoonMinutes = timeSinceNoonMinutes < 1 ? 1 : timeSinceNoonMinutes; //makes sure timeSinceNoonMinutes is at least 1 minute

  getYesterInfo().then((list) {
    yesterWaterCount = list[0].toInt();
    yesterHyd = list[1];
  });
  double watersPerHourRatio =
      (yesterWaterCount - ((timeSinceNoonMinutes / 60) * yesterHyd) + globals.today.totalWaters) /
          (timeSinceNoonMinutes / 60);

  globals.today.hydratio = watersPerHourRatio;

  plantNumWater = (globals.numberOfWaterPlants * (watersPerHourRatio / idealWatersPerHour)).round();
  plantNumWater = plantNumWater > globals.numberOfWaterPlants - 1 ? globals.numberOfWaterPlants - 1 : plantNumWater;
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