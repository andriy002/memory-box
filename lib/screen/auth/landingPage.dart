import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory_box/widget/widget_auth/app_bar_logo.dart';
import 'package:memory_box/widget/widget_auth/heart_pic.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed('/main_screen'));

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarCustomLogo(),
            SizedBox(
              height: 120,
            ),
            Text(
              'Мы рады тебя видеть',
              style: TextStyle(
                fontFamily: 'ttNormal',
                fontSize: 24,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            HeartPic(),
            SizedBox(
              height: 100,
            ),
            Container(
                width: 250,
                child: Text(
                  'Взрослые иногда нуждаются в сказке даже больше, чем дети',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'ttNormal', fontSize: 14),
                ))
          ],
        ),
      ),
    );
  }
}
