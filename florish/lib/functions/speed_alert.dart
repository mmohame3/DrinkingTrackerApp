import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;


Future<void> speedAlert(BuildContext context) async {
  int length = globals.today.hourList.length;
  if (length > 3) {
    if ((globals.today.hourList[length - 1] ==
        globals.today.hourList[length - 2])
        && (globals.today.minuteList[length - 1] ==
            globals.today.minuteList[length - 2])
        && (globals.today.hourList[length - 2] ==
            globals.today.hourList[length - 3])
        && (globals.today.minuteList[length - 2] ==
            globals.today.minuteList[length - 3])
        && (globals.today.hourList[length - 3] ==
            globals.today.hourList[length - 4])
        && (globals.today.minuteList[length - 3] ==
            globals.today.minuteList[length - 4])) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Reminder that Florish's calculations are most accurate "
                "if you log your drinking as you go"),
            content: Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 15)),
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
}
