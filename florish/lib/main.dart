// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // top row
    Widget bacHeader = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          // menu bars
          Icon(
            Icons.menu,
            color: Colors.white,
          ),
//           room  between
          Spacer(
            flex: 2,
          ),
          //text column with BAC label and variable
          Expanded(
            child: Column(
              children: [
                Container(
                  // BAC label
                  child: Text(
                    'BAC:',
                    style: TextStyle(
                        color: Colors.white,
                    ),
                  ),
                ),
                // BAC variable
                Text(
                  '0.00', // TODO: substitute for BAC Variable
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
                ),
              ],
            ),
          ),
          // blood drop
          Image.asset(
            'assets/images/bacDrop.png',
            height: 42,
            width: 28,
          ),
        ],
      ),
    );

    Widget drinkEntryButtons = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
                'assets/images/soloCup.png',
                height: 71,
                width: 71,
              ),
              Text(
                '0', // TODO: make incrementable variable
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Spacer(),
          Stack(
            alignment: Alignment.center,
            children: [
              Image.asset(
            'assets/images/waterCup.png',
            height: 71,
            width: 71,
          ),
              Text(
                '0', // TODO: make incrementable variable
                style: TextStyle(
                  fontSize: 20,
                  
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Widget plant = Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.asset(
          'assets/images/plantSetting.png',
          height: 344,
          width: 375,
        ),
        Image.asset(
          'assets/images/plant1Healthy.png',
          height: 174,
          width: 180,
        ),
      ],
    );

    return MaterialApp(
        title: 'Plant Nanny',
        home: Scaffold(
          backgroundColor: Colors.grey[600],
            body: ListView(
                children: [
                  bacHeader,
                  plant,
                  drinkEntryButtons,
                ],
            ),
        ),
    );
  }
}

class DrinkButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('DrinkButton was tapped!');
      },
      child: Image.asset(
        'assets/images/soloCup.png',
        height: 71,
        width: 71,
      ),
    );
  }
}