import 'package:flutter/material.dart';
import 'package:memory_box/controlers/navigation.dart';
import 'package:memory_box/services/app_images.dart';
import 'package:provider/provider.dart';

Drawer DrawerComponents(BuildContext context) {
  final model = context.read<NavigationController>();

  return Drawer(
    child: Column(
      children: [
        SizedBox(
          height: 90,
        ),
        Text(
          'Аудиосказки',
          style: TextStyle(fontFamily: 'ttNormal', fontSize: 24),
        ),
        SizedBox(
          height: 40,
        ),
        Text(
          'Меню',
          style: TextStyle(
              fontFamily: 'ttNormal', color: Color(0xFF3A3A55), fontSize: 22),
        ),
        SizedBox(
          height: 80,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
                onPressed: () {
                  model.setCurrentIndex = 0;
                },
                icon: ImageIcon(
                  AppImages.homeBottomNavBar,
                  color: Colors.black,
                ),
                label: Text(
                  'Главная',
                  style: TextStyle(
                      fontFamily: 'ttNormal',
                      fontSize: 18,
                      color: Colors.black),
                )),
            TextButton.icon(
                onPressed: () {
                  model.setCurrentIndex = 4;
                },
                icon: ImageIcon(
                  AppImages.profileBottomNavBar,
                  color: Colors.black,
                ),
                label: Text(
                  'Профиль',
                  style: TextStyle(
                      fontFamily: 'ttNormal',
                      fontSize: 18,
                      color: Colors.black),
                )),
            TextButton.icon(
                onPressed: () {
                  model.setCurrentIndex = 1;
                },
                icon: ImageIcon(
                  AppImages.selectionsBottomNavBar,
                  color: Colors.black,
                ),
                label: Text(
                  'Подборки',
                  style: TextStyle(
                      fontFamily: 'ttNormal',
                      fontSize: 18,
                      color: Colors.black),
                )),
            TextButton.icon(
                onPressed: () {
                  model.setCurrentIndex = 3;
                },
                icon: ImageIcon(
                  AppImages.audioBottomNavBar,
                  color: Colors.black,
                ),
                label: Text(
                  'Все аудиофайлы',
                  style: TextStyle(
                      fontFamily: 'ttNormal',
                      fontSize: 18,
                      color: Colors.black),
                )),
            TextButton.icon(
                onPressed: () {},
                icon: ImageIcon(
                  AppImages.searchBottomNavBar,
                  color: Colors.black,
                ),
                label: Text(
                  'Поиск',
                  style: TextStyle(
                      fontFamily: 'ttNormal',
                      fontSize: 18,
                      color: Colors.black),
                )),
            TextButton.icon(
                onPressed: () {},
                icon: ImageIcon(
                  AppImages.deleteBottomNavBar,
                  color: Colors.black,
                ),
                label: Text(
                  'Недавно удаленные',
                  style: TextStyle(
                      fontFamily: 'ttNormal',
                      fontSize: 18,
                      color: Colors.black),
                )),
            SizedBox(
              height: 50,
            ),
            TextButton.icon(
                onPressed: () {},
                icon: ImageIcon(
                  AppImages.editBottomNavBar,
                  color: Colors.black,
                ),
                label: Text(
                  'Написать в поддержку ',
                  style: TextStyle(
                      fontFamily: 'ttNormal',
                      fontSize: 18,
                      color: Colors.black),
                )),
          ],
        ),
      ],
    ),
  );
}
