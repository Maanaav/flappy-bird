import 'package:flutter/cupertino.dart';

class MyBird extends StatelessWidget {
  const MyBird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        width: 90,
        child: Image.asset('lib/assets/flappy_bird.png'));
  }
}
