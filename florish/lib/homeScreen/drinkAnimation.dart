import 'package:flutter/material.dart';
import 'package:Florish/homeScreen/homeScreen.dart' as home;


Widget drinkAnimation(){
  var soloCupPosition = home.drinkRisePositionAnimation.value * 600;
  var soloCupOpacity = home.drinkRisePositionAnimation.value == 0.0 ? 0.0 :
  1.0 - home.drinkRiseAnimationController.value;
  return new Positioned(
    child: new Opacity(opacity: soloCupOpacity,
        child: new Container(
          height: 30,
          width: 30,
          child: Image.asset('assets/images/soloCup.png'),
        )),
    bottom: soloCupPosition + 50,
    right: 325,
  );


}