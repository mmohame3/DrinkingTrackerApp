import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'package:Florish/pages/PersonalInformation.dart';



Future<void> settingsAlert(BuildContext context) async {
  if ((globals.selectedFeet == 0) && (globals.selectedInches == 0)
      && (globals.selectedWeight == 180) && (globals.selectedSex == "Other")) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('Input your height and sex for a more accurate BAC calculation'),
          actions: <Widget>[
            FlatButton(
              child: Text('Got It'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold),),
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new PersonalInfoPage()));
              },
            ),
          ],
        );
      },
    );
  }
}
