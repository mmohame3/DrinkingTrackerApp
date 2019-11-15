import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helpers.dart' as database;
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
import 'models/inputModel.dart';

final dbHelper = database.DatabaseHelper.instance;

class PersonalInfoPage extends StatefulWidget {
  @override
  PersonalInfoPageState createState() => new PersonalInfoPageState();
}

class PersonalInfoPageState extends State<PersonalInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // _initSharedPref();
    getInputInformation();
    // _getWeight();
    // _getHeight();
  }

  // _initSharedPref() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   _getHeight();
  //   _getWeight();
  // }


  int initialFeet = 0;
  database.Day day = globals.today;
  var _databaseHelper = database.DatabaseHelper.instance;

  addIntToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('weight', globals.selectedWeight);
    prefs.setInt('feet', globals.selectedFeet);
    prefs.setInt('inches', globals.selectedInches);
    prefs.setString("sex", globals.selectedSex);
  }

  getInputInformation() async {
    var _inputInformation = await _databaseHelper.getInputInformation();
    _inputInformation.forEach((input){
      setState(() {
        globals.selectedFeet = input['feet'];
        globals.selectedInches = input['inch'];
        globals.selectedWeight = input['weight'];
        globals.selectedSex = input['gender'];
      });
    });
  }

  _showSnackBar(message) {
    var _snackBar = SnackBar(
      content: message,
    );
    _scaffoldKey.currentState.showSnackBar(_snackBar);
  }

  getValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.selectedFeet = prefs.getInt('feet');
    globals.selectedInches = prefs.getInt('inches');
    globals.selectedWeight = prefs.getInt('weight');
    globals.selectedSex = prefs.getString('sex');
  }

  String drinkString = globals.today.totalDrinks.toString();
  String waterString = globals.today.totalWaters.toString();
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Your Personal Information'),
          backgroundColor: Color(0xFF97B633),
          leading: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AppHomeScreen()));
              },
              child: Icon(Icons.arrow_back_ios)),
        ),
        body: Scaffold(
            key: _scaffoldKey,
            body: Container(
              color: Color(0xFFF2F2F2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width / 20,
                          left: MediaQuery.of(context).size.width / 20),
                      child: Text('YOUR PROFILE',
                          style: TextStyle(
                              letterSpacing: 1,
                              height: 1.5))), // "Your Profile" label
                  Container(
                    color: Colors.white,
                    child: CupertinoButton(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Height',
                                style: TextStyle(color: Colors.black),
                              ),
                              Text(
                                '${globals.selectedFeet} ft ${globals.selectedInches} in',
                                style: TextStyle(color: Colors.black),
                              ),
                            ]),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Container(
                                  height: 200.0,
                                  color: Colors.white,
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: CupertinoPicker(
                                            scrollController:
                                                new FixedExtentScrollController(
                                              initialItem: globals.selectedFeet,
                                            ),
                                            itemExtent: 32.0,
                                            backgroundColor: Colors.white,
                                            onSelectedItemChanged: (int index) {
                                              setState(() {
                                                globals.selectedFeet = index;
                                                save();
                                                addIntToSF();
                                              });
                                            },
                                            children: new List<Widget>.generate(
                                                8, (int index) {
                                              return new Center(
                                                child: Text(index.toString()),
                                              );
                                            })),
                                      ),
                                      Expanded(
                                        child: CupertinoPicker(
                                            scrollController:
                                                new FixedExtentScrollController(
                                              initialItem:
                                                  globals.selectedInches,
                                            ),
                                            itemExtent: 32.0,
                                            backgroundColor: Colors.white,
                                            onSelectedItemChanged: (int index) {
                                              setState(() {
                                                globals.selectedInches = index;
                                                save();
                                                addIntToSF();
                                              });
                                            },
                                            children: new List<Widget>.generate(
                                                13, (int index) {
                                              return new Center(
                                                child: Text(index.toString()),
                                              );
                                            })),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }),
                  ), // height
                  Divider(height: 0.5, thickness: 0.5, indent: 12),
                  Container(
                    color: Colors.white,
                    child: CupertinoButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Weight',
                                style: TextStyle(color: Colors.black)),
                            Text('${globals.selectedWeight} lbs',
                                style: TextStyle(color: Colors.black)),
                          ]),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  height: 200,
                                  child: CupertinoPicker(
                                      scrollController:
                                          new FixedExtentScrollController(
                                        initialItem: globals.weights.indexOf(
                                            globals.selectedWeight.toString()),
                                      ),
                                      itemExtent: 32.0,
                                      backgroundColor: Colors.white,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          globals.selectedWeight =
                                              int.parse(globals.weights[index]);
                                          save();
                                          addIntToSF();
                                        });
                                      },
                                      children: new List<Widget>.generate(
                                          globals.weights.length, (int index) {
                                        return new Center(
                                          child: Text(globals.weights[index]),
                                        );
                                      })));
                            });
                      },
                    ),
                  ), // weight
                  Divider(height: 0.5, thickness: 0.5, indent: 12),
                  Container(
                    color: Colors.white,
                    child: CupertinoButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Sex at birth',
                                style: TextStyle(color: Colors.black)),
                            Text('${globals.selectedSex}',
                                style: TextStyle(color: Colors.black))
                          ]),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                  height: 200,
                                  child: CupertinoPicker(
                                      scrollController:
                                          new FixedExtentScrollController(
                                        initialItem: globals.sexes
                                            .indexOf(globals.selectedSex),
                                      ),
                                      itemExtent: 32.0,
                                      backgroundColor: Colors.white,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          globals.selectedSex =
                                              globals.sexes[index];
                                          save();
                                          addIntToSF();
                                        });
                                      },
                                      children: new List<Widget>.generate(
                                          globals.sexes.length, (int index) {
                                        return new Center(
                                          child: Text(globals.sexes[index]),
                                        );
                                      })));
                            });
                      },
                    ),
                  ), // sex
                  Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width / 20,
                          left: MediaQuery.of(context).size.width / 20),
                      child: Text('DRINK OVERRIDE',
                          style: TextStyle(
                              letterSpacing: 1,
                              height: 1.5))), // "Drink Override" label
                  Container(
                    color: Colors.white,
                    child: CupertinoButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Drink Count',
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                            setState(() {
                                              if (globals.today.totalDrinks > 0) {
                                                globals.today.totalDrinks--;
                                              }
                                              drinkString = globals.today.totalDrinks.toString();
                                              drinkDec(DateTime.now());
                                            });

                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        )),
                                    Text(drinkString,
                                        style: TextStyle(color: Colors.black)),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            globals.today.totalDrinks++;
                                            drinkString = globals.today.totalDrinks.toString();
                                            drinkInc(DateTime.now());
                                          });

                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ))
                                  ],
                                )),
                          ]),
                    ),
                  ), // drinkCount adjuster
                  Divider(height: 0.5, thickness: 0.5, indent: 12),
                  Container(
                    color: Colors.white,
                    child: CupertinoButton(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Water Count',
                              style: TextStyle(color: Colors.black),
                            ),
                            Container(
                                width: MediaQuery.of(context).size.width / 5,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    GestureDetector(
                                        onTap: () {
                                            setState(() {
                                                if (globals.today.totalWaters > 0) {
                                                  globals.today.totalWaters--;
                                                }
                                              waterString = globals.today.totalWaters.toString();
                                                waterDec();
                                            }
                                              );
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        )),
                                    Text(waterString,
                                        style: TextStyle(color: Colors.black)),
                                    GestureDetector(
                                        onTap: () {
                                          setState((){
                                            globals.today.totalWaters++;
                                            waterString = globals.today.totalWaters.toString();
                                            waterInc();
                                          }
                                          );

                                        },
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.black,
                                        ))
                                  ],
                                )),
                          ]),
                    ),
                  ) // waterCount adjuster
                ],
              ),
            )));
  }
  void drinkInc(DateTime currentTime) async {
    globals.today.addHour(currentTime.hour);
    globals.today.addMinute(currentTime.minute);
    globals.today.addType(1);

    await dbHelper.updateDay(globals.today);
  }

  void waterInc() async {
    globals.today.addHour(DateTime.now().hour);
    globals.today.addMinute(DateTime.now().minute);
    globals.today.addType(0);

    await dbHelper.updateDay(globals.today);
  }

  void drinkDec(DateTime currentTime) async {
    if (globals.today.totalDrinks >= 0) {
      int i = globals.today.typeList.lastIndexOf(1);
      if (i >= 0) {
        globals.today.typeList.removeAt(i);
        globals.today.hourList.removeAt(i);
        globals.today.minuteList.removeAt(i);
      }
      await dbHelper.updateDay(globals.today);
    }

  }

  void waterDec() async {
    if (globals.today.totalWaters >= 0 ){
      int i = globals.today.typeList.lastIndexOf(0);
      if (i >= 0) {
        globals.today.typeList.removeAt(i);
        globals.today.hourList.removeAt(i);
        globals.today.minuteList.removeAt(i);
        print(globals.today.totalWaters);
        print(globals.today.typeList);
        await dbHelper.updateDay(globals.today);
      }
    }
  }

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(globals.selectedFeetKey, globals.selectedFeet);
    await prefs.setInt(globals.selectedInchKey, globals.selectedInches);
    await prefs.setInt(globals.selectedWeightKey, globals.selectedWeight);
    await prefs.setString(globals.selectedSexKey, globals.selectedSex);
  }
}
