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
  String bacValue = "0.0";

  @override
  void initState() {
    super.initState();
    //calBac();
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
  String imageName = 'assets/images/plants/drink0water0.png';
  double bac = 0;

  @override
  void initState() {
    super.initState();
  }

  _updateImageName(String path) {
    setState(() {
      imageName = path;
    });
  }

  _updateBAC(currentTime) {
    setState(() {
      globals.drinkTimes.add(currentTime);
      bac = _bacMath(currentTime, globals.drinkTimes);
      globals.bac = bac;
      if (bac >= globals.maxBAC) {
        globals.maxBAC = bac;
        globals.waterAtMaxBAC = globals.waterCount;
      }
    });
  }

  _bacMath(currentTime, drinkTimeList) {
    bac = 0;
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
      bac += ((14 / (globals.weightGrams * r)) * 100) -
          ((elapsedTime.inSeconds / 3600) * .015);
    }
    return bac;
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
                      bac.toStringAsFixed(2),
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
              child: Image.asset(imageName, width: 180),
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
          DateTime currentTime = DateTime.now();
          globals.drinkCount++;
          widget.parentAction(
              'assets/images/plants/drink${bacToPlant()}water${waterToPlant()}.png');
          widget.parentActionBAC(currentTime);
          drinkButtonTap(currentTime);
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
            globals.drinkCount.toString(),
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
    globals.allDrinkTimes.add(currentTime);
    globals.drinkTypes.add(1);
    var dayRow = Day(
        date: dateTimeToString(DateTime.now()),
        hourList: dateTimeListToHourList(),
        minuteList: dateTimeListToMinuteList(),
        typeList: globals.drinkTypes,
        totalWaters: globals.waterCount,
        totalDrinks: globals.drinkCount,
        maxBAC: globals.maxBAC,
        waterAtMaxBAC: globals.waterAtMaxBAC);

    // if no instance of day --> insert dayRow
    await dbHelper.insert(dayRow);

    //if day is already in there --> update
    //await dbHelper.updateDay(dayRow);
  }
// where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = 5 * (globals.bac / .12).floor();
    if (plantNum > 4) {
      plantNum = 4;
    }
    return plantNum;
  }

  int waterToPlant() {
    int plantNumWater = globals.waterCount;
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
            globals.waterCount++;
          // where 5 is the number of plant stages we have and .12 is our "max" BAC
          widget.parentAction(
              'assets/images/plants/drink${bacToPlant()}water${waterToPlant()}.png');
          waterButtonTap();
          //printDrinkCounts();
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
            globals.waterCount.toString(),
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
    DateTime currentTime = DateTime.now();
    globals.allDrinkTimes.add(currentTime);
    globals.drinkTypes.add(0);

    var dayRow = Day(
        date: dateTimeToString(DateTime.now()),
        hourList: dateTimeListToHourList(),
        minuteList: dateTimeListToMinuteList(),
        typeList: globals.drinkTypes,
        totalWaters: globals.waterCount,
        totalDrinks: globals.drinkCount,
        maxBAC: globals.maxBAC,
        waterAtMaxBAC: globals.waterAtMaxBAC);

    // if no instance of day --> insert dayRow
    await dbHelper.insert(dayRow);

    // if day is already in there --> update
    //await dbHelper.updateDay(dayRow);
  }
  // where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = 5 * (globals.bac / .12).floor();
    if (plantNum > 4){
      plantNum = 4;
    }
    return plantNum;

  }

  int waterToPlant() {
    int plantNumWater = globals.waterCount;
    if (plantNumWater > 5) {
      plantNumWater = 5;
    }
    return plantNumWater;
  }


}
List<int> dateTimeListToHourList() {
  List<int> newList = new List();
  for (int i = 0; i < globals.allDrinkTimes.length; i++) {
    DateTime date = globals.allDrinkTimes[i];
    newList.add(date.hour);

  }
  return newList;
}

List<int> dateTimeListToMinuteList() {
  List<int> newList = [];
  for (int i = 0; i < globals.allDrinkTimes.length; i++) {
    DateTime date = globals.allDrinkTimes[i];
    newList.add(date.minute);
  }
  return newList;
}

String dateTimeToString(DateTime date) {
  String y = date.year.toString();
  String m = date.month.toString();
  String d = date.day.toString();
  return m + "/" + d + "/" + y;
}

//query() async {
//  Database db = await DatabaseHelper.instance.database;
//
//  List<Map> result = await db.rawQuery('SELECT * FROM tableDays WHERE day=?', [""]) // set "" to today's date in string
//
//  return result[0];
//
//}
