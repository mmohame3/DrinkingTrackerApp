import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:Florish/globals.dart' as globals;
import 'package:Florish/pages/calendar_page.dart';
import 'package:Florish/models/day_model.dart';


/// Renders a chart of a user's BAC from one Day object.
class BacChart extends StatelessWidget {
  final Day day;
  const BacChart({Key key, this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      _createData(),
      animate: false,
      defaultRenderer: charts.LineRendererConfig(includePoints: true),
    );
  }

  /// Builds the list of DateTimes and BACs for the graph.
  ///
  /// returns the TimeSeries with these values.
  List<charts.Series<TimeSeriesBac, DateTime>> _createData() {
    List<TimeSeriesBac> bacData = new List<TimeSeriesBac>();

    /// Gets the list of indices of the values in the database
    /// corresponding to drinks (not waters).
    List<int> justDrinksIndices = getDrinkIndices();

    /// Checks if there were drinks on this day
    if (justDrinksIndices.length > 0) {
      DateTime currentDrinkDateTime;
      int currentDrinkMinutes;
      int i = 0;
      String date = day.getDate();
      int year = getYear(date);
      int month = getMonth(date);
      int dayNum = getDay(date);

      while (i < justDrinksIndices.length) {
        currentDrinkDateTime =
            getCurrentDrinkDateTime(i, justDrinksIndices, year, month, dayNum);

        bacData.add(new TimeSeriesBac(
            currentDrinkDateTime, day.constantBACList[i] / 100));

        currentDrinkMinutes = (day.hourList[justDrinksIndices[i]]) * 60 +
            day.minuteList[justDrinksIndices[i]];

        /// If it's on the last drink, the loop stops here
        if (i + 1 == justDrinksIndices.length) {
          break;
        }

        /// Uses the time difference between the current drink and
        /// the next to calculate how far the BAC dropped over that
        /// period of time.
        double timeDifferenceHours =
        getCurrentAndNextTimeDiff(i, justDrinksIndices);
        DateTime nextDrinkDateTime =
        getNextDrinkDateTime(i, justDrinksIndices, year, month, dayNum);

        double bacBeforeNextDrink =
            (day.constantBACList[i] / 100) - (timeDifferenceHours * 0.15);
        bacBeforeNextDrink = bacBeforeNextDrink < 0 ? 0.0 : bacBeforeNextDrink;

        /// The dropped BAC is added to the TimeSeries before the
        /// next drink (at the DateTime of the next drink)
        bacData.add(new TimeSeriesBac(nextDrinkDateTime, bacBeforeNextDrink));

        i++;
      }

      /// After [justDrinkIndices] has been looped over, points are
      /// added at the user's current BAC and where their BAC first
      /// fell to zero (if needed)
      DateTime currentTime = DateTime.now();
      double lastTimeDifferenceHours;

      /// if [day] is a past day, the [currentTime] is set to the [globals.resetTime]
      /// and the [timeDifference] is the time between the last drink and the reset.
      ///
      /// currentTime (real time) vs day = Day object
      /// if the currentTime is on a different day = either far in future/past
      DateTime selectedDayResetDateTime = stringToDateTime(day.getDate(), 6, 0).add(Duration(days: 1));

      if (currentTime.isAfter(selectedDayResetDateTime)) {
        lastTimeDifferenceHours = getResetTimeDifference(currentDrinkMinutes) / 60;
        currentTime = new DateTime(year, month, dayNum, globals.resetTime, 0, 0).add(Duration(days: 1));
      }


      /// if [day] is still the current day (in reality), then [timeDifference]
      /// is set to the time between the last drink and now.
      else {
        lastTimeDifferenceHours =
            getCurrentTimeDifference(currentDrinkMinutes) / 60;
      }

      double currentBAC =
          (day.constantBACList[i] / 100) - (lastTimeDifferenceHours * 0.15);

      /// if the [currentBAC] has fallen to zero, then another point is added
      /// at the time when it first fell to zero.
      if (currentBAC < 0) {
        /// given the slope (0.15) and the last coordinate we get [minutesForBacToFallToZero]
        int minutesForBacToFallToZero = (day.constantBACList[i] / 0.15).round();
        DateTime xInterceptBAC = currentDrinkDateTime
            .add(Duration(minutes: minutesForBacToFallToZero));

        bacData.add(new TimeSeriesBac(xInterceptBAC, 0));
        currentBAC = 0;
      }

      bacData.add(new TimeSeriesBac(currentTime, currentBAC));
    }

    return [
      new charts.Series<TimeSeriesBac, DateTime>(
        id: 'BAC',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesBac bac, _) => bac.time,
        measureFn: (TimeSeriesBac bac, _) => bac.bac,
        data: bacData,
      )
    ];
  }

  /// Returns the DateTime corresponding to the drink at
  /// position [drinkListIndex] in [justDrinksIndices]
  DateTime getCurrentDrinkDateTime(int drinkListIndex,
      List<int> justDrinksIndices, int year, int month, int dayNum) {
    DateTime currentDrinkDateTime = DateTime(
        year,
        month,
        dayNum,
        day.hourList[justDrinksIndices[drinkListIndex]],
        day.minuteList[justDrinksIndices[drinkListIndex]],
        0);

    /// adjusts [currentDrinkDateTime] based on [globals.resetTime]
    currentDrinkDateTime =
    day.hourList[justDrinksIndices[drinkListIndex]] < globals.resetTime
        ? currentDrinkDateTime.add(Duration(days: 1))
        : currentDrinkDateTime;

    return currentDrinkDateTime;
  }

  /// Returns the DateTime corresponding to the drink at
  /// position [i] + 1 in [justDrinksIndices]
  DateTime getNextDrinkDateTime(
      int i, List<int> justDrinksIndices, int year, int month, int dayNum) {
    DateTime nextDrinkDateTime = DateTime(
        year,
        month,
        dayNum,
        day.hourList[justDrinksIndices[i + 1]],
        day.minuteList[justDrinksIndices[i + 1]],
        0);

    /// adjusts [nextDrinkDateTime] based on [globals.resetTime]
    nextDrinkDateTime = day.hourList[justDrinksIndices[i]] < globals.resetTime
        ? nextDrinkDateTime.add(Duration(days: 1))
        : nextDrinkDateTime;

    return nextDrinkDateTime;
  }

  /// Returns the difference between the drink at position [i]
  /// and that at [i] + 1 in hours.
  getCurrentAndNextTimeDiff(int i, List<int> justDrinksIndices) {
    int currentDrinkMinutes = (day.hourList[justDrinksIndices[i]]) * 60 +
        day.minuteList[justDrinksIndices[i]];
    int nextDrinkMinutes = (day.hourList[justDrinksIndices[i + 1]] * 60) +
        day.minuteList[justDrinksIndices[i + 1]];

    /// If [currentDrinkMinutes] > [nextDrinkMinutes] then the
    /// "next drink" occurred after midnight and [timeDifferenceHours]
    /// is adjusted based on that.
    double timeDifferenceHours = currentDrinkMinutes > nextDrinkMinutes
        ? ((1440 - currentDrinkMinutes) + nextDrinkMinutes) / 60
        : (nextDrinkMinutes - currentDrinkMinutes) / 60;

    return timeDifferenceHours;
  }

  /// Gets the list of indices corresponding to drinks
  ///
  /// These indices correspond to just the day's drinks
  /// across [day.typeList], [day.hourList], and [day.minuteList]
  List<int> getDrinkIndices() {
    List<int> justDrinksIndices = new List<int>();
    for (int j = 0; j < day.typeList.length; j++) {
      if (day.typeList[j] == 1) {
        justDrinksIndices.add(j);
      }
    }
    return justDrinksIndices;
  }

  /// The time difference between [currentDrinkMinutes] and
  /// the day's [globals.resetTime] is calculated and returned
  /// in minutes.
  int getResetTimeDifference(int currentDrinkMinutes) {
    int resetTimeInMinutes = globals.resetTime * 60;
    int timeBetweenLastDrinkAndReset;
    if (currentDrinkMinutes > resetTimeInMinutes) {
      timeBetweenLastDrinkAndReset =
          resetTimeInMinutes + (1440 - currentDrinkMinutes);
    } else {
      timeBetweenLastDrinkAndReset = resetTimeInMinutes - currentDrinkMinutes;
    }

    return timeBetweenLastDrinkAndReset;
  }

  /// The time difference between [currentDrinkMinutes] and
  /// the day's the current time is calculated and returned
  /// in minutes.
  int getCurrentTimeDifference(int currentDrinkMinutes) {
    DateTime currentTime = DateTime.now();
    int currentTimeMinutes = (currentTime.hour) * 60 + currentTime.minute;

    int currentTimeDifference = (currentTimeMinutes - currentDrinkMinutes) < 0
        ? ((1440 - currentDrinkMinutes) + currentTimeMinutes)
        : (currentTimeMinutes - currentDrinkMinutes);

    return currentTimeDifference;
  }
}

/// Creates an object to be displayed by the TimeSeriesChart
class TimeSeriesBac {
  final DateTime time;
  final double bac;

  TimeSeriesBac(this.time, this.bac);
}

/// Splits the [date] string stored in the Day object as MM/DD/YYYY and
/// returns a corresponding DateTime object
DateTime stringToDateTime(String date, int hour, int minutes) {
  List<String> dateObjects = date.split("/");
  String month = minutesStringToString(dateObjects[0]);
  String day = minutesStringToString(dateObjects[1]);
  String year = dateObjects[2];

  DateTime dateTime = DateTime.parse(year +
      month +
      day +
      ' ' +
      minutesIntToString(hour) +
      ':' +
      minutesIntToString(minutes) +
      ':00');
  return dateTime;
}

/// Returns the month stored in the Day object
int getMonth(String date) {
  List<String> dateObjects = date.split("/");
  return int.parse(dateObjects[0]);
}

/// Returns the day stored in the Day object
int getDay(String date) {
  List<String> dateObjects = date.split("/");
  return int.parse(dateObjects[1]);
}

/// Returns the year stored in the Day object
int getYear(String date) {
  List<String> dateObjects = date.split("/");
  return int.parse(dateObjects[2]);
}