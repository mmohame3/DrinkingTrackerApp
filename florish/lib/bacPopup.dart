import 'package:Florish/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

class PopupLayout extends ModalRoute {
  final Widget child;

  @override
  Duration get transitionDuration =>
  Duration(milliseconds: 300);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayout(
  {Key key,
  @required this.child,
  });

  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      )
  {



    return GestureDetector(
      onTap: () {
        SystemChannels.textInput.invokeMethod('TextInput.hide');
      },
      child: Material(
        type: MaterialType.transparency,
        child: SafeArea(
          bottom: true,
          child: _buildOverlayContent(context),
        ),
      ),
    );

  }

  Widget _buildOverlayContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 150,
          bottom: 150,
        left: 30,
        right: 30),
      child: child,
    );
  }

}

class PopupContent extends StatefulWidget {
  final Widget content;

  PopupContent({
    Key key,
    this.content,
  }) : super(key: key);

  _PopupContentState createState() => _PopupContentState();
}

class _PopupContentState extends State<PopupContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.content,
    );
  }
}

showPopup(BuildContext context) {
  Navigator.push(context,
      PopupLayout(
          child: PopupContent(
            content: Scaffold(
              appBar: AppBar(
                title: Text('BAC Information'),
                backgroundColor: Color(0xFF97B633),
                leading: new Builder(builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      try {
                        Navigator.pop(context); //close the popup
                      } catch (e) {}
                    },
                  );
                }),
              ),
              body: popUpBody(),
            ),
          )
      ));
}

Widget popUpBody() {
  return Container(
      color: Color(0xFFE6E7E8),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
            child: Text(
              'YOUR BAC',
              style: TextStyle(letterSpacing: 1, height: 1.5),
            )),
        Container(
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                    "Your BAC is currently ${globals.bac.toStringAsFixed(3)} "
                        "which means you may be feeling.....",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          height: 1.3,
                          color: Colors.black)),
                ]))),
        Container(
            padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
            child: Text(
              'WHAT IS BAC?',
              style: TextStyle(letterSpacing: 1, height: 1.5),
            )),
        Container(
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.all(20),
              child: Text(
                  "Blood Alcohol Concentration (BAC) refers to the percent of "
                      "alcohol in a person's blood stream."
                      "\n\nA BAC of .10% means "
                      "that an individual's blood supply contains one part alcohol for every 1000 parts blood. "
                      "\n\nIn the U.S., a person is legally intoxicated if he/she has a BAC of .08% or higher.",
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      height: 1.3,
                      color: Colors.black)),
            ))
      ])
  );
}





