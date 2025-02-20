import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final text;
  final function;

  const MyButton({super.key, this.text, this.function});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0), //se utiliza para definir un margen o relleno uniforme
      child: GestureDetector( // detecta gestos del usuario, como toques, arrastres, pulsaciones largas, dobles toques, etc. 
        onTap: function,//Toques simples
        child: ClipRRect( // recorta (o recorta con bordes redondeados) a su hijo utilizando un rectángulo con esquinas redondeadas.
          borderRadius: BorderRadius.circular(15),
          child:  Container(
            padding: EdgeInsets.all(20),
            color: Colors.grey[700],
            child: Center(
              child: Text(text, style: TextStyle(color: Colors.white)),
              ),
        ),
      ),
      ),
    );
  }
}



//Matrix4 - - aplicar transformaciones geométricas a widgets, como rotaciones, traslaciones, escalados y deformaciones.