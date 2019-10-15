import 'package:Florish/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'PersonalEntryData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';






class altPersonalInfoPage extends StatefulWidget {
  @override
  altPersonalInfoPageState createState() => new altPersonalInfoPageState();
}

class altPersonalInfoPageState extends State<altPersonalInfoPage> {
  final _controller = new TextEditingController();
  var _formKey = GlobalKey<FormState>();

//  int selectedFeet = ;
//  int selectedInches = 0;
//  int totalSelectedFeet = 0;
//
//  int selectedWeight = 0;
//  String selectedGender = '';


  addIntToSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('weight', globals.selectedWeight);
    prefs.setInt('feet', globals.selectedFeet);
    prefs.setInt('inches', globals.selectedInches);
    prefs.setString(AppConstants.PREF_GENDER, globals.selectedGender);

  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(

        appBar: new AppBar(
          title: new Text('Your Personal Information'),
          backgroundColor: Color(0xFF97B633),
        ),

        body: Scaffold(

          key: this._formKey,
            backgroundColor: Colors.grey[600],


            body: Container(
                margin: EdgeInsets.all(30.0),
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                width: 800,
                height: 200,

                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Color(0xFFA8C935), width: 7.0),
                ),
                child: Column (

                  children: <Widget>[
                    Row(

                        children: <Widget> [
                          CupertinoButton(
                              child: Text(
                                "Height",
                                style: TextStyle(fontSize: 18, color: Colors.black),
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
                                                    initialItem: globals.selectedFeet,
                                                  ),
                                                  itemExtent: 32.0,
                                                  backgroundColor: Colors.white,
                                                  onSelectedItemChanged: (int index) {
                                                    setState(() {
                                                      globals.selectedFeet = index;

                                                    });


                                                  },
                                                  children: new List<Widget>.generate(8,
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
                                                    initialItem: globals.selectedInches,
                                                  ),
                                                  itemExtent: 32.0,
                                                  backgroundColor: Colors.white,
                                                  onSelectedItemChanged: (int index) {
                                                    setState(() {
                                                      globals.selectedInches = index;

                                                    });

                                                  },

                                                  children: new List<Widget>.generate(13,
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
                          Text( '${globals.selectedFeet} feet, ${globals.selectedInches} inches',
                            style: TextStyle(fontSize: 16),
                          )

                        ]
                    ),
                    Row (
                      children: <Widget>[
                        CupertinoButton(
                          child: Text("Weight:", style: TextStyle(fontSize: 18, color: Colors.black)),
                          onPressed: (){
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container (
                                      height: 200,
                                      child: CupertinoPicker(
                                          scrollController:
                                          new FixedExtentScrollController(
                                            initialItem: globals.selectedWeight,
                                          ),
                                          itemExtent: 32.0,
                                          backgroundColor: Colors.white,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              globals.selectedWeight = int.parse(globals.weights[index]);
                                            });

                                          },
                                          children: new List<Widget>.generate(globals.weights.length, (int index) {
                                            return new Center(
                                              child: Text(globals.weights[index]),
                                            );
                                          }))
                                  );
                                }
                            );
                          },
                        ),
                        Text('${globals.selectedWeight} pounds',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],


                    ),
                    Row (
                      children: <Widget>[
                        CupertinoButton(
                          child: Text("Gender:", style: TextStyle(fontSize: 18, color: Colors.black)),
                          onPressed: (){
                            showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return Container (
                                      height: 200,
                                      child: CupertinoPicker(
                                          scrollController:
                                          new FixedExtentScrollController(
                                            initialItem: globals.genders.indexOf(globals.selectedGender),
                                          ),
                                          itemExtent: 32.0,
                                          backgroundColor: Colors.white,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              globals.selectedGender = globals.genders[index];
                                            });
                                          },
                                          children: new List<Widget>.generate(globals.genders.length, (int index) {
                                            return new Center(
                                              child: Text(globals.genders[index]),
                                            );
                                          }))
                                  );
                                }
                            );
                          },
                        ),
                        Text(globals.selectedGender,
                          style: TextStyle(fontSize: 16),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        RaisedButton(

                          child: Text("Save"),
                          onPressed:(){

                           // print("Data are: " + selectedGender + "- " + selectedWeight.toString() + "- " + selectedFeet.toString());
                            addIntToSF();
                            if(this._formKey.currentState.validate())
                              setState(() {
                                this._formKey.currentState.save();
                              });
                          },
                        ),
                      ],



                    ),


                  ],


                )


            )


        )


    );


  }
}