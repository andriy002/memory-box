import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';

class NoAudioWidget extends StatelessWidget {
  const NoAudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text(
                'Как только ты запишешь \n аудио, она появится здесь.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontFamily: AppFonts.mainFont,
                ),
              ),
              ImageIcon(
                AppIcons.arrowDown,
                size: 100,
                color: Colors.grey,
              ),
              SizedBox()
            ],
          ),
        ));
  }
}
