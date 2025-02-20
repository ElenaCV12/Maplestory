import 'dart:async';
import 'package:flutter/material.dart';
import 'package:maplestory/boy.dart';
import 'package:maplestory/button.dart';
import 'package:maplestory/snail.dart';
import 'package:maplestory/teddy.dart';

void main () {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,  //oculta el banner "Debug" en la esquina superior derecha de la pantalla.
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  //bLUEsNAIL animación y posición
  int snailSpriteCount = 1;
  static double snailPosX = 0.5;
  //static double snailPosY = 1;
  String snailDirection = 'left';
  //int deadSnailSprite = 0;
  //bool snailAttacked = false;

  //Teddy, aniamción, posición 
  int teddySpriteCount = 1;
  double teddyPosX = 0;
  String teddyDirection = 'right';

  //personaje--animación, posición y dirección, animación de ataque
  int boySpriteCount = 1;
  double boyPosX = -0.5;
  double boyPosY = 1;
  String boyDirection = 'right';
  int attackBoySpriteCount = 0;

  //loading scren---controlar la pantalla de carga
  var loadingScreenColor = Colors.blue[100];
  var loadingScreenTextColor = Colors.blue[700];
  var tapToPlayColor = Colors.white;
  int loadingTime = 3;
  //bool gameHasStarted = false;

  //mensaje de golpe
   String attackMessage = '';
   bool showAttackMessage = false;


  //Inicia el juego, llamando a los métodos
  void playNow(){
    startGameTimer();
    moveSnail();
    moveTeddy();
    attack();
  }

  //Inicia un temporizador antes que comience el juego
  void startGameTimer(){
    Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        loadingTime--; // Reduce el tiempo de carga
      });

      if (loadingTime == 0){
          setState(() {
              loadingScreenColor = Colors.transparent;  // Oculta la pantalla de carga
              loadingTime = 3;
              loadingScreenTextColor = Colors.transparent;
          });
          timer.cancel();
        }
    });
  }

  //Maneja la animación de ataque del personaje y verifica si el ataque golpea al caracol.
  void attack() {
  setState(() {
    attackBoySpriteCount = 1;// Inicia la animación de ataque
    attackMessage = '';  // Reinicia el mensaje
    showAttackMessage = false;  // Oculta el mensaje
  });

  Timer.periodic(Duration(milliseconds: 100), (timer) {
    setState(() {
      attackBoySpriteCount++;
    });

    if (attackBoySpriteCount == 5) {
      if (boyDirection == 'right' && boyPosX + 0.2 > snailPosX) {
        setState(() {
          attackMessage = 'HIT'; // Actualiza el mensaje a "HIT"
          showAttackMessage = true;
        });
      } else {
        setState(() {
          attackMessage = 'missed'; // Actualiza el mensaje a "missed"
          showAttackMessage = true;
        });
      }
      attackBoySpriteCount = 0; // Reinicia la animación de ataque
      timer.cancel();
      
      Timer(Duration(seconds: 2), () {
        setState(() {
          showAttackMessage = false; // Oculta el mensaje
        });
      });
    }
  });
  }

  //Maneja el movimiento del oso
  void moveTeddy(){
    Timer.periodic(Duration(milliseconds: 100), (timer){
      setState(() {
        teddySpriteCount++;

        if (teddySpriteCount == 19){
          teddySpriteCount = 1;
        }

        if ((teddyPosX - boyPosX).abs() > 0.2){
          if  (boyDirection == 'right'){
            teddyPosX = boyPosX - 0.2;
          }else if (boyDirection == 'left'){
            teddyPosX = boyPosX + 0.2;
          }
        }

        if (teddyPosX - boyPosX > 0){
          teddyDirection = 'left';
        }else {
          teddyDirection = 'right';
        }
      });
    });
  }

  //Maneja el movimiento del caracol
  void moveSnail (){
    Timer.periodic(Duration(milliseconds: 150), (timer) {
      setState(() {
        snailSpriteCount++;

        if (snailDirection == 'left'){
          snailPosX -= 0.01;
        } else {
          snailPosX += 0.01;
        }

        if (snailPosX < 0.3){
          snailDirection = 'right';
        } else if (snailPosX > 0.6){
          snailDirection = 'left';
        }

        if (snailSpriteCount == 5){
          snailSpriteCount = 1;
          }
      });
    });
  }


  //Controlan el movimineto del personaje principal
  void moveLeft(){
    setState(() {
      boyPosX -= 0.03; // Cambia la posición del personaje
      boySpriteCount++; // Cambia el sprite para animar
      boyDirection = 'left'; // Cambia la dirección
    });
  }

  //Controlan el movimineto del personaje principal
  void moveRight(){
    setState(() {
      boyPosX += 0.03;
      boySpriteCount++;
      boyDirection = 'right';
    });
  }


  //Controlan el saltoo del personaje principal
  void jump (){
  double time = 0;
  double height = 0;
  double initialHeight = boyPosY;


  //Se maneja la animación cambiando los sprites en intervalos regulares
  //Los sprites son imagenes para representar personajes --- se cicla el movimiento
  Timer.periodic(Duration(milliseconds: 70), (timer){
    time += 0.05;
    height = -4.9 * time * time + 2.5 * time; // Ajusta la fórmula para un salto más realista

    setState(() {
      if (initialHeight - height > 1){
        boyPosY = 1;
        timer.cancel();
        boySpriteCount = 1;
      } else {
        boyPosY = initialHeight - height;
        boySpriteCount = 2;
      }
    });
  });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           // Mensaje de ataque
       Visibility(
          visible: showAttackMessage, // Controla la visibilidad del mensaje
          child: Container(
            padding: EdgeInsets.all(10),
            color: Colors.black.withOpacity(0.5),
            child: Text(
              attackMessage,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
          Expanded(
            flex: 3,  //controlar cómo se distribuye el espacio disponible entre los hijos de un Row, Column o Flex.
            child: Container(
                color: Colors.blue[300],
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment(snailPosX, 1), //posicionar un widget hijo dentro de su widget padre
                      child: BlueSnail(
                      snailDirection: snailDirection,
                      snailSpriteCount: snailSpriteCount,
                    ),
                    ),
                    Container(
                      alignment: Alignment(teddyPosX, 1),
                      child: MyTeddy(
                      teddyDirection: teddyDirection,
                      teddySpriteCount: teddySpriteCount,
                    ),
                    ),
                    Container(
                      alignment: Alignment(boyPosX, 1),
                      child: MyBoy(
                      boyDirection: boyDirection,
                      boySpriteCount: boySpriteCount % 2 + 1,
                      attackBoySpriteCount: attackBoySpriteCount,
                    ),
                    ),
                    Container(
                      color: loadingScreenColor,
                      child: Center(
                        child: Text(loadingTime.toString(), style: TextStyle(color: loadingScreenTextColor)),
                        ),
                    )
                  ],
                ),
            ),
            ),
          Container(
            height: 10,
            color: Colors.green[600],
          ),
          Expanded(
            child: Container(
                color: Colors.grey[500],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //distribuir el espacio disponible de manera uniforme entre los hijos, incluyendo el espacio antes del primer hijo y después del último hijo.
                  children: [
                    Text('M A P L E S T O R Y', style: TextStyle(color: Colors.white)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, //alinear a los hijos en el centro del eje principal
                      children: [
                        MyButton(
                          text: 'PLAY',
                          function: (){
                            playNow();
                          },
                        ),
                        MyButton(
                          text: 'ATTACK',
                          function: (){
                            attack();
                          }
                        ),
                        MyButton(
                          text: '←',
                          function: (){
                            moveLeft();
                          },
                        ),
                        MyButton(
                          text: '↑',
                          function: (){
                            jump();
                          },
                        ),
                        MyButton(
                          text: '→',
                          function: (){
                            moveRight();
                          },
                        )
                      ],
                    ),
                  ],
                ),
            ),
            )
        ],
      ),
    );
  }
}