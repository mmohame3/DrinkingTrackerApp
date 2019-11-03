// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'database_helpers.dart';
import 'package:sqflite/sqflite.dart';

import './history.dart';
import './standardDrink.dart';
import './ourMission.dart';
import './PersonalInformation.dart';

void main() => runApp(MyApp());



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plant Nanny',
      theme: ThemeData(fontFamily: 'Montserrat'),
      home: AppHomeScreen(),
    );
  }
}

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  DatabaseHelper dbHelper = DatabaseHelper.instance;


  @override
  void initState() {
    //uncomment to reset today's data to 0
    //dbHelper.deleteDay(dateTimeToString(DateTime.now()));
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    Widget plant = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 140),
          child: Image.asset(
            'assets/images/plantSetting.png',
          ),
        ),
        new Plant(),
      ],
    );

// Builds the drawer menu
    Widget menu = Drawer(
      child: Container(
        padding: EdgeInsets.only(left: 10),
        color: Color(0xFF97B633),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "MY PLANT",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "HISTORY",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new HistoryPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                'A "STANDARD DRINK"',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new StandardDrinkPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "OUR MISSION",
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    letterSpacing: 1),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new OurMissionPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title:
        Text(
          "FLORISH",
          style: TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 3,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.person, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new PersonalInfoPage()));
              })
        ],
        backgroundColor: Color(0xFF97B633),
      ),
      drawer: menu,
      backgroundColor: Colors.grey[600],
      body: plant,
    );
  }

}

class Plant extends StatefulWidget {
  @override
  _PlantState createState() => new _PlantState();
}

class _PlantState extends State<Plant> {
  final dbHelper = DatabaseHelper.instance;

  @override
  void initState() {
    super.initState();
  }

// Sets up the plant and BAC
  _PlantState() {
    determineDay().then((day) => setState(() {
      globals.today = day;
      _updateBAC(DateTime.now());
      globals.imageName = 'assets/images/plants/drink${bacToPlant()}water${waterToPlant()}.png';
      _updateImageName(globals.imageName);
    }));
  }

// turns the BAC to a plant stage
  // where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac/.12)).floor();
    if (plantNum > 4) {
      plantNum = 4;
    }
    return plantNum;
  }

 // turns the water count to a plant stage
  int waterToPlant() {
    int plantNumWater = globals.today.getTotalWaters();
    if (plantNumWater > 5) {
      plantNumWater = 5;
    }
    return plantNumWater;
  }

  // sets the plant's image name to a new path
  _updateImageName(String path) {
    setState(() {
      globals.imageName = path;
    });
  }

  // sets the bac global to the new bac and updates the max bac
  _updateBAC(currentTime) {
    setState(() {
      globals.bac = _bacMath(_dbListToTimeList());
      if (globals.bac >= globals.today.getMaxBac()) {
        globals.today.setMaxBac(globals.bac);
        globals.today.setWatersAtMaxBac(globals.today.getTotalWaters());

      }
    });
  }

  // takes in a list of DateTime objects and calculates the bac
  _bacMath(drinkTimeList) {
    print(drinkTimeList);
    DateTime currentTime = DateTime.now();
    double runningBac = 0;
    double r;
    Duration elapsedTime;
    if (globals.selectedSex == 'Male') {
      r = 0.68;
    } else if (globals.selectedSex == 'Female') {
      r = 0.55;
    } else {
      r = 0.615;
    }
    for (int i = 0; i < drinkTimeList.length; i++) {
      elapsedTime = currentTime.difference(drinkTimeList[i]);
      runningBac += ((14 / (globals.weightGrams * r)) * 100) -
          ((elapsedTime.inSeconds / 3600) * .015);
    }
    return runningBac;
  }

  // turns today's hours and minute lists to a list of DateTimes
  // (for the ones that correspond to drinks not waters)
  _dbListToTimeList() {
    List hours = globals.today.getHours();
    List minutes = globals.today.getMinutes();
    List types = globals.today.getTypes();
    int i;
    DateTime newTime;
    List<DateTime> timeList = [];
    DateTime currentTime = DateTime.now();
    for (i = 0; i <types.length; i++){
      if (types[i] == 1){
        newTime = new DateTime(currentTime.year, currentTime.month,
        currentTime.day, hours[i], minutes[i]);
        timeList.add(newTime);
      }
    }
    return timeList;
  }

  // builds the "column" (almost our entire app)
  // with: bac counter, bac picture, plant image, and buttons
  @override
  Widget build(context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(32),
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
                      globals.bac.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/images/bacDrop.png',
                height: 42,
                width: 28,
              ),
            ],
          ),
        ),
        Spacer(
          flex: 4,
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: Image.asset(globals.imageName, width: 180),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: new DrinkButton(
                      parentAction: _updateImageName,
                      parentActionBAC: _updateBAC),
                ),
                Expanded(
                  child: new WaterButton(
                    parentAction: _updateImageName,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(padding: EdgeInsets.all(20))
      ],
    );
  }
}


