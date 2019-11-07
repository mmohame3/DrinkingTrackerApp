import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'database_helpers.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import './history.dart';
import './standardDrink.dart';
import './ourMission.dart';
import './PersonalInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './bacPopup.dart';
import 'dayEndedAlert.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // blocks sideways rotation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

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
//    DateTime time = DateTime.now();
//    if (time.hour < 12){
//      time = new DateTime(time.year, time.month, time.day - 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
//    }
//    dbHelper.deleteDay(dateTimeToString(time));
//    dbHelper.resetDay(dateTimeToString(time));

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await determineDay();
      await dayEndAlert(context);
    });

  }


  @override
  Widget build(BuildContext context) {


    Widget plant = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width/3),
          child: Image.asset(
            'assets/images/plantSetting.png',
//            width: MediaQuery.of(context).size.width,
          ),
        ),
        new Plant(),
      ],
    );




// Builds the drawer menu
    Widget menu = Drawer(
      child: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width/40),
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
        title: Text(
          "FLORISH",
          style: TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 3,
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
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
  SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPref();
  }

  _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

// Sets up the plant and BAC
  _PlantState() {
    determineDay().then((day) => setState(() {
      globals.today = day;
      _updateImageAndBAC('assets/images/plants/drink0water0.png');

    }));
  }

// turns the BAC to a plant stage
  // where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac/.12)).floor();
    plantNum = plantNum > 4 ? 4 : plantNum;

    return plantNum;
  }

  // turns the water count to a plant stage
  int waterToPlant() {
    int plantNumWater = globals.today.getTotalWaters();
    plantNumWater = plantNumWater > 5 ? 5 : plantNumWater;

    return plantNumWater;
  }

//
//  _updateImageName(String path) {
//    setState(() {
//      globals.imageName = path;
//      //globals.imageName = 'assets/images/plants/drink0water1.png';
//    });
//  }

  // sets the bac global to the new bac and updates the max bac
  // sets the plant's image name to a new path
  _updateImageAndBAC(String path) {
    Timer timer;
    const spread= const Duration(seconds: 5);
    setState(() {


      globals.bac = _bacMath(_dbListToTimeList());
      globals.imageName = 'assets/images/plants/drink${bacToPlant()}water${waterToPlant()}.png';
      if (globals.bac >= globals.today.getMaxBac()) {
        globals.today.setMaxBac(globals.bac);
        globals.today.setWatersAtMaxBac(globals.today.getTotalWaters());
      }

    });
    new Timer.periodic(spread, (Timer t) => setState(() {}));
//    ssjsjsjsjs

  }

  // takes in a list of DateTime objects and calculates the bac
  _bacMath(drinkTimeList) {

    //print(drinkTimeList);
    // sets the "current" date to one of two dates depending on
    // the time of day. This is to avoid issues with the noon-to-noon
    // resetting of counters and Day objects.
    DateTime currentTime = DateTime.now();
    int dayNum = currentTime.hour < 12 ? 2 : 1;
    DateTime newTime = new DateTime(2019, 11,
        dayNum, currentTime.hour, currentTime.minute);
    double runningBac = 0.0;
    double sumBac = 0.0;
    double r = 0.615;
    Duration elapsedTime;
    if (_prefs.getString(globals.selectedSexKey) == 'Male') {
      r = 0.68;
    } else if (_prefs.getString(globals.selectedSexKey) == 'Female') {
      r = 0.55;
    } else {
      r = 0.615;
    }
    for (int i = 0; i < drinkTimeList.length; i++) {
      elapsedTime = newTime.difference(drinkTimeList[i]);
      runningBac = ((14 / ((_prefs.getInt(globals.selectedWeightKey) * 453.592 * r))) * 100) -
          ((elapsedTime.inSeconds / 3600) * .015);
      runningBac = runningBac < 0 ? 0 : runningBac;
      sumBac += runningBac;
    }
//    print('from back math method sex : ${_prefs.getString(globals.selectedSexKey)}');
//    print('from back math method : $sumBac');
    return sumBac;
  }

  // turns today's hours and minute lists to a list of DateTimes
  // (for the ones that correspond to drinks not waters)
  _dbListToTimeList() {
    List hours = globals.today.getHours();
    List minutes = globals.today.getMinutes();
    List types = globals.today.getTypes();
    int i;
    int dayNum;
    DateTime newTime;
    List<DateTime> timeList = [];
    DateTime currentTime = DateTime.now();
    for (i = 0; i <types.length; i++){
      // if the drink type is alcohol, the corresponding info
      // is added to the new list of DateTimes

      if (types[i] == 1){
        // year and month are hard set bc issues arise because
        // of our noon-to-noon system for resetting drinks
        dayNum = hours[i] < 12 ? 2 : 1;
        newTime = new DateTime(2019, 11,
            dayNum, hours[i], minutes[i]);
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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width/12),
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
//            onPressed: () {
//              Navigator.push(
//                  context,
//                  new MaterialPageRoute(
//                      builder: (BuildContext context) =>
//                      new PersonalInfoPage()));
//            })
              IconButton(
                  icon: Image.asset(
                    'assets/images/bacDrop.png',
                    width: MediaQuery.of(context).size.width/12,
                  ),
                  onPressed: () {
                    showPopup(context);
                  }
              )
            ],
          ),
        ),
        Spacer(
          flex: 5,
        ),
        Column(
          children: [
            Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width/9),
              child: Image.asset(globals.imageName, width: MediaQuery.of(context).size.width/2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: new DrinkButton(
//                      parentAction: _updateImageName,
//                      parentActionBAC: _updateBAC
                      parentActionUpdates: _updateImageAndBAC),
                ),
                Expanded(
                  child: new WaterButton(
                    parentAction: _updateImageAndBAC,
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(padding: EdgeInsets.all(MediaQuery.of(context).size.width/25))
      ],
    );
  }


}

