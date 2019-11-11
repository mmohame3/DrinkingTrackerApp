import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;




Future<void> dayEndAlert(BuildContext context) {
//  print(globals.dayEnded);
//  print(globals.yesterDrink);
//  print(globals.yesterWater);
  if (globals.dayEnded) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Day Completed'),
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

Future<void> settingsAlert(BuildContext context) async {
  SharedPreferences _prefs;
  _prefs = await SharedPreferences.getInstance();
  if ((_prefs.getInt("feet") == 0) && (_prefs.getInt('inches') == 0)
      && (_prefs.getInt('weight') == 180) && (_prefs.getString('sex') == "Other")) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Input your height and sex for a more accurate BAC calculation'),
          content: Text(
              'You can do so in "Settings" in the upper right'),
          actions: <Widget>[
            FlatButton(
              child: Text('Got It'),
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
