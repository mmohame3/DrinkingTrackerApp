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
    );
  }
}
