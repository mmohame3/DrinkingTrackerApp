import 'package:flutter/material.dart';
import 'dart:async';
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/helpers/database_helpers.dart';
import 'package:Florish/pages/history.dart';
import 'package:Florish/pages/drinkInformation.dart';
import 'package:Florish/pages/PersonalInformation.dart';
import 'package:Florish/popups.dart';
import 'package:Florish/homeScreen/homeScreenLayout.dart';
import 'package:Florish/homeScreen/waterAnimation.dart';
import 'package:Florish/homeScreen/drinkAnimation.dart';

final int resetTime = 12; //resets counters on this hour
final double maxBAC = 0.12;
final int numberOfDrinkPlants = 5;
final int numberOfWaterPlants = 6;
final double bacDropPerHour = .015;
AnimationController drinkRiseAnimationController, waterRiseAnimationController;
Animation drinkRisePositionAnimation, waterRisePositionAnimation;

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> with TickerProviderStateMixin{
  DatabaseHelper dbHelper = DatabaseHelper.instance;


  @override
  void initState() {
    //uncomment to reset today's data to 0
//    DateTime time = DateTime.now();
//    if (time.hour < resetTime){
//      time = new DateTime(time.year, time.month, time.day - 1, time.hour, time.minute, time.second, time.millisecond, time.microsecond);
//    }
//
//    dbHelper.deleteDay(dateTimeToString(time));
//    dbHelper.resetDay(dateTimeToString(time));

    super.initState();

    drinkRiseAnimationController = new AnimationController(duration: new Duration(milliseconds: 1500), vsync: this);
    drinkRisePositionAnimation = new CurvedAnimation(parent: drinkRiseAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.slowMiddle));

    drinkRisePositionAnimation.addListener((){
      setState(() {});
    });
    drinkRiseAnimationController.addListener(() {
      setState(() {});
    });

    waterRiseAnimationController = new AnimationController(duration: new Duration(milliseconds: 1500), vsync: this);
    waterRisePositionAnimation = new CurvedAnimation(parent: waterRiseAnimationController,
        curve: Curves.slowMiddle);

    waterRisePositionAnimation.addListener((){
      setState(() {});
    });
    waterRiseAnimationController.addListener(() {
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await determineDay();
      if (globals.dayEnded) {
        await getDayEndedPopupInfo();
        showDayEndPopup(context);
      }
      await getInputInformation();
    });
    Widget plant = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.width / 3),
          child: Image.asset(
            'assets/images/plantSetting2.png',
          ),
        ),
        new Plant(),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (BuildContext context) => new HistoryPage()));
            }),
        title: Text(
          "FLORISH",
          style: TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 3,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new StandardDrinkPage()));
              }),
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
      backgroundColor: Colors.grey[600],
      body: Stack(
          children: <Widget>[
            plant,
//            waterAnimation(),
//            drinkAnimation(),
          ],

      ),
    );
  }
}
