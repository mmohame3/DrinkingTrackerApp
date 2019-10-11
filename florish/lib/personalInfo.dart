import 'package:flutter/material.dart';

import 'PersonalEntryData.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => new _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Your Personal Information'),
        backgroundColor: Color(0xFF97B633),
      ),

    body: new PersonalEntryData(),

    );

  }
}