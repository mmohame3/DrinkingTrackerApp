import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;

import 'package:Florish/pages/drinkInformation.dart';
import 'package:Florish/pages/history.dart';

class PopupLayout extends ModalRoute {
  final Widget child;
  double top;
  double bottom;
  double left;
  double right;

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

  PopupLayout(
      {Key key,
      @required this.child,
      this.top,
      this.bottom,
      this.left,
      this.right});

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    if (top == null) this.top = 50;
    if (bottom == null) this.bottom = 50;
    if (left == null) this.left = 30;
    if (right == null) this.right = 30;
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
      margin: EdgeInsets.only(
          top: this.top,
          bottom: this.bottom,
          left: this.left,
          right: this.right),
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

showBACPopup(BuildContext context) {
  Navigator.push(
      context,
      PopupLayout(
          top: 15,
          bottom: 15,
          left: 20,
          right: 20,
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
              body: BACpopUpBody(context),
            ),
          )));
}

Widget BACpopUpBody(BuildContext context) {
//  double bacLater = (globals.bac - .08 )/.015;
//  double bacToZero = globals.bac/.05;
//  bacLater = bacLater < 0 ? 0 : bacLater;
  return Container(
      color: Color(0xFFE6E7E8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        bacText(context),
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
                      "\n\nIn the U.S., a person is legally intoxicated if they have a BAC of .08% or higher.\n\n",
                      style: TextStyle(
                          fontSize: 16,
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
    effects =
        "Relaxed with few obvious effects other than a slight intensification of mood";
  }

  if ((bac >= 0.020) && (bac < 0.04)) {
    effects = "You still have balance! Relaxed is the vibe you are in.";
  }

  if ((bac >= .04) && (bac < 0.06)) {
    effects =
        "You still have balance but you are starting to forget the manners people expect of you. Impaired judgement and explosions of joy describe your current state.";
  }

  if ((bac >= .06) && (bac < 0.1)) {
    effects =
        "Oh oh! You might be tumbling now. Slurring words, slowed reactions, ssssand out of pocket actions describe your current state. Find a sober friend!";
  }

  if ((bac >= .1) && (bac < 0.13)) {
    effects =
        "Seek support! You have lost balance, clear speech, and sense of judgment.";
  }

  if ((bac >= .13) && (bac < 0.16)) {
    effects =
        "You are impaired in all physical and mental functions. Depression begins to set in at this stage, find support.";
  }

  if ((bac >= .16) && (bac < 0.2)) {
    effects =
        " So called sloppy drunk stage, nausea initiates, and negative feelings begin at this stage. Seek help.";
  }

  if ((bac >= .2) && (bac < 0.25)) {
    effects =
        "Mental confusion, blackout level, memory impairment. User needs support as soon as possible.";
  }

  if ((bac >= .25) && (bac < 0.4)) {
    effects =
        "Alcohol poisoning stage, take user to hospital! Notifcations sent to emergency contacts.";
  }

  if (bac >= .4) {
    effects = "Deadly level, emergency attention demanded";
  }

  return effects;
}

Widget bacText(BuildContext context) {
  double bacLater = (globals.bac - .08) / .015;
  double bacToZero = globals.bac / .015;
  bacLater = bacLater < 0 ? 0 : bacLater;
  var container = Column();
  if (globals.bac > 0) {
    container = Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    "Your BAC is  ${globals.bac.toStringAsFixed(3)} "
                    "so may be feeling: \n\t\t\t\t${_getBacInfo(globals.bac)}",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        height: 1.3,
                        color: Colors.black)),
                Text(
                  "\nGiven your current BAC, it will take about:"
                  "\n• ${bacToZero.toStringAsFixed(1)} "
                  "hours to fall to 0% "
                  "\n• ${bacLater.toStringAsFixed(1)} "
                  "hours to fall to .08%",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      height: 1.3,
                      color: Colors.black),
                )
              ])))
    ]);
  }
  return container;
}

showDayEndPopup(BuildContext context) {
  Navigator.push(
      context,
      PopupLayout(
          top: 175,
          bottom: 220,
          left: 30,
          right: 30,
          child: PopupContent(
            content: Scaffold(
              appBar: AppBar(
                title: Text('Day Ended'),
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
              body: dayEndPopUpBody(context),
            ),
          )));
}

Widget dayEndPopUpBody(BuildContext context) {
  print("called");
  return Container(
      color: Color(0xFFE6E7E8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//        Container(
//            padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
//            child: Text(
//              'YOUR BAC',
//              style: TextStyle(letterSpacing: 1, height: 1.5),
//            )),
        Container(
            color: Colors.white,
            alignment: Alignment.topCenter,
            child: Container(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text(
                      'Yesterday you had ${globals.yesterDrink} drinks and ${globals.yesterWater} waters. '
                      '\n\nCheck out your History to see more about your past drinking habits \n\n',
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
                                  new HistoryPage()));
                    },
                    color: Color(0xFFA8C935),
                    child:
                        Text('History', style: TextStyle(color: Colors.white)),
                  )
                ]))),
      ]));
}
