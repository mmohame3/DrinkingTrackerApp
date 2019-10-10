import 'package:flutter/material.dart';

class OurMissionPage extends StatefulWidget {
  @override
  _OurMissionPageState createState() => new _OurMissionPageState();
}

class _OurMissionPageState extends State<OurMissionPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar (
          title: new Text('Our Mission'),
        backgroundColor: Color(0xFFA8C935),
      ),
      backgroundColor: Colors.grey[600],
      body: Container(
        margin: EdgeInsets.all(30.0),
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        width: 800,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFA8C935), width: 7.0),
        ),
        child: Text("\t We aim to provide a mechanism to drink in a safe,"
          "healthy, and enticing way via a drinking tracker that gives a visual"
          "representation of Blood Alcohol Content."
          "\n"
          "\n"
          "\t It's easy to binge drink and lose track of alcohol consumption and we hope "
          "to provide an emotional incentive to monitor well-being and drinking habits.",
          style: TextStyle(fontSize: 20, color: Colors.black)),
      )
    );


  }
}
