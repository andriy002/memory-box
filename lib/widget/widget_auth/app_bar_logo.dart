import 'package:flutter/material.dart';

import 'custom_app_bar.dart';

class AppBarCustomLogo extends StatelessWidget {
  const AppBarCustomLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CustomAppBar(),
        Container(
          height: MediaQuery.of(context).size.height / 3,
          padding: const EdgeInsets.only(top: 140),
          child: Column(
            children: [
              Text('MemoryBox',
                  style: TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontFamily: 'ttNormal',
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(left: 90),
                child: Text(
                  'Твой голос всегда рядом',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
