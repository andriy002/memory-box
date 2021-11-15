import 'package:flutter/material.dart';

class StartButton extends StatelessWidget {
  final nextBth;
  const StartButton(
    this.nextBth, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: nextBth,
      child: Text(
        'Продолжить',
        style: TextStyle(fontSize: 18),
      ),
      style: ButtonStyle(
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(51))),
          minimumSize: MaterialStateProperty.all(Size(309, 59)),
          backgroundColor: MaterialStateProperty.all(Color(0xFFF1B488))),
    );
  }
}
