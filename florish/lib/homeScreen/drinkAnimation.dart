import 'package:flutter/material.dart';
import 'package:Florish/homeScreen/homeScreen.dart' as home;

Widget drinkAnimation(){
  var soloCupPosition = home.drinkRisePositionAnimation.value * 400;
  var soloCupOpacity = home.drinkRisePositionAnimation.value == 0.0 ? 0.0 :
  1.0 - home.drinkRiseAnimationController.value;
  return new Positioned(
    child: new Opacity(opacity: soloCupOpacity,
        child: new Container(
          height: 50,
          width: 50,
          child: Image.asset('assets/images/soloCupDropShadow.png'),
        )),
    bottom: soloCupPosition + 105,
    right: 255,
  );
}