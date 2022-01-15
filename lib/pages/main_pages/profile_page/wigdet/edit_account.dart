import 'package:flutter/material.dart';
import 'package:memory_box/pages/auth_pages/welcome_page.dart';
import 'package:memory_box/pages/main_pages/profile_page/view_model_profile/view_model_profile.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class EditAccountWidget extends StatelessWidget {
  const EditAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void nav() {
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(WelcomPage.routeName);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        TextButton(
          onPressed: () {
            context.read<ViewModelProfile>().signOut(nav);
          },
          child: const Text(
            'Выйти из приложения',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 14,
                color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () {
            _deletedDialog(context);
          },
          child: const Text(
            'Удалить аккаунт',
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              color: Colors.red,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _deletedDialog(BuildContext context) {
    void nav() {
      Navigator.of(context, rootNavigator: true)
          .pushReplacementNamed(WelcomPage.routeName);
    }

    return showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: const Text(
          'Точно удалить аккаунт?',
          style: TextStyle(
            fontFamily: AppFonts.mainFont,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        content: const SizedBox(
          width: 150,
          child: Text(
            'Все аудиофайлы исчезнут и восстановить аккаунт будет невозможно',
            style: TextStyle(fontFamily: AppFonts.mainFont, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25))),
                    minimumSize: MaterialStateProperty.all(const Size(124, 41)),
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xFFE27777),
                    ),
                  ),
                  onPressed: () {
                    context.read<ViewModelProfile>().deleteAcc(nav);
                  },
                  child: const Text(
                    'Удалить',
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 16,
                    ),
                  )),
              const SizedBox(
                width: 10,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(84, 41)),
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: const BorderSide(color: AppColors.mainColor),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Нет',
                    style: TextStyle(
                        fontFamily: AppFonts.mainFont,
                        fontSize: 16,
                        color: AppColors.mainColor),
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
