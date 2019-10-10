// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'globals.dart' as globals;

import './history.dart';
import './personalInfo.dart';
import './standardDrink.dart';
import './alcoholInfo.dart';
import './ourMission.dart';
import './resources.dart';
import './termsConditions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Plant Nanny',
        theme: ThemeData(fontFamily: 'Montserrat'),
        home: AppHome());
  }
}

class AppHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // top row
    Widget bacHeader = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
//           room  between
          Spacer(
            flex: 2,
          ),
//          text column with BAC label and variable
          Expanded(
            child: Column(
              children: [
                Container(
                  // BAC label
                  child: Text(
                    'BAC:',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                // BAC variable
                Text(
                  globals.bac.toString(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // blood drop
          Image.asset(
            'assets/images/bacDrop.png',
            height: 42,
            width: 28,
          ),
        ],
      ),
    );

    Widget plant = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 100),
          child: Image.asset(
            'assets/images/plantSetting.png',
          ),
        ),
        new Plant(),
      ],
    );

    Widget menu = Drawer(
      child: Container(
        color: Color(0xFFA8C935),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "My Plant",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "History",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => new HistoryPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "Personal Information",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new PersonalInfoPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                'A "Standard Drink"',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new StandardDrinkPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "Alcohol Facts",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new AlcoholInfoPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "Help & Resources",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new ResourcesPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "Our Mission",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new OurMissionPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "Terms & Conditions",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
                            new TermsConditionsPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
          ],
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("FLORISH"),
        backgroundColor: Colors.green[700],
      ),
      drawer: menu,
      backgroundColor: Colors.grey[600],
      body: ListView(
        children: [
          bacHeader,
          plant,
        ],
      ),
    );
  }
}

class Plant extends StatefulWidget {
  @override
  _PlantState createState() => new _PlantState();
}

class _PlantState extends State<Plant> {
  String imageName = 'assets/images/plants/drink0water0.png';

  @override
  void initState() {
    super.initState();
  }

  _updateImageName(String path) {
    setState(() {
      imageName = path;
      print(imageName);
    });
  }

  @override
  Widget build(context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Image.asset(imageName, width: 180),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: new DrinkButton(
                parentAction: _updateImageName,
              ),
            ),
            Expanded(
              child: new WaterButton(
                parentAction: _updateImageName,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DrinkButton extends StatefulWidget {
  final ValueChanged<String> parentAction;
  const DrinkButton({Key key, this.parentAction}) : super(key: key);

  @override
  _DrinkButtonState createState() => new _DrinkButtonState();
}

class _DrinkButtonState extends State<DrinkButton> {
  @override
  Widget build(context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (globals.drinkCount < 4) {
            globals.drinkCount++;
          }
          widget.parentAction(
              'assets/images/plants/drink${globals.drinkCount}water${globals
                  .waterCount}.png');
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/soloCup.png',
            height: 71,
            width: 71,
          ),
          Text(
            globals.drinkCount.toString(),
            style: TextStyle(
              fontSize: 25,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }
}

class WaterButton extends StatefulWidget {
  final ValueChanged<String> parentAction;
  const WaterButton({Key key, this.parentAction}) : super(key: key);

  @override
  _WaterButtonState createState() => new _WaterButtonState();
}

class _WaterButtonState extends State<WaterButton> {
  @override
  Widget build(context) {
    return GestureDetector(
          onTap: () {
            setState(() {
              if (globals.waterCount < 2) {
                globals.waterCount++;
              }
              widget.parentAction(
                  'assets/images/plants/drink${globals.drinkCount}water${globals
                      .waterCount}.png');
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/waterCup.png',
                height: 71,
                width: 71,
              ),
              Text(
                globals.waterCount.toString(),
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
    );
  }
}

//Widget plant = Stack(
//  alignment: Alignment.bottomCenter,
//  children: [
//    Image.asset(
//      'assets/images/plantSetting.png',
//      height: 344,
//      width: 375,
//    ),
//    Image.asset(
//      'assets/images/plants/drink0water0.png',
//      height: 174,
//      width: 180,
//    ),
//  ],
//);
