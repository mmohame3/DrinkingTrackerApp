// database table and column names
final String tableDays = "days";
final String columnDay = "day";
final String columnHourList = 'hourlist';
final String columnMinuteList = 'minutelist';
final String columnTypeList = 'typelist';
final String columnConstantBACList = 'constantBACList';
final String columnMaxBAC = 'maxBAC';
final String columnMBWater = 'wateratmaxBAC';
final String columnDrinkCount = "totaldrinkcount";
final String columnWaterCount = "totalwatercount";
final String columnHydratio = "hydratio";
final String columnYesterHydratio = "yesterhydratio";
final String columnLastBAC = "lastBAC";

class Day {
  String date;
  List<int> hourList;
  List<int> minuteList;
  List<int> typeList;
  List<int> constantBACList;
  double maxBAC;
  int waterAtMaxBAC;
  int totalDrinks;
  int totalWaters;
  double hydratio;
  double yesterHydratio;
  double lastBAC;

  Day(
      {this.date,
        this.hourList,
        this.minuteList,
        this.typeList,
        this.constantBACList,
        this.maxBAC,
        this.waterAtMaxBAC,
        this.totalDrinks,
        this.totalWaters,
        this.hydratio,
        this.yesterHydratio,
        this.lastBAC});

  Day.fromMap(Map<String, dynamic> map) {
    date = map[columnDay];
    hourList = map[columnHourList];
    minuteList = map[columnMinuteList];
    typeList = map[columnTypeList];
    constantBACList = map[columnConstantBACList];
    maxBAC = map[columnMaxBAC];
    waterAtMaxBAC = map[columnMBWater];
    totalDrinks = map[columnDrinkCount];
    totalWaters = map[columnWaterCount];
    hydratio = map[columnHydratio];
    yesterHydratio = map[columnYesterHydratio];
    lastBAC = map[columnLastBAC];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnDay: date,
      columnHourList: hourList,
      columnMinuteList: minuteList,
      columnTypeList: typeList,
      columnConstantBACList: constantBACList,
      columnMaxBAC: maxBAC,
      columnMBWater: waterAtMaxBAC,
      columnDrinkCount: totalDrinks,
      columnWaterCount: totalWaters,
      columnHydratio: hydratio,
      columnYesterHydratio: yesterHydratio,
      columnLastBAC: lastBAC,
    };

    return map;
  }

  @override
  String toString() {
    return 'Day {date: $date, hourList: $hourList, minuteList: $minuteList, typeList: $typeList, '
        'constantBACList: $constantBACList, maxBAC: $maxBAC, waterAtMaxBAC: $waterAtMaxBAC,'
        'totalDrinks: $totalDrinks, totalWaters: $totalWaters, '
        'todayhydratio: $hydratio, yesterhydratio: $yesterHydratio,'
        'lastBAC: $lastBAC}';
  }

  // NOTE: this many getters and setters CANNOT be efficient in a
  // database but this is how we're doing it right now.
  String getDate() {
    return this.date;
  }

  List getHours() {
    return this.hourList;
  }

  List getMinutes() {
    return this.minuteList;
  }

  List getTypes() {
    return this.typeList;
  }

  List getConstantBACs() {
    return this.constantBACList;
  }

  double getMaxBac() {
    return this.maxBAC;
  }

  int getWaterAtMax() {
    if (this.waterAtMaxBAC >= 5) {
      return 5;
    }return this.waterAtMaxBAC;
  }

  int getTotalDrinks() {
    return this.totalDrinks;
  }

  int getTotalWaters() {
    return this.totalWaters;
  }

  double getHydratio() {
    return this.hydratio;
  }

  double getYesterHydratio() {
    return this.yesterHydratio;
  }

  double getLastBAC() {
    return this.lastBAC;
  }

  void setDate(String date) {
    this.date = date;
  }

  void addHour(int hour) {
    this.hourList.add(hour);
  }

  void addMinute(int minute) {
    this.minuteList.add(minute);
  }

  void addType(int type) {
    this.typeList.add(type);
  }

  void addConstantBAC(int bac) {
    this.constantBACList.add(bac);
  }


  void setMaxBac(double mb) {
    this.maxBAC = mb;
  }

  void setWatersAtMaxBac(int wamb) {
    this.waterAtMaxBAC = wamb;
  }

  void setTotalDrinks(int drinks) {
    this.totalDrinks = drinks;
  }

  void setTotalWaters(int waters) {
    this.totalWaters = waters;
  }

  void setHydratio(double ratio) {
    this.hydratio = ratio;
  }

  void setYesterHydratio(double ratio) {
    this.yesterHydratio = ratio;
  }

}