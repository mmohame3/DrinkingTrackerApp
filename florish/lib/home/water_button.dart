import 'package:Florish/home/home_screen_layout.dart';
import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/database_helper.dart';
import 'package:Florish/home/home_screen_widgets.dart';
import 'package:Florish/functions/speed_alert.dart';

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
    determineDay().then((day) {
      globals.today = day;
      waterString = day.totalWaters.toString();
    });
  }

  @override
  Widget build(context) {
    return GestureDetector(
      // when tapped: updates today's count, updates waterString,
      // updates the plant image, and calls waterButtonTap()
      onTap: () {
        setState(() {
          globals.today.totalWaters++;
          waterString = globals.today.totalWaters.toString();
          waterButtonTap();
          widget.parentAction('assets/plants/drink0water0.png');
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
                'assets/waterCupButton.png',
                width: MediaQuery.of(context).size.width / 5,
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
  void waterButtonTap() async {
    waterRiseAnimationController.forward(from: 0.0);
    globals.today.addHour(DateTime.now().hour);
    globals.today.addMinute(DateTime.now().minute);
    globals.today.addType(0);
    globals.today.addConstantBAC(0);
    speedAlert(context);
    await dbHelper.updateDay(globals.today);
  }
}
