import 'package:flutter/material.dart';

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
    );
  }
}
