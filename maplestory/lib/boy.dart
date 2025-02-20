import 'dart:math'; //Proporciona funciones matemáticas, como pi, que se usa para rotar la imagen del personaje.
import 'package:flutter/material.dart';

class MyBoy extends StatelessWidget{
  final int boySpriteCount;
  final String boyDirection;
  final int attackBoySpriteCount;


  const MyBoy({super.key, required this.boySpriteCount, required this.boyDirection, required this.attackBoySpriteCount});


  @override
  Widget build(BuildContext context) {

    int directionAsInt = 1; //Convierte la dirección del personaje ('left' o 'right') en un valor entero (0 o 1). Esto se usa para rotar la imagen del personaje.

    if (boyDirection == 'right'){
      directionAsInt = 1;
    } else if (boyDirection == 'left'){
      directionAsInt = 0;
    } else {
      directionAsInt = 1;
    }

    if (attackBoySpriteCount > 0){
      return Container(
        child: Transform( //Rota la imagen del personaje en el eje Y usando Matrix4.rotationY.
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi * directionAsInt), //Si directionAsInt es 0, la imagen no se rota (dirección izquierda). Si es 1, la imagen se rota 180 grados (dirección derecha).
              child: Image.asset('lib/images/attack' +   
            boySpriteCount.toString() +
            '.png'),  //Carga la imagen de ataque correspondiente al fotograma actual
        )

      );
    }

    if (boyDirection == 'left'){
      return Container(
        alignment: Alignment.bottomCenter, //Alinea la imagen en la parte inferior del contenedor.
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

