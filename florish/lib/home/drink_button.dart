import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/database_helper.dart';
import 'dart:async';
import 'package:Florish/functions/personal_info_alert.dart';
import 'package:Florish/home/home_screen_widgets.dart';
import 'package:Florish/functions/speed_alert.dart';
import 'package:Florish/home/home_screen_layout.dart';


import 'package:Florish/models/notification.dart';

class DrinkButton extends StatefulWidget {
  final ValueChanged<String> parentActionUpdates;
  const DrinkButton({Key key, this.parentActionUpdates}) : super(key: key);

  @override
  _DrinkButtonState createState() => new _DrinkButtonState();
}

class _DrinkButtonState extends State<DrinkButton> {
  final dbHelper = DatabaseHelper.instance;
  String drinkString = "";

  /// determines the day and sets variables before building
  _DrinkButtonState() {
    determineDay().then((day) => setState(() {
          globals.today = day;
          drinkString = day.totalDrinks.toString();
        }));
  }

  @override
  Widget build(context) {
    return GestureDetector(
      /// when tapped: updates today's counts, updates the drinkString,
      /// updates BAC, updates the plant image, and calls drinkButtonTap
      onTap: () {
        setState(() {
          globals.today.totalDrinks++;
          drinkString = globals.today.totalDrinks.toString();
          drinkButtonTap();
          widget.parentActionUpdates('assets/plants/drink0water0.png');
          globals.today.addConstantBAC((globals.bac * 1000).round());
          globals.today.lastBAC = globals.bac;
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
              child: Image.asset('assets/soloCupButton.png',
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

  /// Updates today's time and type lists,
  /// updates the database itself
  Future<void> drinkButtonTap() async {
    drinkRiseAnimationController.forward(from: 0.0);

    DateTime now = DateTime.now().toUtc().add(
        Duration(hours:1),
      );
      singleNotification(
        now,
        "Log Your Drinks",
        "Remember to log your drinks as accurately as possible!",
        98123871,
      );

    DateTime currentTime = DateTime.now();
    globals.today.addHour(currentTime.hour);
    globals.today.addMinute(currentTime.minute);
    globals.today.addType(1);
    speedAlert(context);
    dbHelper.updateDay(globals.today);
  }
}
