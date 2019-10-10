import 'package:flutter/material.dart';

class TermsConditionsPage extends StatefulWidget {
  @override
  _TermsConditionsPageState createState() => new _TermsConditionsPageState();
}

class _TermsConditionsPageState extends State<TermsConditionsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
          title: new Text('Terms & Conditions'),
        backgroundColor: Color(0xFFA8C935),
      ),
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
          child: Text("\t Florish is an app to help people keep track of their drinking. "
              "It is not a scientific or precise way to monitor your BAC.",
              style: TextStyle(fontSize: 20, color: Colors.black)),
        )
    );

  }
}
