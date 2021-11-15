import 'package:flutter/material.dart';

import 'custom_app_bar.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        CustomAppBar(),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Text(
            'Регистрация',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'ttNormal',
                fontSize: 48,
                fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
