import 'package:flutter/material.dart';
import 'package:memory_box/controlers/navigation.dart';
import 'package:memory_box/services/app_images.dart';
import 'package:provider/src/provider.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<NavigationController>();

    void onTap(int index) {
      switch (index) {
        case 0:
          model.setCurrentIndex = 0;

          break;
        case 1:
          model.setCurrentIndex = 1;

          break;
        case 2:
          model.setCurrentIndex = 2;

          break;
        case 3:
          model.setCurrentIndex = 3;

          break;
        case 4:
          model.setCurrentIndex = 4;

          break;
      }
    }

    return Container(
        width: double.infinity,
        height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 8),
          ],
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: BottomAppBar(
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: ImageIcon(
                            AppImages.homeBottomNavBar,
                            color: model.currentIndex == 0
                                ? Color(0xFF8C84E2)
                                : Colors.black,
                          ),
                          onPressed: () {
                            onTap(0);
                          }),
                      Text(
                        'Главная',
                        style: TextStyle(
                          fontFamily: 'ttNormal',
                          fontSize: 12,
                          color: model.currentIndex == 0
                              ? Color(0xFF8C84E2)
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: ImageIcon(
                            AppImages.selectionsBottomNavBar,
                            color: model.currentIndex == 1
                                ? Color(0xFF8C84E2)
                                : Colors.black,
                          ),
                          onPressed: () {
                            onTap(1);
                          }),
                      Text(
                        'Подборки',
                        style: TextStyle(
                          fontFamily: 'ttNormal',
                          fontSize: 12,
                          color: model.currentIndex == 1
                              ? Color(0xFF8C84E2)
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Color(0xFFF1B488)),
                        child: IconButton(
                            color: Colors.yellow,
                            icon: ImageIcon(
                              AppImages.recordBottomNavBar,
                              color: model.currentIndex != 2
                                  ? Colors.white
                                  : Color(0xFFF1B488),
                            ),
                            onPressed: () async {
                              onTap(2);
                            }),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Запись',
                        style: TextStyle(
                            fontFamily: 'ttNormal',
                            fontSize: 12,
                            color: model.currentIndex != 2
                                ? Color(0xFFF1B488)
                                : Colors.white),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: ImageIcon(
                            AppImages.audioBottomNavBar,
                            color: model.currentIndex == 3
                                ? Color(0xFF8C84E2)
                                : Colors.black,
                          ),
                          onPressed: () {
                            onTap(3);
                          }),
                      Text(
                        'Аудио',
                        style: TextStyle(
                          fontFamily: 'ttNormal',
                          fontSize: 12,
                          color: model.currentIndex == 3
                              ? Color(0xFF8C84E2)
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: ImageIcon(
                            AppImages.profileBottomNavBar,
                            color: model.currentIndex == 4
                                ? Color(0xFF8C84E2)
                                : Colors.black,
                          ),
                          onPressed: () {
                            onTap(4);
                          }),
                      Text(
                        'Профиль',
                        style: TextStyle(
                          fontFamily: 'ttNormal',
                          fontSize: 12,
                          color: model.currentIndex == 4
                              ? Color(0xFF8C84E2)
                              : Colors.black,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}
