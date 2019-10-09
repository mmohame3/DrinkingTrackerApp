import 'package:calendarro/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:calendarro/calendarro.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Your Drinking History'),
        backgroundColor: Color(0xFFA8C935),
          


      ),
      body: Calendarro(
        displayMode: DisplayMode.MONTHS,
        selectedDate: DateTime.now(),
        startDate: DateUtils.getFirstDayOfCurrentMonth(),
        endDate: DateUtils.getLastDayOfCurrentMonth(),
      ),
    );
  }
}


