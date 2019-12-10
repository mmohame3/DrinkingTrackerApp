import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Florish/helpers/database_helpers.dart' as database;
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/homeScreen/homeScreenLayout.dart';
import 'package:Florish/homeScreen/homeScreen.dart';
import 'package:Florish/helpers/inputModel.dart';

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
    getInputInformation();
  }

  int initialFeet = 0;
  database.Day day = globals.today;
  var _databaseHelper = database.DatabaseHelper.instance;

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
                      padding:
                      EdgeInsets.only(top: 15, left: 20, bottom: 5),
                      child: Text(
                        'YOUR PROFILE',
                        style: TextStyle(letterSpacing: 1, height: 1.5),
                      )),
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
                      padding:
                      EdgeInsets.only(top: 15, left: 20, bottom: 5),
                      child: Text(
                        'DRINK OVERRIDE',
                        style: TextStyle(letterSpacing: 1, height: 1.5),
                      )),
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
                                            print(
                                                "totalDrinks = ${globals.today.totalDrinks}");
                                            if (globals.today.totalDrinks > 0) {
                                              globals.today.totalDrinks--;
                                            }
                                            print(
                                                "totalDrinks = ${globals.today.totalDrinks}");
                                            drinkString = globals
                                                .today.totalDrinks
                                                .toString();
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
                                            drinkString = globals
                                                .today.totalDrinks
                                                .toString();
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
                                            waterString = globals
                                                .today.totalWaters
                                                .toString();
                                            waterDec();
                                          });
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        )),
                                    Text(waterString,
                                        style: TextStyle(color: Colors.black)),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            globals.today.totalWaters++;
                                            waterString = globals
                                                .today.totalWaters
                                                .toString();
                                            waterInc();
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
    double r = 0.615;
    if (globals.selectedSex == 'Male') {
      r = 0.68;
    } else if (globals.selectedSex == 'Female') {
      r = 0.55;
    }
    if (globals.today.totalDrinks >= 0) {
      print(globals.today.typeList);
      int i = globals.today.typeList.lastIndexOf(1);
      if (i >= 0) {
        globals.today.typeList.removeAt(i);
        globals.today.hourList.removeAt(i);
        globals.today.minuteList.removeAt(i);
        globals.today.constantBACList.removeLast();
        globals.today.maxBAC = globals.today.maxBAC - (14 / (globals.selectedWeight * 453.592 * r) * 100);
      }
      print("after: ");
      print(globals.today.typeList);
    }
    await dbHelper.updateDay(globals.today);
  }

  void waterDec() async {
    if (globals.today.totalWaters >= 0) {
      int i = globals.today.typeList.lastIndexOf(0);
      if (i >= 0) {
        globals.today.typeList.removeAt(i);
        globals.today.hourList.removeAt(i);
        globals.today.minuteList.removeAt(i);
        print(globals.today.totalWaters);
        print(globals.today.typeList);
      }
    }
    await dbHelper.updateDay(globals.today);
  }

  save() async {
    var inputModel = InputModel();
    inputModel.feet = globals.selectedFeet;
    inputModel.inch = globals.selectedInches;
    inputModel.weight = globals.selectedWeight;
    inputModel.sex = globals.selectedSex;

    var result = await _databaseHelper.saveInputInformation(inputModel.toMap());
    print(result);
  }
}
