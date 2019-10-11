import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart';
import 'PersonalEntryData.dart';

const List<String> weights = const <String>[
  '100', '105', '110', '115', '120', '125', '130', '135', '140', '145',
  '150', '155', '160', '165', '170', '175','180', '185', '190', '195',
  '200','205', '210', '215', '220', '225', '230', '235', '240', '245',
  '250', '255', '260', '265', '270', '275','280', '285', '290', '295',
  '300', '305', '310', '315', '320', '325', '330', '335', '340', '345',
  '350', '355', '360', '365', '370', '375','380', '385', '390', '395',
  '400',
];

const List<String> genders = const <String> [
  "Female", "Male", "Other"
];



class altPersonalInfoPage extends StatefulWidget {
  @override
  _altPersonalInfoPageState createState() => new _altPersonalInfoPageState();
}

class _altPersonalInfoPageState extends State<altPersonalInfoPage> {
  int selectedFeet = 0;
  int selectedInches = 0;

  int selectedWeight = 0;
  String selectedGender = '';

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Your Personal Information'),
          backgroundColor: Color(0xFF97B633),
        ),

        body: Scaffold(
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
                              child: Text("Height:", style: TextStyle(fontSize: 18, color: Colors.black),),
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
                                                    initialItem: selectedFeet,
                                                  ),
                                                  itemExtent: 32.0,
                                                  backgroundColor: Colors.white,
                                                  onSelectedItemChanged: (int index) {
                                                    setState(() {
                                                      selectedFeet = index;
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
                                                    initialItem: selectedInches,
                                                  ),
                                                  itemExtent: 32.0,
                                                  backgroundColor: Colors.white,
                                                  onSelectedItemChanged: (int index) {
                                                    setState(() {
                                                      selectedInches = index;
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
                          Text( '${selectedFeet} feet, ${selectedInches} inches',
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
                                            initialItem: selectedWeight,
                                          ),
                                          itemExtent: 32.0,
                                          backgroundColor: Colors.white,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              selectedWeight = int.parse(weights[index]);
                                            });
                                          },
                                          children: new List<Widget>.generate(weights.length, (int index) {
                                            return new Center(
                                              child: Text(weights[index]),
                                            );
                                          }))
                                  );
                                }
                            );
                          },
                        ),
                        Text('${selectedWeight} pounds',
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
                                            initialItem: genders.indexOf(selectedGender),
                                          ),
                                          itemExtent: 32.0,
                                          backgroundColor: Colors.white,
                                          onSelectedItemChanged: (int index) {
                                            setState(() {
                                              selectedGender = genders[index];
                                            });
                                          },
                                          children: new List<Widget>.generate(genders.length, (int index) {
                                            return new Center(
                                              child: Text(genders[index]),
                                            );
                                          }))
                                  );
                                }
                            );
                          },
                        ),
                        Text(selectedGender,
                          style: TextStyle(fontSize: 16),
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