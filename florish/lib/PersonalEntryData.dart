import 'package:flutter/material.dart';


class PersonalEntryData extends StatefulWidget {
  @override
  _PersonalEntryDataState createState() => new _PersonalEntryDataState();
}

class _PersonalEntryDataState extends State<PersonalEntryData> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Material(
      child: new Container(
          padding: const EdgeInsets.all(30.0),
          color: Colors.white,
          child: new Column(
              children: [
                new Padding(padding: EdgeInsets.only(top: 140.0)),
                new Padding(padding: EdgeInsets.only(top: 50.0)),
                new TextFormField(
                  decoration: new InputDecoration(
                    labelText: "Enter Your Age:",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Age cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.number,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ]
          )
      ),
    );
  }


  }



