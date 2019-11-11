class InputModel {
  int id;
  int feet;
  int inch;
  int weight;
  String sex;

  toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['feet'] = feet;
    map['inch'] = inch;
    map['weight'] = weight;
    map['gender'] = sex;

    return map;
  }
}