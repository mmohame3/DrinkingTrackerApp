import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'UrlResource.dart';


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
        backgroundColor: Color(0xFFA8C935),
      ),
      body: new UrlResource(),
//      new Text("Here are some information about alcohol abuse and ways to"
//          "to get help."),

    );

  }

}
