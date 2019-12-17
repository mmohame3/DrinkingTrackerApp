import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/pages/calendar_page.dart';
import 'package:Florish/models/popup_model.dart';

showDayEndPopup(BuildContext context) {
  Navigator.push(
      context,
      PopupLayout(
          top: 175,
          bottom: 220,
          left: 30,
          right: 30,
          child: PopupContent(
            content: Scaffold(
              appBar: AppBar(
                title: Text('Day Ended'),
                backgroundColor: Color(0xFF97B633),
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      try {
                        Navigator.pop(context); //close the popup
                      } catch (e) {}
                    },
                  )
                ],
              ),
              body: dayEndPopUpBody(context),
            ),
          )));
}

Widget dayEndPopUpBody(BuildContext context) {
  globals.dayEnded = false;
  return Container(
      color: Color(0xFFE6E7E8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                      'Yesterday you had ${globals.yesterDrink} drinks and ${globals.yesterWater} waters. '
                          '\n\nCheck out your Calendar to see more about your past drinking habits.\n',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          height: 1.3,
                          color: Colors.black)),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                              new CalendarPage()));
                    },
                    color: Color(0xFFA8C935),
                    child:
                    Text('Calendar', style: TextStyle(color: Colors.white)),
                  )
                ]))),
      ]));
}