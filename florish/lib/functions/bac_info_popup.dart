import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/pages/calendar_page.dart';
import 'package:Florish/models/popup_model.dart';
import 'package:url_launcher/url_launcher.dart';

List<TimeSeriesBac> bacChartData = List<TimeSeriesBac>();

showBACPopup(BuildContext context) {
  Navigator.push(
      context,
      PopupLayout(
          top: 15,
          bottom: 15,
          left: 20,
          right: 20,
          child: PopupContent(
            content: Scaffold(
              appBar: AppBar(
                title: Text('BAC Information'),
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
              body: bacPopUpBody(context),
            ),
          )));
}

Widget bacPopUpBody(BuildContext context) {
//  double bacLater = (globals.bac - .08 )/.015;
//  double bacToZero = globals.bac/.05;
//  bacLater = bacLater < 0 ? 0 : bacLater;
  return Container(
      color: Color(0xFFF2F2F2),
      child: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bacText(context),
                    Container(
                        padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
                        child: Text(
                          'WHAT IS BAC?',
                          style: TextStyle(letterSpacing: 1, height: 1.5),
                        )),
                    Container(
                        color: Colors.white,
                        alignment: Alignment.topCenter,
                        child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(children: [
                              Container(
//                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                      "Blood Alcohol Concentration (BAC) refers to the percent of "
                                      "alcohol in a person's blood stream."
                                      "\n\nIn the U.S., a person is legally intoxicated if they have a BAC of .08% or higher.\n"
                                      "\nIn Florish, your BAC is calculated using the Widmark Formula which takes into account your "
                                      "weight, sex, and the time between each drink. When you take a drink, your BAC goes up "
                                      "based on these factors and over time, it drops by .015% per hour.\n",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          height: 1.3,
                                          color: Colors.black))),
                              CupertinoButton(
                                onPressed: _launchBacInfoURL,
                                color: Color(0xFFA8C935),
                                child: Text('More BAC Information',
                                    style: TextStyle(color: Colors.white)),
                              )
                            ]))),
                  ]))));
}

_launchBacInfoURL() async {
  const url = 'https://www.teamdui.com/bac-widmarks-formula/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget bacText(BuildContext context) {
  double bacLater = (globals.bac - .08) / .015;
  double bacToZero = globals.bac / .015;
  bacLater = bacLater < 0 ? 0 : bacLater;
  var container = Column();
  if (globals.bac > 0) {
    container = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
          padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
          child: Text(
            'YOUR BAC',
            style: TextStyle(letterSpacing: 1, height: 1.5),
          )),
      Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                height: 1.3,
                                color: Colors.black),
                            children: [
                          TextSpan(
                            text: "Your BAC is ",
                          ),
                          TextSpan(
                              text: '${globals.bac.toStringAsFixed(3)}% ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  "so you may be feeling: \n\n${_getBacInfo(globals.bac)}"),
                        ])),
                    Column(children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  height: 1.3),
                              children: [
                            TextSpan(
                                text:
                                    "\nGiven your current BAC, it will take about:\n  •   "),
                            TextSpan(
                                text:
                                    ' ${bacToZero.toStringAsFixed(1)} hours to fall to 0% \n',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    '  •    ${bacLater.toStringAsFixed(1)} hours to fall to .08%\n'),
                          ]))
                    ]),
                  ]))),
      Container(
          padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
          child: Text(
            'YOUR BAC OVER TIME',
            style: TextStyle(letterSpacing: 1, height: 1.5),
          )),
      Container(
        color: Colors.white,
        alignment: Alignment.topCenter,
        height: 7*MediaQuery.of(context).size.height / 24,
        child: BacChart(day: globals.today),
      ),
    ]);
  }
  return container;
}

String _getBacInfo(double bac) {
  //switch statements.....
  String effects;
  if (bac < .02) {
    effects =
        "Relaxed with few obvious effects other than a slight intensification of mood";
  }

  if ((bac >= 0.020) && (bac < 0.04)) {
    effects = "In a relaxed vibe. You still have balance!";
  }

  if ((bac >= .04) && (bac < 0.06)) {
    effects =
        "Incredibly loose as if you are starting to forget the manners people expect of you. Impaired judgement and explosions of joy describe your current state.";
  }

  if ((bac >= .06) && (bac < 0.1)) {
    effects =
        "Tumbling and loss of balance. Slurring words, slowed reactions, and out of pocket actions describe your current state. Find a sober friend!";
  }

  if ((bac >= .1) && (bac < 0.13)) {
    effects =
        "Loss of balance, impaired speech, and lack of judgment. Find a sober friend!";
  }

  if ((bac >= .13) && (bac < 0.16)) {
    effects =
        "Impairement in all physical and mental functions. Depression begins to set in at this stage, find support.";
  }

  if ((bac >= .16) && (bac < 0.2)) {
    effects =
        "Nausea and negative feelings, the so called sloppy drunk stage. Seek help.";
  }

  if ((bac >= .2) && (bac < 0.25)) {
    effects =
        "Mental confusion, blackout level, memory impairment. Support is needed as soon as possible.";
  }

  if ((bac >= .25) && (bac < 0.4)) {
    effects = "Alcohol poisoning, emergency help needed!";
  }

  if (bac >= .4) {
    effects = "Deadly level, emergency attention demanded.";
  }

  return effects;
}
