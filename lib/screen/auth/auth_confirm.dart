import 'package:flutter/material.dart';
import 'package:memory_box/widget/widget_auth/start_button.dart';
import 'package:memory_box/services/auth_services.dart';
import 'package:memory_box/widget/widget_auth/app_bar_register.dart';
import 'package:memory_box/widget/widget_auth/input_auth.dart';

class AuthConfirm extends StatelessWidget {
  final TextEditingController _code = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            AppBarCustom(),
            Container(
              width: 230,
              padding: EdgeInsets.only(top: 70),
              child: Text(
                'Введи код из смс, чтобы мы тебя запомнили',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontFamily: 'ttNormal'),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            InputAuth(context, _code),
            SizedBox(
              height: 60,
            ),
            StartButton(() async {
              AuthServices().verifyCode(context, _code.text);
            }),
            SizedBox(
              height: 80,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              child: Text(
                'Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
                style: TextStyle(fontSize: 14, fontFamily: 'ttNormal'),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
