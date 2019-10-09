import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


class UrlResource extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
        appBar: new AppBar(

    ),
    body: new Center(
    child: new RichText(
    text: new TextSpan(
    children: [
    new TextSpan(
    text: 'Here are some information about alcohol abuse and ways to get help.',
    style: new TextStyle(color: Colors.black),
    ),
      new TextSpan(
        text: ' Macalester Resources',
        style: new TextStyle(color: Colors.blue),
        recognizer: new TapGestureRecognizer()
          ..onTap = () { launch('https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
          },
      ),
    ],
    ),
    ),
    ),
        ),
    );
  }
}

//          "to get help.



