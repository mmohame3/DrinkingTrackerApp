import 'package:Florish/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  PersonalInfoPageState createState() => new PersonalInfoPageState();
}

class PersonalInfoPageState extends State<PersonalInfoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences _prefs;
  
  String _weight = "";
  String _height = "";

  @override
  void initState() { 
    super.initState();
      _initSharedPref();
      // _getWeight();
      // _getHeight();
  }

  _initSharedPref() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // _getWeight() {
  //   int weight = _prefs?.getInt(globals.selectedWeightKey);
  //   if(weight != null && weight > 0)
  //     _weight = 'Weight:   $weight pounds';
  //   else _weight = 'Weight:   ${globals.selectedWeight} pounds';
  // }

  // _getHeight() {
  //   int height = _prefs?.getInt(globals.selectedHeightKey);
  //   if(height != null && height > 0)
  //     _height = 'Height:   $height inches';
  //     // _height = 'Height:   ${globals.selectedFeet} feet, ${globals.selectedInches} inches';
  //   else _height = 'Height:   ${globals.selectedHeight} inches';
  // }

//  int selectedFeet = 0;
//  int selectedInches = 0;
//  int totalSelectedFeet = 0;
//
//  int selectedWeight = 0;
//  String selectedSex = '';
  int initialFeet = 0;


  addIntToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('weight', globals.selectedWeight);
    prefs.setInt('feet', globals.selectedFeet);
    prefs.setInt('inches', globals.selectedInches);
    prefs.setString(AppConstants.PREF_SEX, globals.selectedSex);


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
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AppHomeScreen()));
            },
            child: Icon(Icons.arrow_back_ios)),
        ),
        body: Scaffold(
            key: _scaffoldKey,
            body: Container(
                color: Color(0xFFE6E7E8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      CupertinoButton(
                          child: Text(
                            'Height:   ${globals.selectedFeet} feet, ${globals.selectedInches} inches',
                          ),
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
                                                initialItem:
                                                    globals.selectedFeet,
                                              ),
                                              itemExtent: 32.0,
                                              backgroundColor: Colors.white,
                                              onSelectedItemChanged:
                                                  (int index) {
                                                setState(() {
                                                  globals.selectedFeet = index;
                                                });
                                              },
                                              children:
                                                  new List<Widget>.generate(8,
                                                      (int index) {
                                                return new Center(
                                                  child: Text('${index}'),
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
                                              onSelectedItemChanged:
                                                  (int index) {
                                                setState(() {
                                                  globals.selectedInches =
                                                      index;
                                                });
                                              },
                                              children:
                                                  new List<Widget>.generate(13,
                                                      (int index) {
                                                return new Center(
                                                  child: Text('${index}'),
                                                );
                                              })),
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
//
                    ]),
                    Row(
                      children: <Widget>[
                        CupertinoButton(
                          child: Text(
                            'Weight:   ${globals.selectedWeight} pounds',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container(
                                      height: 200,
                                      child: CupertinoPicker(
                                          scrollController:
                                              new FixedExtentScrollController(
                                            initialItem: globals.weights
                                                .indexOf(globals.selectedWeight
                                                    .toString()),
                                          ),
                                          itemExtent: 32.0,
                                          backgroundColor: Colors.white,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              globals.selectedWeight =
                                                  int.parse(
                                                      globals.weights[index]);
                                            });
                                          },
                                          children: new List<Widget>.generate(
                                              globals.weights.length,
                                              (int index) {
                                            return new Center(
                                              child:
                                                  Text(globals.weights[index]),
                                            );
                                          })));
                                });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        CupertinoButton(
                          child: Text("Sex at birth:   ${globals.selectedSex}",
                              style: TextStyle(fontSize: 18)),
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
                                                .indexOf(
                                                    globals.selectedSex),
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
                                              globals.sexes.length,
                                              (int index) {
                                            return new Center(
                                              child:
                                                  Text(globals.sexes[index]),
                                            );
                                          })));
                                });
                          },
                        ),
                      ],
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        RaisedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            await save();

                            _showSnackBar(Text('Saved successfully'));
                             //print("Data are: " + selectedSex + "- " + selectedWeight.toString() + "- " + selectedFeet.toString());
                                  addIntToSF();
                                  // if(this._formKey.currentState.validate())
                                  // setState(() {
                                  // this._formKey.currentState.save();
                                  // });
                          },
                        ),
                      ],
                    ),
                  ],
                ))));
  }

  save() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(globals.selectedFeetKey, globals.selectedFeet);
    await prefs.setInt(globals.selectedInchKey, globals.selectedInches);
    await prefs.setInt(globals.selectedWeightKey, globals.selectedWeight);
    await prefs.setString(globals.selectedSexKey, globals.selectedSex);
  }


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
