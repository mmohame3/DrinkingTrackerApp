import 'package:flutter/material.dart';

class StandardDrinkPage extends StatefulWidget {
  @override
  _StandardDrinkPageState createState() => new _StandardDrinkPageState();
}

class _StandardDrinkPageState extends State<StandardDrinkPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar (
          title: new Text('A "Standard Drink"'),
          backgroundColor: Color(0xFFA8C935),
        ),
        backgroundColor: Colors.grey[600],
        body: new Column(
          children: [
            Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.topCenter,
              width: 800,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFA8C935), width: 7.0),
                ),
              child: Text('\t In the United States, one "standard drink" contains approximately '
              "14 grams of pure alcohol, which is found in:"
              "\n 12 oz of beer (5% alcohol),"
              "\n 5 oz of wine (12% alcohol),"
              "\n 1.5 oz of liquor(40% alcohol) "
              "\n\n\t In Florish, by clicking the drink button, you are indicating "
              "that you just had one standard drink.",
              style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              width: 800,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFA8C935), width: 7.0),
              ),
              child: Text("\t In Florish, when you click the drink button you are indicating "
            "that you just had one standard drink.",
            style: TextStyle(fontSize: 20, color: Colors.black)),
    )
          ]
        )
    );

  }
}
