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
      debugShowCheckedModeBanner: false,
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

  //bLUEsNAIL
  int snailSpriteCount = 1;
  static double snailPosX = 0.5;
  //static double snailPosY = 1;
  String snailDirection = 'left';
  //int deadSnailSprite = 0;
  //bool snailAttacked = false;

  //Teddy
  int teddySpriteCount = 1;
  double teddyPosX = 0;
  String teddyDirection = 'right';

  //personaje
  int boySpriteCount = 1;
  double boyPosX = -0.5;
  double boyPosY = 1;
  String boyDirection = 'right';
  int attackBoySpriteCount = 0;

  //loading scren
  var loadingScreenColor = Colors.blue[100];
  var loadingScreenTextColor = Colors.blue[700];
  var tapToPlayColor = Colors.white;
  int loadingTime = 3;
  //bool gameHasStarted = false;

  //mensaje de golpe
   String attackMessage = '';
   bool showAttackMessage = false;

  void playNow(){
    startGameTimer();
    moveSnail();
    moveTeddy();
    attack();
  }

  void startGameTimer(){
    Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        loadingTime--;
      });

      if (loadingTime == 0){
          setState(() {
              loadingScreenColor = Colors.transparent;
              loadingTime = 3;
              loadingScreenTextColor = Colors.transparent;
          });
          timer.cancel();
        }
    });
  }

  void attack() {
  setState(() {
    attackBoySpriteCount = 1;// Inicia la animación de ataque
    attackMessage = '';
    showAttackMessage = false;
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

  void moveLeft(){
    setState(() {
      boyPosX -= 0.03;
      boySpriteCount++;
      boyDirection = 'left';
    });
  }

  void moveRight(){
    setState(() {
      boyPosX += 0.03;
      boySpriteCount++;
      boyDirection = 'right';
    });
  }

  void jump (){
  double time = 0;
  double height = 0;
  double initialHeight = boyPosY;

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
            flex: 3,
            child: Container(
                color: Colors.blue[300],
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment(snailPosX, 1),
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('M A P L E S T O R Y', style: TextStyle(color: Colors.white)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
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