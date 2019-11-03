import 'package:flutter/material.dart';

class OurMissionPage extends StatefulWidget {
  @override
  _OurMissionPageState createState() => new _OurMissionPageState();
}

class _OurMissionPageState extends State<OurMissionPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Our Mission'),
          backgroundColor: Color(0xFF97B633),
        ),
        backgroundColor: Colors.grey[600],
        body: Container(
            color: Color(0xFFE6E7E8),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
                  child: Text(
                    'OUR MISSION',
                    style: TextStyle(letterSpacing: 1, height: 1.5),
                  )),
              Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        "We aim to provide a mechanism to drink in a safe, "
                            "healthy, and enticing way via a drinking tracker that gives a visual "
                            "representation of Blood Alcohol Content. \n\n"
                            "It's easy to binge drink and lose track of alcohol consumption and we hope "
                            "to provide an emotional incentive to monitor well-being and drinking habits.",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            height: 1.3,
                            color: Colors.black)),
                  )),
              Container(
                  padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
                  child: Text(
                    'DISCLAIMER',
                    style: TextStyle(letterSpacing: 1, height: 1.5),
                  )),
              Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Text(
                        "Florish is an app to help people keep track of their drinking. "
                            "It is not a scientific or precise way to monitor your BAC.",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            height: 1.3,
                            color: Colors.black)),
                  ))
            ])));
  }
}