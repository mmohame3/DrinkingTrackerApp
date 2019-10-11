import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_tagging/flutter_tagging.dart';

class PersonalEntryData extends StatefulWidget {
  @override
  _PersonalEntryDataState createState() => new _PersonalEntryDataState();
}

class _PersonalEntryDataState extends State<PersonalEntryData> {
  final _formKey = GlobalKey<FormState>();
  int _weight;
  int _height;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: new Container(
          key: this._formKey,
          padding: const EdgeInsets.all(30.0),
          color: Colors.white,
          child: new Column(children: [
            new TextFormField(
              decoration: new InputDecoration(
                labelText: "Enter your height:",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              onSaved: (val) => this._height,
              validator: (val) {
                if (val.isEmpty) {
                  return "Height cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(
              height: 25.0,
            ),

            new TextFormField(
              decoration: new InputDecoration(
                labelText: "Enter your weight:",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              onSaved: (value) => this._weight,
              validator: (val) {
                if (val.length == 0) {
                  return "weight cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(
              height: 25.0,
            ),

            new TextFormField(
              decoration: new InputDecoration(
                labelText: "Gender:",
                fillColor: Colors.white,
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  borderSide: new BorderSide(),
                ),
                //fillColor: Colors.green
              ),
              validator: (val) {
                if (val.length == 0) {
                  return "Your weight cannot be empty";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
              style: new TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
//                FlutterTagging(
//                  textFieldDecoration: InputDecoration(
//                      border: OutlineInputBorder(),
//                      hintText: "Tags",
//                      labelText: "Enter tags"),
//                  addButtonWidget: _buildAddButton(),
//                  chipsColor: Colors.pinkAccent,
//                  chipsFontColor: Colors.white,
//                  deleteIcon: Icon(Icons.cancel,color: Colors.white),
//                  chipsPadding: EdgeInsets.all(2.0),
//                  chipsFontSize: 14.0,
//                  chipsSpacing: 5.0,
//                  chipsFontFamily: 'helvetica_neue_light',
//                  suggestionsCallback: (pattern) async {
//                    return await TagSearchService.getSuggestions(pattern);
//                  },
//                  onChanged: (result) {
//                    setState(() {
//                      text = result.toString();
//                    });
//                  },
//                ),

            DropdownButton(
              items: _dropDownItem(),
              onChanged: null,
              hint: Text('Select Gender'),
            ),

            RaisedButton(
              child: Text('Submit'),
              onPressed: () {
                if (this._formKey.currentState.validate())
                  setState(() {
                    this._formKey.currentState.save();
                  });
              },
            )
//          DropdownButton(
//              items: _dropDownItem(),
//              onChanged: null)
          ])),
    );
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["Male", "Female", "Others"];
    return ddl
        .map((value) => DropdownMenuItem(
              value: value,
              child: Text(value),
            ))
        .toList();
  }
}
