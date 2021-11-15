import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/widget/widget_auth/start_button.dart';
import 'package:memory_box/services/auth_services.dart';
import 'package:memory_box/widget/widget_auth/app_bar_register.dart';
import 'package:memory_box/widget/widget_auth/input_auth.dart';

class Auth extends StatelessWidget {
  final TextEditingController _phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            AppBarCustom(),
            PhoneInput(phone: _phone),
            SizedBox(
              height: 60,
            ),
            ButtomSendSms(phone: _phone),
            SizedBox(
              height: 20,
            ),
            ButtomAnonAuth(),
            SizedBox(
              height: 30,
            ),
            TextAuth(context)
          ],
        ),
      ),
    );
  }

  Container TextAuth(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.4,
      child: Text(
        'Регистрация привяжет твои сказки  к облаку, после чего они всегда будут с тобой',
        style: TextStyle(fontSize: 14, fontFamily: 'ttNormal'),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ButtomAnonAuth extends StatelessWidget {
  const ButtomAnonAuth({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          AuthServices().signInAnon();

          Navigator.of(context).pushReplacementNamed('/main_screen');
        },
        child: Text(
          'Позже',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'ttNormal',
          ),
        ));
  }
}

class ButtomSendSms extends StatelessWidget {
  const ButtomSendSms({
    Key? key,
    required TextEditingController phone,
  })  : _phone = phone,
        super(key: key);

  final TextEditingController _phone;

  @override
  Widget build(BuildContext context) {
    return StartButton(() => {
          if (_phone.text.isNotEmpty && _phone.text.length > 10)
            {
              AuthServices().verifyPhoneNumber(context, _phone.text),
              Navigator.of(context).pushNamed('/auth_confirm')
            }
        });
  }
}

class PhoneInput extends StatelessWidget {
  const PhoneInput({
    Key? key,
    required TextEditingController phone,
  })  : _phone = phone,
        super(key: key);

  final TextEditingController _phone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 75),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Введи номер телефона',
            style: TextStyle(fontFamily: 'ttNormal', fontSize: 16),
          ),
          SizedBox(
            height: 30,
          ),
          InputAuth(context, _phone)
        ],
      ),
    );
  }
}
