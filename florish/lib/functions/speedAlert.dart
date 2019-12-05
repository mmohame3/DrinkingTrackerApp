import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;


Future<void> speedAlert(BuildContext context) async {
  int length = globals.today.hourList.length;
  if (length > 2) {
    if ((globals.today.hourList[length - 1] ==
        globals.today.hourList[length - 2])
        && (globals.today.minuteList[length - 1] ==
            globals.today.minuteList[length - 2])
        && (globals.today.hourList[length - 2] ==
            globals.today.hourList[length - 3])
        && (globals.today.minuteList[length - 2] ==
            globals.today.minuteList[length - 3])) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("You've had more than two drinks in the last minute"),
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
