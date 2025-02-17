import 'dart:math';
import 'package:flutter/material.dart';

class MyTeddy extends StatelessWidget{
  final int teddySpriteCount;
  final String teddyDirection;

  const MyTeddy({super.key, required this.teddySpriteCount, required this.teddyDirection});

  @override
  Widget build(BuildContext context) {
    if (teddyDirection == 'left'){
      return Container(
        alignment: Alignment.bottomCenter,
        height: 50,
        width: 50,
        child: Image.asset('lib/images/oso' +
            teddySpriteCount.toString() +
            '.png'),
      );
    } else{
      return Transform(
        alignment: Alignment.center,
        transform: Matrix4.rotationY(pi),
        child: Container(
          alignment: Alignment.bottomCenter,
          height: 50,
          width: 50,
          child: Image.asset('lib/images/oso' + 
              teddySpriteCount.toString() + 
              '.png'),
        ),
      );
    }
  }
}

