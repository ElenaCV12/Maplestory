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
  int boyHealth = 5; // Salud inicial del personaje
  bool isGameOver = false; // Estado del juego
  bool isGameRestart = false; //Reinicia el juego

  //loading scren---controlar la pantalla de carga
  var loadingScreenColor = Colors.blue[100];
  var loadingScreenTextColor = Colors.blue[700];
  var tapToPlayColor = Colors.white;
  int loadingTime = 3;
  //bool gameHasStarted = false;

  //mensaje de golpe
   String attackMessage = '';
   bool showAttackMessage = false;

   //estado del caracol
   bool isSnailDead = false; // Estado del caracol
   int snailHealth = 3; // Salud inicial del caracol

    // Temporizadores
  Timer? snailTimer;
  Timer? teddyTimer;
  Timer? attackTimer;

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

void restartGame() {
  setState(() {
    // Cancela los temporizadores existentes
    snailTimer?.cancel();
    teddyTimer?.cancel();
    attackTimer?.cancel();

    boyHealth = 5;

    snailPosX = 0.5;
    snailDirection = 'left';
    isSnailDead = false;
    snailHealth = 3;

    teddyPosX = 0;
    teddyDirection = 'right';


    boyPosX = -0.5;
    boyPosY = 1;
    boyDirection = 'right';
    attackBoySpriteCount = 0;

    isGameOver = false;

    // Reiniciar los temporizadores
    moveSnail();
    moveTeddy();
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
      // Verifica si el ataque golpea al caracol
      if (boyDirection == 'right' && boyPosX + 0.2 > snailPosX && !isSnailDead) {
        setState(() {
          snailHealth--; // Reduce la salud del caracol
          if (snailHealth <= 0) {
            isSnailDead = true; // Mata al caracol si su salud llega a cero
            attackMessage = 'SNAIL DEFEATED!';
          } else {
            attackMessage = 'HIT! Health: $snailHealth';
          }
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


void showGameOverDialog() {
  setState(() {
    isGameOver = true; // Marca el juego como terminado
  });

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        title: Text("Game Over"),
        content: Text("Boy has been defeated."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              // Aquí puedes reiniciar el juego o salir
            },
            child: Text("OK"),
          ),
        ],
      );
    },
  );
}

  //Maneja la salud del personaje
void reduceBoyHealth() {
  setState(() {
    boyHealth--; // Reduce la salud del personaje
    if (boyHealth <= 0) {
      boyHealth = 0; // Asegúrate de que la salud no sea negativa

      // Cancela todos los temporizadores
      snailTimer?.cancel();
      teddyTimer?.cancel();
      attackTimer?.cancel();

      showGameOverDialog(); // Muestra el diálogo de "Game Over"
    }
  });
}


  //Maneja el movimiento del oso
void moveTeddy() {
  teddyTimer = Timer.periodic(Duration(milliseconds: 250), (timer) {
    if (isGameOver) {
      timer.cancel(); // Detiene el temporizador si el juego terminó
      return;
    }

    setState(() {
      teddySpriteCount++;

      if (teddySpriteCount == 19) {
        teddySpriteCount = 1;
      }

      if ((teddyPosX - boyPosX).abs() > 0.2) {
        if (boyDirection == 'right') {
          teddyPosX = boyPosX - 0.2;
        } else if (boyDirection == 'left') {
          teddyPosX = boyPosX + 0.2;
        }
      }

      if (teddyPosX - boyPosX > 0) {
        teddyDirection = 'left';
      } else {
        teddyDirection = 'right';
      }
    });
  });
}

  //Maneja el movimiento del caracol
void moveSnail() {
  snailTimer = Timer.periodic(Duration(milliseconds: 150), (timer) {
    if (isSnailDead || isGameOver) {
      timer.cancel(); // Detiene el temporizador si el caracol está muerto o el juego terminó
      return;
    }

    setState(() {
      snailSpriteCount++;

      if (snailDirection == 'left') {
        snailPosX -= 0.01;
      } else {
        snailPosX += 0.01;
      }

      if (snailPosX < 0.3) {
        snailDirection = 'right';
      } else if (snailPosX > 0.6) {
        snailDirection = 'left';
      }

      if (snailSpriteCount == 5) {
        snailSpriteCount = 1;
      }

      // Verificar colisión con el "boy"
      if ((snailPosX - boyPosX).abs() < 0.1 && !isSnailDead) {
        reduceBoyHealth(); // Reduce la salud del "boy" si hay colisión
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
    time += 0.10; // Incremento actual
    //Reduce el valor para un salto más lento: time += 0.03;.
    //Aumenta el valor para un salto más rápido: time += 0.08;.
    height = -3 * time * time + 3 * time; // Ajusta la fórmula para un salto más realista // Salto más alto y lento
    //Aumenta 2.5 para un salto más alto.
    //Reduce 4.9 para un salto más lento y suave.


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
          // Mostrar la salud del "boy"
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            'Boy Health: $boyHealth',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                      alignment: Alignment(snailPosX, 1),
                      child: isSnailDead
                      ? SizedBox.shrink() // Oculta el caracol si está muerto
                      : BlueSnail(
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
                          function: isGameOver ? null : (){
                            playNow();
                          },
                        ),
                        MyButton(
                          text: 'ATTACK',
                          function: isGameOver ? null : (){
                            attack();
                          }
                        ),
                        MyButton(
                          text: '←',
                          function: isGameOver ? null : (){
                            moveLeft();
                          },
                        ),
                        MyButton(
                          text: '↑',
                          function: isGameOver ? null : (){
                            jump();
                          },
                        ),
                        MyButton(
                          text: '→',
                          function: isGameOver ? null : (){
                            moveRight();
                          },
                        ),
                        MyButton(
                        text: 'RESTART',
                        function: isGameOver ? () { restartGame(); } : null,
                        ),
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