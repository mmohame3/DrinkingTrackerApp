import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

import './standardDrink.dart';

class PopupLayout extends ModalRoute {
  final Widget child;

  @override
  Duration get transitionDuration => Duration(milliseconds: 0);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.5);

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  PopupLayout({
    Key key,
    @required this.child,
  });

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return GestureDetector(
      onTap: () {
        //SystemChannels.textInput.invokeMethod('TextInput.hide');
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
      margin: EdgeInsets.only(top: 50, bottom: 50, left: 30, right: 30),
      child: child,
    );
  }
}

class PopupContent extends StatefulWidget {
  final Widget content;

  PopupContent({Key key, this.content}) : super(key: key);

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
  Navigator.push(
      context,
      PopupLayout(
          child: PopupContent(
        content: Scaffold(
          appBar: AppBar(
            title: Text('BAC Information'),
            backgroundColor: Color(0xFF97B633),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  try {
                    Navigator.pop(context); //close the popup
                  } catch (e) {}
                },
              )
            ],
          ),
          body: popUpBody(context),
        ),
      )));
}

Widget popUpBody(BuildContext context) {
  return Container(
      color: Color(0xFFE6E7E8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                      "which means you may be feeling: \n\n ${_getBacInfo(globals.bac)}",
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
                child: Column(children: [
                  Text(
                      "Blood Alcohol Concentration (BAC) refers to the percent of "
                      "alcohol in a person's blood stream."
                      "\n\nIn the U.S., a person is legally intoxicated if he/she has a BAC of .08% or higher.\n\n",
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          height: 1.3,
                          color: Colors.black)),
                  CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  new StandardDrinkPage()));
                    },
                    color: Color(0xFFA8C935),
                    child: Text('More Information',
                        style: TextStyle(color: Colors.white)),
                  )
                ]))),
      ]));
}

String _getBacInfo(double bac) {
  //switch statements.....
  String effects;
  if (bac < .02) {
    effects = "none? idk";
  }

  if ((bac >= 0.020) && (bac < 0.04)) {
    effects =
        "No loss of coordination, slight euphoria, and loss of shyness. Relaxation, but depressant effects are not apparent.";
  }

  if ((bac >= .04) && (bac < 0.06)) {
    effects =
        "Feeling of well-being, relaxation, lower inhibitions, and sensation of warmth. Euphoria. Some minor impairment of judgment and memory, lowering of caution.";
  }

  if ((bac >= .06) && (bac < 0.1)) {
    effects =
        "Slight impairment of balance, speech, vision, reaction time, and hearing. Euphoria. Reduced judgment and self-control. Impaired reasoning and memory.";
  }

  if ((bac >= .1) && (bac < 0.13)) {
    effects =
        "Significant impairment of motor coordination and loss of good judgment. Speech may be slurred; balance, peripheral vision, reaction time, and hearing will be impaired.";
  }

  if ((bac >= .13) && (bac < 0.16)) {
    effects =
        "Gross motor impairment and lack of physical control. Blurred vision and major loss of balance. Euphoria is reducing and beginning dysphoria (a state of feeling unwell)";
  }

  if ((bac >= .16) && (bac < 0.2)) {
    effects =
        "Dysphoria predominates, nausea may appear. The drinker has the appearance of a sloppy drunk.";
  }

  if ((bac >= .2) && (bac < 0.25)) {
    effects =
        "Needs assistance in walking; total mental confusion. Dysphoria with nausea and vomiting; possible blackout.";
  }

  if ((bac >= .25) && (bac < 0.4)) {
    effects = "Alcohol poisoning. Loss of consciousness";
  }

  if (bac >= .5) {
    effects = "onset of come, possible death due to respiratory arrest";
  }

  return effects;
}
