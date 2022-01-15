import 'package:flutter/material.dart';
import 'package:memory_box/pages/auth_pages/auth/auth_page.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/button_next.dart';
import 'package:memory_box/widget/circle_app_bar.dart';

class NoAuthUser extends StatelessWidget {
  const NoAuthUser({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void nav() {
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(AuthPage.routeName);
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const CircleAppBar(
              heightCircle: 0,
              title: 'MemoryBox',
              subTitle: 'Твой голос всегда рядом',
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(),
                const Text(
                  'К сожалению вам не доступен этот функционал, для получения полной версии программы авторизируйтесь',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.mainFont,
                      fontSize: 18),
                ),
                const Text(
                  'Все ваши записи будут сохранены на устройстве',
                  style: TextStyle(fontFamily: AppFonts.mainFont),
                ),
                ButtonNext(method: nav),
              ],
            )
          ],
        ),
      ),
    );
  }
}
