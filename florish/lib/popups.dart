import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Florish/pages/drinkInformation.dart';
import 'package:Florish/pages/history.dart';

List<TimeSeriesBac> bacChartData =
    List<TimeSeriesBac>(); // List<TimeSeriesBac>();
List<TimeSeriesBac> waterChartData = List<TimeSeriesBac>();

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
      child: SingleChildScrollView(
          child: ConstrainedBox(
              constraints: BoxConstraints(
//                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bacText(context),
//                    Container(
//                        padding: EdgeInsets.only(top: 15, left: 20, bottom: 5),
//                        child: Text(
//                          'YOUR PROJECTED BAC',
//                          style: TextStyle(letterSpacing: 1, height: 1.5),
//                        )),
//                    Container(
//                        color: Colors.white,
//                        alignment: Alignment.topCenter,
//                        child: Container(
//                            padding: EdgeInsets.all(20),
//                            child: SizedBox(
//                              height: MediaQuery.of(context).size.height / 5,
////                                child: BacChart()
//                            ))),
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
                              Container(
//                                  padding: EdgeInsets.only(bottom: 20),
                                  child: Text(
                                      "Blood Alcohol Concentration (BAC) refers to the percent of "
                                      "alcohol in a person's blood stream."
                                      "\n\nIn the U.S., a person is legally intoxicated if they have a BAC of .08% or higher.\n"
                                      "\nIn Florish, your BAC is calculated using the Widmark Formula which takes into account your "
                                      "weight, sex, and how long it's been since each drink. When you take a drink, your BAC goes up "
                                      "based on these factors and over time, it drops by .015% per hour.\n",
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          height: 1.3,
                                          color: Colors.black))),
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
                  ]))));
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
                      '\n\nCheck out your History to see more about your past drinking habits.\n',
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

Widget bacText(BuildContext context) {
  Paint paint = Paint();
  paint.color = Color(0xFFcbe67d);
//  paint.color = Colors.black;
  paint.strokeWidth = 3;
  paint.style = PaintingStyle.fill;
  paint.strokeJoin = StrokeJoin.round;

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
          width: MediaQuery.of(context).size.width,
//        alignment: Alignment.topCenter,
          child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "Your BAC is ${globals.bac.toStringAsFixed(3)}%, "
                        "so you may be feeling: \n\n${_getBacInfo(globals.bac)}",
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            height: 1.3,
                            color: Colors.black)),
                    Column(children: [
                      RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: 'Montserrat',
                                  height: 1.3),
                              children: [
                            TextSpan(
                                text:
                                    "\nGiven your current BAC, it will take about:\n  •   "),
                            TextSpan(
                                text: ' ${bacToZero.toStringAsFixed(1)} ',
                                style: TextStyle(background: paint)),
                            TextSpan(text: " hours to fall to 0% \n  •   "),
                            TextSpan(
                                text: ' ${bacLater.toStringAsFixed(1)} ',
                                style: TextStyle(background: paint)),
                            TextSpan(text: " hours to fall to .08%"),
                          ]))
                    ])
                  ])))
    ]);
  }
  return container;
}

class BacChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      _createData(),
      animate: false,
//      customSeriesRenderers: [
//        new charts.PointRendererConfig(
//          // ID used to link series to this renderer.
//            customRendererId: 'customPoint', radiusPx: 2)
//      ],
    );
  }

  static List<charts.Series<TimeSeriesBac, DateTime>> _createData() {
    final bacData = bacChartData;
    final waterData = waterChartData;

    return [
      new charts.Series<TimeSeriesBac, DateTime>(
        id: 'BAC',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesBac bac, _) => bac.time,
        measureFn: (TimeSeriesBac bac, _) => bac.bac,
        data: bacData,
      ),
      new charts.Series<TimeSeriesBac, DateTime>(
        id: 'Water',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesBac bac, _) => bac.time,
        measureFn: (TimeSeriesBac bac, _) => bac.bac,
        data: waterData,
      ) // TODO: fix axis display by multiplying bac by 10 and then having the axis labels show (stored value)/10,
        ..setAttribute(charts.rendererIdKey, 'customPoint'),
    ];
  }
}

class TimeSeriesBac {
  final DateTime time;
  final double bac;

  TimeSeriesBac(this.time, this.bac);
}
