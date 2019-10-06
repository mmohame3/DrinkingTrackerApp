import 'package:flutter/material.dart';

class AlcoholInfoPage extends StatefulWidget {
  @override
  _AlcoholInfoPageState createState() => new _AlcoholInfoPageState();
}

class _AlcoholInfoPageState extends State<AlcoholInfoPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Alcohol Facts and Information')
      ),
    );
  }
}
