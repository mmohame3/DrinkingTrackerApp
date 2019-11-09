import 'package:Florish/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helpers.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helpers.dart' as database;

import 'main.dart';
import 'models/inputModel.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  PersonalInfoPageState createState() => new PersonalInfoPageState();
}

class PersonalInfoPageState extends State<PersonalInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences _prefs;
  
  String _weight ="";
  String _height ="";


  @override
  void initState() {
    super.initState();
    _initSharedPref();
    getInputInformation();
    // _getWeight();
    // _getHeight();
  }

  _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
    _getHeight();
    _getWeight();
  }

  _getWeight() {
    int weight = _prefs?.getInt(globals.selectedWeightKey);
    if(weight != null && weight > 0){
    _weight = 'weight: ${weight} pounds';
    }
      

  
    else{
     _weight = 'Weight:   ${globals.selectedWeight} pounds';
    }
  }

  _getHeight() {
    int height = _prefs?.getInt(globals.selectedHeightKey);
    if(height != null && height > 0)
      _height = 'Height:   $height inches';
      // _height = 'Height:   ${globals.selectedFeet} feet, ${globals.selectedInches} inches';
    else _height = 'Height:   ${globals.selectedHeight} inches';
  }

//  int selectedFeet = 0;
//  int selectedInches = 0;
//  int totalSelectedFeet = 0;
//
//  int selectedWeight = 0;
//  String selectedSex = '';
  int initialFeet = 0;
  database.Day day = globals.today;
  var _databaseHelper = DatabaseHelper.instance;

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
    //initialFeet = prefs.getInt('feet');
    globals.selectedFeet = prefs.getInt('feet');
    globals.selectedInches = prefs.getInt('inches');
    globals.selectedWeight = prefs.getInt('weight');
    globals.selectedSex = prefs.getString('sex');
  }

  @override
  Widget build(BuildContext context) {
    //getValues();
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
//          actions: [
////            FutureBuilder<List>(
////              future: SharedPreferencesHelper.getList(),
////              initialData: [],
////              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
////              },
////            )
//          ],
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
                    child: RaisedButton(
                      child: Text("Save"),
                      onPressed: () async {

                        var inputModel = InputModel();
                        inputModel.feet = globals.selectedFeet;
                        inputModel.inch = globals.selectedInches;
                        inputModel.weight = globals.selectedWeight;
                        inputModel.sex = globals.selectedSex;


                        var result = await _databaseHelper.saveInputInformation(inputModel.toMap());
                        print(result);
                        // await save();

                        _showSnackBar(Text('Saved successfully'));
                        //print("Data are: " + selectedSex + "- " + selectedWeight.toString() + "- " + selectedFeet.toString());
                        addIntToSF();
                        // if(this._formKey.currentState.validate())
                        // setState(() {
                        // this._formKey.currentState.save();
                        // });
                      },
                    ),
                  ), // save button
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
                                          if (day.totalDrinks > 0) {
                                            setState(() => day.totalDrinks--);
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        )),
                                    Text(day.totalDrinks.toString(),
                                        style: TextStyle(color: Colors.black)),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() => day.totalDrinks++);
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
                                          if (day.totalWaters > 0) {
                                            setState(() => day.totalWaters--);
                                          }
                                        },
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                        )),
                                    Text(day.totalWaters.toString(),
                                        style: TextStyle(color: Colors.black)),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() => day.totalWaters++);
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

  // save() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt(globals.selectedFeetKey, globals.selectedFeet);
  //   await prefs.setInt(globals.selectedInchKey, globals.selectedInches);
  //   await prefs.setInt(globals.selectedWeightKey, globals.selectedWeight);
  //   await prefs.setString(globals.selectedSexKey, globals.selectedSex);
  // }
}

//class SharedPreferencesHelper {
//  static final List<String> prefList = [];
//
//  static Future<List> getList() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs.getStringList("pref list");
//  }
//
//  static Future<bool> setFeet(int feet) async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs.setString(prefList[0], feet.toString());
//  }
//
//  static Future<String> getFeet() async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs.getString(prefList[0]);
//  }
//
//  static Future<bool> setInches(int inches) async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs.setString(prefList[1], inches.toString());
//  }
//
//  static Future<bool> setWeight(int weight) async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs.setString(prefList[2], weight.toString());
//  }
//
//  static Future<bool> setSex(String sex) async {
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    return prefs.setString(prefList[3], sex);
//  }

//}
