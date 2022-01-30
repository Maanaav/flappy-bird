import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:my_app/screen/barriers.dart';
import 'package:my_app/screen/bird.dart';
import 'package:my_app/tapAPIModel.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameHasStarted = false;
  static double barrierX1 = 1;
  double barrierX2 = barrierX1 + 1.5;
  TextEditingController input_username = TextEditingController();

  void jump() {
    setState(() {
      time = 0;
      initialHeight = birdYaxis;
    });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      birdYaxis = 0;
      gameHasStarted = false;
      time = 0;
      initialHeight = birdYaxis;
      barrierX1 = 1;
      barrierX2 = barrierX1 + 1.5;
    });
  }

  void _showdialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            backgroundColor: Colors.brown,
            title: Column(
              children: [
                Image.asset(
                  "lib/assets/dead_flappy_bird.png",
                  width: 300,
                ),
                const Center(
                  child: Text(
                    "G A M E  O V E R",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  resetGame();
                  print("space");
                  callApis("space");
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      "letter space",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  resetGame();
                  print("/");
                  callApis("slash");
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      "word space",
                      style: TextStyle(color: Colors.brown),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void startGame() {
    gameHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 50), (timer) {
      time += 0.04;
      height = -4.5 * time * time + 2.8 * time;
      setState(() {
        birdYaxis = initialHeight - height;
      });

      setState(() {
        if (barrierX1 < -2) {
          barrierX1 += 3.5;
        } else {
          barrierX1 -= 0.05;
        }
      });

      setState(() {
        if (barrierX2 < -2) {
          barrierX2 += 3.5;
        } else {
          barrierX2 -= 0.05;
        }
      });

      if (birdYaxis > 1) {
        timer.cancel();
        gameHasStarted = false;
        _showdialog();
      }
    });
  }

  TextButton okButton() {
    return (TextButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    ));
  }

  void usernameAlert() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              title: const Text("Enter your name"),
              content: TextField(
                controller: input_username,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              actions: [
                okButton(),
              ],
            ));
  }

  @override
  void initState() {
    super.initState();
    // Future(usernameAlert);
    Timer.run(usernameAlert);
  }

  void callApis(tap) {
    http
        .get(Uri.parse("https://cyberdeploy.herokuapp.com/tap/" +
            input_username.text +
            "/" +
            tap))
        .then((result) {
      var res = json.decode(result.body);
      print(res);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (gameHasStarted) {
          jump();
          print(".");
          callApis("dot");
        } else {
          startGame();
        }
      },
      onPanStart: (d) {
        if (gameHasStarted) {
          jump();
          print("dash");
          callApis("-");
        } else {
          startGame();
        }
      },
      child: Scaffold(
        body: Container(
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        alignment: Alignment(0, birdYaxis),
                        color: Colors.blue,
                        duration: const Duration(milliseconds: 0),
                        child: const MyBird(),
                      ),
                      Container(
                          alignment: const Alignment(0, -0.4),
                          child: gameHasStarted
                              ? const Text("")
                              : const Text("T A P    T O    P L A Y")),
                      AnimatedContainer(
                        alignment: Alignment(barrierX1, 1.1),
                        duration: const Duration(milliseconds: 0),
                        child: Barrier(
                          size: 200.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierX1, -1.1),
                        duration: const Duration(milliseconds: 0),
                        child: Barrier(
                          size: 200.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierX2, 1.1),
                        duration: const Duration(milliseconds: 0),
                        child: Barrier(
                          size: 150.0,
                        ),
                      ),
                      AnimatedContainer(
                        alignment: Alignment(barrierX2, 1.1),
                        duration: const Duration(milliseconds: 0),
                        child: Barrier(
                          size: 250.0,
                        ),
                      ),
                    ],
                  )),
              Container(
                height: 15,
                color: Colors.green,
              ),
              Expanded(
                  child: Container(
                color: Colors.brown,
                // child: Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Text(
                //           "SCORE",
                //           style: TextStyle(fontSize: 20, color: Colors.white),
                //         ),
                //         const SizedBox(
                //           height: 20,
                //         ),
                //         Text("0",
                //             style:
                //                 TextStyle(fontSize: 35, color: Colors.white)),
                //       ],
                //     ),
                //     Column(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         const Text("BEST",
                //             style:
                //                 TextStyle(fontSize: 20, color: Colors.white)),
                //         const SizedBox(
                //           height: 20,
                //         ),
                //         Text("10",
                //             style:
                //                 TextStyle(fontSize: 35, color: Colors.white)),
                //       ],
                //     ),
                //   ],
                // ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