class DrinkButton extends StatefulWidget {
//  final ValueChanged<String> parentAction;
//  final ValueChanged<DateTime> parentActionBAC;
  final ValueChanged<String> parentActionUpdates;
  const DrinkButton({Key key, this.parentActionUpdates})
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
          widget.parentActionUpdates('assets/images/plants/drink0water0.png');
//          widget.parentActionBAC(currentTime);
//          widget.parentAction(
//              'assets/images/plants/drink${bacToPlant()}water${waterToPlant()}.png');

        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[700],
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                  )
                ],
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Image.asset(
                  'assets/images/soloCupButton.png',
                  width: MediaQuery.of(context).size.width/5)),
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

    //print(globals.today.toString());
    dbHelper.updateDay(globals.today);
  }

// turns the BAC to a plant stage
// where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac/.12)).floor();
    plantNum = plantNum > 4 ? 4 : plantNum;

    return plantNum;
  }

// turns the water count into a plant stage
  int waterToPlant() {
    int plantNumWater = globals.today.getTotalWaters();
    plantNumWater = plantNumWater > 5 ? 5 : plantNumWater;
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
          Container(
              decoration: new BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[700],
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(1, 1),
                  )
                ],
                borderRadius: BorderRadius.circular(1000),
              ),
              child: Image.asset(
                'assets/images/waterCupButton.png',
                width: MediaQuery.of(context).size.width/5,
              )),
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

    //print(globals.today.toString());
    await dbHelper.updateDay(globals.today);
  }

  // turns BAC into a plant stage
  // where 5 is the number of plant stages we have and .12 is our "max" BAC
  int bacToPlant() {
    int plantNum = (5 * (globals.bac / .12)).floor();
    plantNum = plantNum > 4 ? 4 : plantNum;
    return plantNum;
  }

  // turns the waterCount into a plant stage
  int waterToPlant() {
    int plantNumWater = globals.today.getTotalWaters();
    plantNumWater = plantNumWater > 5 ? 5 : plantNumWater;
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
  DateTime time = DateTime.now();
  DateTime yesterday;
  //DateTime tdn;
  yesterday = new DateTime(time.year, time.month, time.day - 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
  if (time.hour < 12) {
    time = yesterday;
  }


  String todayDate = dateTimeToString(time);

  List<Map> result;

  Database db = await DatabaseHelper.instance.database;
  result = await db.rawQuery('SELECT * FROM days WHERE day=?', [todayDate]);


  Day day;
  print(result);
  List<int> dbListH, dbListM, dbListT;
  if ((result == null) || (result.isEmpty)) {
    day = new Day(date: todayDate, hourList: new List<int>(), minuteList: new List<int>(), typeList: new List<int>(), maxBAC: 0.0, waterAtMaxBAC: 0, totalDrinks: 0, totalWaters: 0);
    await db.insert(tableDays, day.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    globals.dayEnded = true;
    return day;
  }

  else {
    print("result: ");
    print(result[0]['hourList']);

    if (result[0]['hourlist'] == null) {
      dbListH = [];
      dbListM = [];
      dbListT = [];
    }
    else {
      dbListH = new List<int>.from(result[0]['hourlist']);
      dbListM = new List<int>.from(result[0]['minutelist']);
      dbListT = new List<int>.from(result[0]['typelist']);

    }


    day = new Day(date: result[0]["day"], hourList: dbListH, minuteList: dbListM,
        typeList: dbListT, maxBAC: result[0]['maxBAC'], waterAtMaxBAC: result[0]["WateratmaxBAC"],
        totalDrinks: result[0]["totaldrinkcount"], totalWaters: result[0]["totalwatercount"]);

    return day;
  }
}

// sets the global variables for yesterday's drinks and waters
// if the day has "ended" as indicated by determine day
Future<void> getDayEnded() async {
  if (globals.dayEnded) {
    DateTime time = DateTime.now();
    DateTime yesterday;

    yesterday = new DateTime(time.year, time.month, time.day - 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);

    String yesterDate = dateTimeToString(yesterday);
    List<Map> result;

    Database db = await DatabaseHelper.instance.database;

    List<Map> yesterdayResult = await db.rawQuery('SELECT * FROM days WHERE day=?', [yesterDate]);
    if (yesterdayResult.isEmpty){
      //call alert w/ 0s
      globals.yesterDrink = 0;
      globals.yesterWater = 0;
    }
    else {
      int d = yesterdayResult[0]["totaldrinkcount"];
      int w = yesterdayResult[0]['totalwatercount'];
      //call alert w/ d & w
      globals.yesterDrink = d;
      globals.yesterWater = w;
    }
  }

}
