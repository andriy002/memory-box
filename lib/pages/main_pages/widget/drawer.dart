import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

class Drawwer extends StatelessWidget {
  const Drawwer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 90,
          ),
          const Text(
            'Аудиосказки',
            style: TextStyle(fontFamily: 'ttNormal', fontSize: 24),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Меню',
            style: TextStyle(
                fontFamily: 'ttNormal', color: Color(0xFF3A3A55), fontSize: 22),
          ),
          const SizedBox(
            height: 80,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              _DrawerItem(
                index: 0,
                icon: AppIcons.home,
                title: 'Главная',
              ),
              _DrawerItem(
                index: 4,
                icon: AppIcons.profile,
                title: 'Профиль',
              ),
              _DrawerItem(
                index: 1,
                icon: AppIcons.selections,
                title: 'Подборки',
              ),
              _DrawerItem(
                index: 3,
                icon: AppIcons.audio,
                title: 'Все аудиофайлы',
              ),
              _DrawerItem(
                index: 5,
                icon: AppIcons.search,
                title: 'Поиск',
              ),
              _DrawerItem(
                index: 6,
                icon: AppIcons.delete,
                title: 'Недавно удаленные',
              ),
              SizedBox(height: 50),
              _DrawerItem(
                index: 0,
                icon: AppIcons.edit,
                title: 'Написать в \n поддержку ',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final int index;
  final AssetImage icon;
  final String title;

  const _DrawerItem({
    Key? key,
    required this.index,
    required this.icon,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Navigation>();

    void _setIndex(int index) {
      model.setCurrentIndex = index;
    }

    return TextButton.icon(
        onPressed: () {
          _setIndex(index);
          Navigator.pop(context);
        },
        icon: ImageIcon(
          icon,
          color: Colors.black,
        ),
        label: Text(
          title,
          style: const TextStyle(
            fontFamily: AppFonts.mainFont,
            fontSize: 18,
            color: Colors.black,
          ),
        ));
  }
}
