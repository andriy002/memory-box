import 'package:flutter/material.dart';
import 'package:memory_box/pages/auth_pages/auth/auth_page.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/button_next.dart';
import 'package:memory_box/widget/circle_app_bar.dart';

class WelcomPage extends StatelessWidget {
  const WelcomPage({Key? key}) : super(key: key);
  static const routeName = '/welcom_page';

  @override
  Widget build(BuildContext context) {
    void _nextPage() {
      Navigator.of(context).pushReplacementNamed(AuthPage.routeName);
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CircleAppBar(
              heightCircle: MediaQuery.of(context).size.height / 3.5,
              title: 'MemoryBox',
              subTitle: 'Твой голос всегда рядом',
            ),
            const SizedBox(height: 90),
            _title(),
            _subTitle(context),
            const SizedBox(height: 80),
            ButtonNext(
              method: () => _nextPage(),
            )
          ],
        ),
      ),
    );
  }

  Widget _title() {
    const String title = 'Привет!';
    return const Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontFamily: AppFonts.mainFont,
        ),
      ),
    );
  }
}

Widget _subTitle(BuildContext context) {
  const String title =
      'Мы рады видеть тебя здесь.Это приложение поможет записывать сказки и держать их в удобном месте не заполняя память на телефоне';
  return Container(
    width: MediaQuery.of(context).size.width / 1.4,
    padding: const EdgeInsets.only(top: 20),
    child: const Text(
      title,
      style: TextStyle(
        fontFamily: AppFonts.mainFont,
        fontSize: 16,
      ),
      textAlign: TextAlign.center,
    ),
  );
}
