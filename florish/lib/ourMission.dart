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
            color: Color(0xFFF2F2F2),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.width / 20,
                      left: MediaQuery.of(context).size.width / 20,
                      bottom: MediaQuery.of(context).size.width / 100),
                  child: Text(
                    'OUR MISSION',
                    style: TextStyle(letterSpacing: 1, height: 1.5),
                  )),
              Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
                    child: Text(
                        "FLORISH, as a college student developed app, provides a platform for increased "
                            "awareness of drinking levels in any scenario.  Specifically, FLORISH is catered towards college students, who often binge drink and lose track of their Alcohol intake levels, jeopardizing their own safety, as well as that of those around them."
                            " In turn, FLORISH provides a visual indicator of their BAC as an incentive to monitor their wellbeing and drinking habits. \n\n"
                            "Through the plant icon, FLORISH seeks to create accountability amongst each user in keeping their plant healthy. The essential vision is"
                            " to provide an emotional incentive to monitor well-being and Alcohol intake habits, through attachment to the plant's health in relation to BAC.",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            height: 1.3,
                            color: Colors.black)),
                  )),
              Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width / 20,
                      left: MediaQuery.of(context).size.width / 20,
                      bottom: MediaQuery.of(context).size.width / 100),
                  child: Text(
                    'DISCLAIMER',
                    style: TextStyle(letterSpacing: 1, height: 1.5),
                  )),
              Container(
                  color: Colors.white,
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width / 20),
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