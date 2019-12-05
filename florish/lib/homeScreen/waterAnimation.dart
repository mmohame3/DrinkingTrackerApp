import 'package:flutter/material.dart';
import 'package:Florish/homeScreen/homeScreen.dart' as home;


Widget waterAnimation(){
  var waterDropPosition = home.waterRisePositionAnimation.value * 600;

  var waterDropOpacity = home.waterRisePositionAnimation.value == 0.0 ? 0.0 :
      1.0 - home.waterRiseAnimationController.value;
  return new Positioned(
    child: new Opacity(opacity: waterDropOpacity,
    child: new Container(
      height: 40,
      width: 40,
      child: Image.asset('assets/images/waterDrop.png'),
    )),
    bottom: waterDropPosition + 50,
    left: 300,
  );


}