class DrinkButton extends StatefulWidget {
  final ValueChanged<String> parentAction;
  final ValueChanged<DateTime> parentActionBAC;
  const DrinkButton({Key key, this.parentAction, this.parentActionBAC})
      : super(key: key);

  @override
  _DrinkButtonState createState() => new _DrinkButtonState();
}

class _DrinkButtonState extends State<DrinkButton> {
  final dbHelper = DatabaseHelper.instance;
  String drinkString = "";

  // determines the day and sets variables before building
  _DrinkButtonState() {
    determineDay().then((day) => setState(() {
      globals.today = day;
      drinkString = day.totalDrinks.toString();
    }));
  }
  @override
  Widget build(context) {

    return GestureDetector(
      // when tapped: updates today's counts, updates the drinkString,
      // updates BAC, updates the plant image, and calls drinkButtonTap
      onTap: () {
        setState(() {
          globals.today.setTotalDrinks(globals.today.getTotalDrinks() + 1);
          drinkString = globals.today.totalDrinks.toString();
          DateTime currentTime = DateTime.now();
          drinkButtonTap(currentTime);
          widget.parentActionBAC(currentTime);
          widget.parentAction(
              'assets/images/plants/drink${bacToPlant()}water${waterToPlant()}.png');


        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/soloCup.png',
            height: 71,
            width: 71,
          ),
          Text(
            drinkString,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

// Updates today's time and type lists,
  // updates the database itself
// and prints today's data (just for testing)
  void drinkButtonTap(DateTime currentTime) async {
    globals.today.addHour(currentTime.hour);
    globals.today.addMinute(currentTime.minute);
    globals.today.addType(1);

    print(globals.today.toString());
    dbHelper.updateDay(globals.today);
  }

// turns the BAC to a plant stage
// where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac/.12)).floor();
    if (plantNum > 4) {
      plantNum = 4;
    }
    return plantNum;
  }

// turns the water count into a plant stage
  int waterToPlant() {
    int plantNumWater = globals.today.getTotalWaters();
    if (plantNumWater > 5) {
      plantNumWater = 5;
    }
    return plantNumWater;
  }
}

class WaterButton extends StatefulWidget {
  final ValueChanged<String> parentAction;
  const WaterButton({Key key, this.parentAction}) : super(key: key);

  @override
  _WaterButtonState createState() => new _WaterButtonState();
}

class _WaterButtonState extends State<WaterButton> {
  final dbHelper = DatabaseHelper.instance;
  String waterString = "";

  // determines the day and sets variables before building
  _WaterButtonState() {
    determineDay().then((day) => setState(() {
      globals.today = day;
      waterString = day.totalWaters.toString();
    }));
  }


  @override
  Widget build(context) {
    return GestureDetector(
      // when tapped: updates today's count, updates waterString,
      // updates the plant image, and calls waterButtonTap()
      onTap: () {
        setState(() {
          globals.today.setTotalWaters(globals.today.getTotalWaters() + 1);
          waterString = globals.today.totalWaters.toString();
          waterButtonTap();
          widget.parentAction(
              'assets/images/plants/drink${bacToPlant()}water${waterToPlant()}.png');
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/waterCup.png',
            height: 71,
            width: 71,
          ),
          Text(
            waterString,
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  // updates today's time and type lists,
  // updates the database itself,
  // and prints today's data (for testing etc.)
  void waterButtonTap() async {
    globals.today.addHour(DateTime.now().hour);
    globals.today.addMinute(DateTime.now().minute);
    globals.today.addType(0);

    print(globals.today.toString());
    await dbHelper.updateDay(globals.today);

  }

  // turns BAC into a plant stage
  // where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac / .12)).floor();
    if (plantNum > 4){
      plantNum = 4;
    }
    return plantNum;
  }

  // turns the waterCount into a plant stage
  int waterToPlant() {
    int plantNumWater = globals.today.getTotalWaters();
    if (plantNumWater > 5) {
      plantNumWater = 5;
    }
    return plantNumWater;
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
  String todayDate = dateTimeToString(DateTime.now());

  Database db = await DatabaseHelper.instance.database;
  List<Map> result = await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);
  Day day;
  if (result.isEmpty) {
    day = new Day(date: todayDate, hourList: [], minuteList: [], typeList: [], maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0, totalWaters: 0);
    await db.insert(tableDays, day.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return day;
  }
  else {
    day = new Day(date: result[0]["day"], hourList: new List<int>.from(result[0]['hourlist']), minuteList: new List<int>.from(result[0]['minutelist']),
                    typeList: new List<int>.from(result[0]['typelist']), maxBAC: result[0]['maxBAC'], waterAtMaxBAC: result[0]["WateratmaxBAC"],
                    totalDrinks: result[0]["totaldrinkcount"], totalWaters: result[0]["totalwatercount"]);

    return day;
  }
}


