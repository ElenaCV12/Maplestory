import 'dart:math';
import 'package:flutter/material.dart';

class MyBoy extends StatelessWidget{
  final int boySpriteCount;
  final String boyDirection;
  final int attackBoySpriteCount;


  const MyBoy({super.key, required this.boySpriteCount, required this.boyDirection, required this.attackBoySpriteCount});


  @override
  Widget build(BuildContext context) {

    int directionAsInt = 1;

    if (boyDirection == 'right'){
      directionAsInt = 1;
    } else if (boyDirection == 'left'){
      directionAsInt = 0;
    } else {
      directionAsInt = 1;
    }

    if (attackBoySpriteCount > 0){
      return Container(
        child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi * directionAsInt),
              child: Image.asset('lib/images/attack' +
            boySpriteCount.toString() +
            '.png'),
        )

      );
    }

    if (boyDirection == 'left'){
      return Container(
        alignment: Alignment.bottomCenter,
        height: 100,
        width: 100,
        child: Image.asset('lib/images/per' +
            boySpriteCount.toString() +
            '.png'),
      );
    } else{
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 100,
          width: 100,
          child: Image.asset('lib/images/per' +
              boySpriteCount.toString() +
              '.png'),
        ),
      );
    }
  }
}

