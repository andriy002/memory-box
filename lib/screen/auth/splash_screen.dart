import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory_box/widget/widget_auth/custom_app_bar.dart';
import 'package:memory_box/widget/widget_auth/heart_pic.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3),
        () => Navigator.of(context).pushReplacementNamed('/main_screen'));
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                const CustomAppBar(),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
                  padding: const EdgeInsets.only(top: 140),
                  child: Column(
                    children: [
                      const Text('Ты супер!',
                          style: TextStyle(
                              fontSize: 48,
                              color: Colors.white,
                              fontFamily: 'ttNormal',
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 120,
            ),
            const Text(
              'Мы рады тебя видеть',
              style: TextStyle(
                fontFamily: 'ttNormal',
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            HeartPic(),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
