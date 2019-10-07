import 'package:flutter/material.dart';

class StandardDrinkPage extends StatefulWidget {
  @override
  _StandardDrinkPageState createState() => new _StandardDrinkPageState();
}

class _StandardDrinkPageState extends State<StandardDrinkPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('What is a "Standard Drink"'),
        backgroundColor: Color(0xFFA8C935),
      ),
    );
  }
}
