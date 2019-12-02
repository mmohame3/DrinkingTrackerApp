import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/helpers/database_helpers.dart';
import 'dart:async';
import 'package:Florish/alerts.dart';
import 'package:Florish/homeScreen/homeScreenLayout.dart';

import '../helpers/notifications.dart';

class DrinkButton extends StatefulWidget {
  final ValueChanged<String> parentActionUpdates;
  const DrinkButton({Key key, this.parentActionUpdates}) : super(key: key);

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
          globals.inSession = true;
          if (globals.bac == 0.0) {
            globals.start = true;
            //inSession = true;
            //print("inSession: ${globals.inSession}, start: ${globals.start}");
          }
          globals.today.totalDrinks++;
          drinkString = globals.today.totalDrinks.toString();
          drinkButtonTap();
          print(globals.today.totalDrinks.toString());
          widget.parentActionUpdates('assets/images/plants/drink0water0.png');
          settingsAlert(context);
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
              child: Image.asset('assets/images/soloCupButton.png',
                  width: MediaQuery.of(context).size.width / 5)),
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
  Future<void> drinkButtonTap() async {
     DateTime now = DateTime.now().toUtc().add(
        Duration(seconds:30),
      );
      singleNotification(
        now,
        "Notification",
        "This is a notification",
        98123871,
      );
     
    if (globals.start) {
      globals.today.addStartEnd(globals.today.typeList.length);
    }
    globals.start = false;
    DateTime currentTime = DateTime.now();
    globals.today.addHour(currentTime.hour);
    globals.today.addMinute(currentTime.minute);
    globals.today.addType(1);
    globals.today.lastBAC = globals.bac;
    dbHelper.updateDay(globals.today);
  }
}
