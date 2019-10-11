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
          backgroundColor: Color(0xFF97B633),
        ),
//        backgroundColor: Colors.grey[600],
        body: Container(
            padding: EdgeInsets.all(24),
            child: Column(children: [
              Image.asset(
                'assets/images/plants/drink0water2.png',
                width: 180,
              ),
              Spacer(flex: 3),
              Calendarro(
                displayMode: DisplayMode.MONTHS,
                selectedDate: DateTime.now(),
                startDate: DateUtils.getFirstDayOfCurrentMonth(),
                endDate: DateUtils.getLastDayOfCurrentMonth(),
//                onTap: (selectedDate) {
//                  TODO: create information base to access when a date is
//                    selected. should include plant from that day, drinkCount,
//                    and waterCount.
//                },
              ),
//              Spacer(flex: 1),
            ])));
  }
}
