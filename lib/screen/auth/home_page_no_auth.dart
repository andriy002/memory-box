import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/widget/widget_auth/start_button.dart';
import 'package:memory_box/widget/widget_auth/app_bar_logo.dart';

class HomePageNoAuth extends StatelessWidget {
  const HomePageNoAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBarCustomLogo(),
            Padding(
              padding: const EdgeInsets.only(top: 75),
              child: Text(
                'Привет!',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'ttNormal',
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              padding: EdgeInsets.only(top: 20),
              child: Text(
                'Мы рады видеть тебя здесь.Это приложение поможет записывать сказки и держать их в удобном месте не заполняя память на телефоне',
                style: TextStyle(
                  fontFamily: 'ttNormal',
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 45),
              child: StartButton(
                  () => {Navigator.of(context).pushReplacementNamed('/auth')}),
            )
          ],
        ),
      ),
    );
  }
}
