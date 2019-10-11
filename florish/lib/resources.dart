import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourcesPage extends StatefulWidget {
  @override
  _ResourcesPageState createState() => new _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Help & Resources'),
          backgroundColor: Color(0xFF97B633),
        ),
        backgroundColor: Colors.grey[600],
        body: Column(children: [
          Container(
              margin: EdgeInsets.all(30.0),
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              width: 800,
              height: 125,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xFFA8C935), width: 7.0),
              ),
              child: Text(
                  "Below is a link to Macalester resources to help "
                  "with alcohol abuse and how to get help.",
                  style: TextStyle(fontSize: 20, color: Colors.black))),
          CupertinoButton(
            onPressed: _launchURL,
            minSize: 100,
            color: Color(0xFFA8C935),
            child: Text('Macalester Alcohol Resources',
                style: TextStyle(fontSize: 18, color: Colors.white)),
          ),
        ]));
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
