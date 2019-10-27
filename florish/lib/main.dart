// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'database_helpers.dart';
import 'package:sqflite/sqflite.dart';

import './history.dart';
import './standardDrink.dart';
import './alcoholInfo.dart';
import './ourMission.dart';
import './resources.dart';
import './termsConditions.dart';
import './alternatePersonalInformation.dart';

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
    determineDay();
    //dbHelper.deleteDay(globals.today.date);
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
                "PERSONAL INFORMATION",
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
//                        new PersonalInfoPage()));
                            new altPersonalInfoPage()));
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
                "ALCOHOL FACTS",
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
                            new AlcoholInfoPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "HELP & RESOURCES",
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
                            new ResourcesPage()));
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
            ListTile(
              title: Text(
                "TERMS & CONDITIONS",
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
                            new TermsConditionsPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FLORISH",
          style: TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 3,
          ),
        ),
        backgroundColor: Color(0xFF97B633),
      ),
      drawer: menu,
      backgroundColor: Colors.grey[600],
      body: plant,
    );
  }

//  Future <String> getBac()  async {
//    SharedPreferences pref =  await SharedPreferences.getInstance();
//    int selectedFeet = pref.getInt('feet');
//    int selectedInches = pref.getInt('inches');
//    String selectedSex = pref.getString(AppConstants.PREF_SEX);
//    int selectedWeight = pref.getInt('weight');
//    double r ;
//
//    if(selectedSex.toLowerCase() == 'Male'.toLowerCase()){
//      r = 0.68;
//    }else{
//      r= 0.55;
//    }
//
//    int SelectedHeight = selectedFeet + (selectedInches*0.0833333.floor());
//    int usStandardDrink = 14;
//
//    int bacCal =(((globals.drinkCount*14)/selectedWeight*r)*100).floor();
//    return bacCal.toString();
//  }
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

  _updateImageName(String path) {
    setState(() {
      globals.imageName = path;
    });
  }

  _updateBAC(currentTime) {
    setState(() {
      globals.bac = _bacMath(_dbListToTimeList());
      if (globals.bac >= globals.today.getMaxBac()) {
        globals.today.setMaxBac(globals.bac);
        globals.today.setWatersAtMaxBac(globals.today.getTotalWaters());

      }
    });
  }

  _bacMath(drinkTimeList) {
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
    for (int i = 0; i < drinkTimeList.length - 1; i++) {
      elapsedTime = drinkTimeList[drinkTimeList.length - 1].difference(drinkTimeList[i]);
      runningBac += ((14 / (globals.weightGrams * r)) * 100) -
          ((elapsedTime.inSeconds / 3600) * .015);
    }
    return runningBac;
  }

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


  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          globals.today.setTotalDrinks(globals.today.getTotalDrinks() + 1);
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
            globals.today.totalDrinks.toString(),
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

  void drinkButtonTap(DateTime currentTime) async {
    globals.today.addHour(currentTime.hour);
    globals.today.addMinute(currentTime.minute);
    globals.today.addType(1);

    print(globals.today.toString());
    dbHelper.updateDay(globals.today);
  }

// where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac/.12)).floor();
    if (plantNum > 4) {
      plantNum = 4;
    }
    return plantNum;
  }

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


  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          globals.today.setTotalWaters(globals.today.getTotalWaters() + 1);
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
            globals.today.totalWaters.toString(),
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

  void waterButtonTap() async {
    globals.today.addHour(DateTime.now().hour);
    globals.today.addMinute(DateTime.now().minute);
    globals.today.addType(0);

    print(globals.today.toString());
    await dbHelper.updateDay(globals.today);

  }
  // where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac / .12)).floor();
    if (plantNum > 4){
      plantNum = 4;
    }
    return plantNum;
  }

  int waterToPlant() {
    int plantNumWater = globals.today.getTotalWaters();
    if (plantNumWater > 5) {
      plantNumWater = 5;
    }
    return plantNumWater;
  }


}

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
void determineDay() async {
  print("determining day...");
  Database db = await DatabaseHelper.instance.database;
  String todayDate = dateTimeToString(DateTime.now());
  List<Map> result = await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);
  if (result.isEmpty) {
    globals.today = new Day(date: todayDate, hourList: [], minuteList: [], typeList: [], maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0, totalWaters: 0);
    await db.insert(tableDays, globals.today.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
  else {
    globals.today = new Day(date: result[0]["day"], hourList: new List<int>.from(result[0]['hourlist']), minuteList: new List<int>.from(result[0]['minutelist']),
                    typeList: new List<int>.from(result[0]['typelist']), maxBAC: result[0]['maxBAC'], waterAtMaxBAC: result[0]["WateratmaxBAC"],
                    totalDrinks: result[0]["totaldrinkcount"], totalWaters: result[0]["totalwatercount"]);

  }
}

//final String tableDays = "days";
//final String columnDay = "day";
//final String columnHourList = 'hourlist';
//final String columnMinuteList = 'minutelist';
//final String columnTypeList = 'typelist';
//final String columnMaxBAC = 'maxBAC';
//final String columnMBWater = 'WateratmaxBAC';
//final String columnDrinkCount = "totaldrinkcount";
//final String columnWaterCount = "totalwatercount";
//query() async {
//  Database db = await DatabaseHelper.instance.database;
//
//  List<Map> result = await db.rawQuery('SELECT * FROM tableDays WHERE day=?', [""]) // set "" to today's date in string
//
//  return result[0];
//
//}
