import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class StandardDrinkPage extends StatefulWidget {
  @override
  _StandardDrinkPageState createState() => new _StandardDrinkPageState();
}

class _StandardDrinkPageState extends State<StandardDrinkPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Information'),
          backgroundColor: Color(0xFF97B633),
        ),
        body: SingleChildScrollView(
            child: Container(
                color: Color(0xFFF2F2F2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding:
                              EdgeInsets.only(top: 15, left: 20, bottom: 5),
                          child: Text(
                            'A STANDARD DRINK',
                            style: TextStyle(letterSpacing: 1, height: 1.5),
                          )),
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                'In the United States, one "standard drink" contains approximately '
                                "14 grams of pure alcohol, which is found in:"
                                "\n •  12 oz of beer (5% alcohol)"
                                "\n •  5 oz of wine (12% alcohol)"
                                "\n •  1.5 oz of liquor(40% alcohol)"
                                "\n\nIn Florish, by clicking the drink button, you are indicating "
                                "that you just had one standard drink.",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                    height: 1.3,
                                    color: Colors.black)),
                          )),
                      Container(
                          padding:
                              EdgeInsets.only(top: 15, left: 20, bottom: 5),
                          child: Text(
                            'OUR MISSION',
                            style: TextStyle(letterSpacing: 1, height: 1.5),
                          )),
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                                "Florish provides a platform for increased "
                                "awareness of drinking levels in any scenario. Florish is catered towards college students, who often binge drink and lose track of their Alcohol intake levels, jeopardizing their own safety, as well as that of those around them.\n\n"
                                "Florish provides a visual indicator of their BAC as an emotional and accountability incentive to monitor their wellbeing and drinking habits. ",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Montserrat',
                                    height: 1.3,
                                    color: Colors.black)),
                          )),
                      Container(
                          padding:
                              EdgeInsets.only(top: 15, left: 20, bottom: 5),
                          child: Text(
                            'HELP & RESOURCES',
                            style: TextStyle(letterSpacing: 1, height: 1.5),
                          )),
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(children: [
                                Text(
                                    "Below is a link to Macalester resources to help "
                                    "with alcohol abuse and how to get help.",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Montserrat',
                                        height: 1.3,
                                        color: Colors.black)),
                                Container(
                                    padding: EdgeInsets.only(top: 20),
                                    child: CupertinoButton(
                                      onPressed: _launchURL,
                                      color: Color(0xFFA8C935),
                                      child: Text(
                                          'Macalester Alcohol Resources',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )),
                              ]))),
                      Container(
                          padding:
                              EdgeInsets.only(top: 15, left: 20, bottom: 5),
                          child: Text(
                            'DISCLAIMER',
                            style: TextStyle(letterSpacing: 1, height: 1.5),
                          )),
                      Container(
                          color: Colors.white,
                          alignment: Alignment.topCenter,
                          padding: EdgeInsets.all(20),
                          child: Container(
                              child: Text(
                                  "Florish is an app to help people keep track of their drinking. "
                                  "It is not a scientific or precise way to monitor your BAC.",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Montserrat',
                                      height: 1.3,
                                      color: Colors.black)))),
                    ]))));
  }

  _launchURL() async {
    const url =
        'https://www.macalester.edu/healthandwellness/wellness-initiatives/alcoholtobacco/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
