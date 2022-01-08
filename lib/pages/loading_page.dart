import 'dart:async';

import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/main.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/heart_picker.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);
  static const routeName = '/loading_page';

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    Timer(
      const Duration(seconds: 3),
      () => Navigator.of(context).pushReplacementNamed(Main.routeName),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAppBar(
                heightCircle: MediaQuery.of(context).size.height / 3.5,
                title: 'MemoryBox',
                subTitle: 'Твой голос всегда рядом',
              ),
              const SizedBox(height: 5),
              const Text(
                'Мы рады тебя видеть',
                style: TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 24,
                ),
              ),
              const HeartPic(),
              const SizedBox(height: 50),
              const SizedBox(
                  width: 250,
                  child: Text(
                    'Взрослые иногда нуждаются в сказке даже больше, чем дети',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 14,
                    ),
                  )),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
