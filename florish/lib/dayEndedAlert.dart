import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;




Future<void> dayEndAlert(BuildContext context) {
  print(globals.dayEnded);
  print(globals.yesterDrink);
  print(globals.yesterWater);
  if (globals.dayEnded) {
    return showDialog<void>(
      context: context,
      //barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Day Ended'),
          content: Text(
              'Yesterday you had ${globals.yesterDrink} drinks and ${globals
                  .yesterWater} waters'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

