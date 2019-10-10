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
      body: Column(
          children: [
            Image.asset(
                'assets/images/plants/drink0water2.png',
                  height: 348,
                  width: 360
            ),
            Spacer(),
            Text("This is your plant from the selected day.",
                style: TextStyle(fontSize: 20, color: Colors.black)),
            Spacer(flex: 3),
            Calendarro(
              displayMode: DisplayMode.MONTHS,
              selectedDate: DateTime.now(),
              startDate: DateUtils.getFirstDayOfCurrentMonth(),
              endDate: DateUtils.getLastDayOfCurrentMonth(),
      ),
            Spacer(flex:1),

    ]
    )
    );
  }
}


