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
//      body: Calendarro(
//        displayMode: DisplayMode.MONTHS,
//        selectedDate: DateTime.now(),
//        startDate: DateUtils.getFirstDayOfCurrentMonth(),
//        endDate: DateUtils.getLastDayOfNextMonth(),
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
//4afc97de1f9188b62012f8f52caf376c4a136a3b
      ),
            Spacer(flex:1),

    ]
    )
    );
  }


}




