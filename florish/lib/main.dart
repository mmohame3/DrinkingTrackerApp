// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//import 'package:florish/personalInfo.dart' as prefix0;
import 'package:Florish/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;


import './history.dart';
import './personalInfo.dart';
import './standardDrink.dart';
import './alcoholInfo.dart';
import './ourMission.dart';
import './resources.dart';
import './termsConditions.dart';
import './alternatePersonalInformation.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Plant Nanny',
        theme: ThemeData(fontFamily: 'Montserrat'),
        home: AppHomeScreen(),
    );
  }
}

class AppHomeScreen extends StatefulWidget {
  @override
  _AppHomeScreenState createState() => _AppHomeScreenState();
}

class _AppHomeScreenState extends State<AppHomeScreen> {
  String bacValue = "0.0";

  @override
  void initState() {
    super.initState();
    //calBac();
  }

  @override
  Widget build(BuildContext context) {

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
        padding: EdgeInsets.only(left: 10),
        color: Color(0xFF97B633),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "MY PLANT",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
              ),
              onTap: () {
                Navigator.pop(context);
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                "HISTORY",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
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
                "PERSONAL INFORMATION",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) =>
//                        new PersonalInfoPage()));
                        new altPersonalInfoPage()));
              },
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
            ),
            ListTile(
              title: Text(
                'A "STANDARD DRINK"',
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
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
                "ALCOHOL FACTS",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
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
                "HELP & RESOURCES",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
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
                "OUR MISSION",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
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
                "TERMS & CONDITIONS",
                style: TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', letterSpacing: 1),
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
        title: Text(
          "FLORISH",
          style: TextStyle(
            fontFamily: 'Montserrat',
            letterSpacing: 3,
          ),
        ),
        backgroundColor: Color(0xFF97B633),
      ),
      drawer: menu,
      backgroundColor: Colors.grey[600],
      body: plant,
//      ListView(
//        children: [
//          plant,
//        ],
//      ),
    );
  }
//  calBac(){
//    getBac().then((data) {
//
//        setState(() {
//          bacValue = data;
//        });
//
//    }, onError: (e) {
//      print(e);
//    });
//
//  }
//  Future <String> getBac()  async {
//    SharedPreferences pref =  await SharedPreferences.getInstance();
//    int selectedFeet = pref.getInt('feet');
//    int selectedInches = pref.getInt('inches');
//    String selectedGender = pref.getString(AppConstants.PREF_GENDER);
//    int selectedWeight = pref.getInt('weight');
//    double r ;
//
//    if(selectedGender.toLowerCase() == 'Male'.toLowerCase()){
//      r = 0.68;
//    }else{
//      r= 0.55;
//    }
//
//    int SelectedHeight = selectedFeet + (selectedInches*0.0833333.floor());
//    int usStandardDrink = 14;
//
//    int bacCal =(((globals.drinkCount*14)/selectedWeight*r)*100).floor();
//    return bacCal.toString();
//  }
}



class Plant extends StatefulWidget {
  @override
  _PlantState createState() => new _PlantState();
}

class _PlantState extends State<Plant> {
  String imageName = 'assets/images/plants/drink0water0.png';
  double bac = 0;

  @override
  void initState() {
    super.initState();
  }


  _updateImageName(String path) {
    setState(() {
      imageName = path;
    });
  }

  _updateBAC(currentTime) {
    setState(() {
        globals.drinkTimes.add(currentTime);
        bac = _bacMath(currentTime, globals.drinkTimes);
    });
  }

  _bacMath(currentTime, drinkTimeList) {
    bac = 0;
    double r;
    Duration elapsedTime;
    if(globals.selectedGender == 'Male'){
      r = 0.68;
    }
    else if (globals.selectedGender == 'Female'){
      r= 0.55;
    }
    else {
      r = 0.615;
    }
    for (int i = 0; i < drinkTimeList.length; i++) {
      //print(drinkTimeList);
      elapsedTime = currentTime.difference(drinkTimeList[i]);
      //print(elapsedTime);
      bac += ((14/(globals.weightGrams*r))*100) - ((elapsedTime.inSeconds / 3600) *.015);
      print(bac);
    }
    return bac;
  }

  @override
  Widget build(context) {
    return Column(
      children: [
          Container(
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
                      fontSize: 12
                      ),
                    ),
                  ),
    // BAC variable
                    Text(
    //globals.bac.toString(),
                    bac.toStringAsFixed(2),
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
          ),
        Column(
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
                parentActionBAC: _updateBAC
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
    ),
    ],
    );
  }
}

class DrinkButton extends StatefulWidget {
  final ValueChanged<String> parentAction;
  final ValueChanged<DateTime> parentActionBAC;
  const DrinkButton({Key key, this.parentAction, this.parentActionBAC}) : super(key: key);


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
              'assets/images/plants/drink${globals.drinkCount}water${globals.waterCount}.png');
          widget.parentActionBAC(
            DateTime.now());
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
              'assets/images/plants/drink${globals.drinkCount}water${globals.waterCount}.png');
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
