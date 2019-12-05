import 'package:flutter/material.dart';
import 'package:Florish/homeScreen/homeScreen.dart' as home;


Widget waterAnimation(){
  var waterDropPosition = home.waterRisePositionAnimation.value * 400;

  var waterDropOpacity = home.waterRiseAnimationController.value == 0.0 ? 0.0 :
      1.0 - home.waterRiseAnimationController.value;
  return new Positioned(
    child: new Opacity(opacity: waterDropOpacity,
    child: new Container(
      height: 50,
      width: 50,
      child: Image.asset('assets/images/WaterDropDrop Shadow.png'),
    )),
    bottom: waterDropPosition + 105,
    left: 255,
  );


}