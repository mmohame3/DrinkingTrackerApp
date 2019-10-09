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
        backgroundColor: Color(0xFFA8C935),
      ),
      body: new Text("We aim to provide a mechanism to drink in a safe,"
          "healthy, and enticing way via a drinking tracker that gives a visual"
          "representation of Blood Alcohol Content"
          ""
          "It's easy to binge drink and lose track of alcohol consumption and we hope "
          "to provide an emotional incentive to monitor wellbeing and drinking habits."),
    );
  }
}
