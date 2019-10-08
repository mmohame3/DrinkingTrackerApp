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
        home: AppHome()
    );
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
                  '0.00', // TODO: substitute for BAC Variable
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

    Widget drinkEntryButtons = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new DrinkButton(),
          Spacer(),
          new WaterButton(),
        ],
      ),
    );

    Widget plant = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/images/plantSetting.png',
          height: 344,
          width: 375,
        ),
        Image.asset(
          'assets/images/plants/drink0water0.png',
          height: 174,
          width: 180,
        ),
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
          drinkEntryButtons,
        ],
      ),
    );
  }
}



class DrinkButton extends StatefulWidget {
  @override
  _DrinkButtonState createState() => new _DrinkButtonState();
}

class _DrinkButtonState extends State<DrinkButton> {


  @override
  Widget build(context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              globals.drinkCount++;
              print(globals.drinkCount);
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
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


class WaterButton extends StatefulWidget {
  @override
  _WaterButtonState createState() => new _WaterButtonState();
}

class _WaterButtonState extends State<WaterButton> {

  @override
  Widget build(context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              globals.waterCount++;
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
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//class PlantImage extends StatefulWidget {
//  @override
//  _PlantImageState createState() => new _PlantImageState();
//}
//
//class _PlantImageState extends State<PlantImage> {
//  $_drinkCount
//}

//class HistoryPage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    reutrn Scaffold(
//    appBar: AppBar(
//      title: Text('History'),
//      backgroundColor: Colors.grey[600],
//    ),
//    body:
//    )
//  }
//}

//class DrinkButton extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      onTap: _incrementCounter,
//      child: Image.asset(
//        'assets/images/soloCup.png',
//        height: 71,
//        width: 71,
//      ),
//    );
//  }
//}
