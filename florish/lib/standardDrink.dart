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
      body: new Text("In the United States, one 'standard drink contains approximately"
          "14 grams of pure alcohol, which is found in:"
          " 12 OZ regular beer (5% alcohol),"
          " 5 OZ wine (12% alcohol),"
          " 1.5 OZ liquor(40% alcohol"),
    );
  }
}
