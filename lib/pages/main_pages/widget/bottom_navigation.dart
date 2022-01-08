import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/profile_page/profile_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 80,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 8),
          ],
        ),
        child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: BottomAppBar(
              color: Colors.white,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _ButtonItem(
                    title: 'Главная',
                    icon: AppIcons.home,
                    index: 0,
                  ),
                  _ButtonItem(
                    title: 'Подборки',
                    icon: AppIcons.selections,
                    index: 1,
                  ),
                  _RecordItem(),
                  _ButtonItem(
                    title: 'Аудио',
                    icon: AppIcons.audio,
                    index: 3,
                  ),
                  _ButtonItem(
                    title: 'Профиль',
                    icon: AppIcons.profile,
                    index: 4,
                  ),
                ],
              ),
            )));
  }
}

class _ButtonItem extends StatelessWidget {
  final String title;
  final AssetImage icon;
  final int index;
  const _ButtonItem({
    Key? key,
    required this.title,
    required this.icon,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Navigation>();

    void _setIndex(int index) {
      model.setCurrentIndex = index;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            icon: ImageIcon(
              icon,
              color: model.currentIndex == index
                  ? AppColors.mainColor
                  : Colors.black,
            ),
            onPressed: () {
              _setIndex(index);
            }),
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.mainFont,
            fontSize: 12,
            color: model.currentIndex == index
                ? AppColors.mainColor
                : Colors.black,
          ),
        )
      ],
    );
  }
}

class _RecordItem extends StatelessWidget {
  const _RecordItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<Navigation>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: AppColors.recordColor),
          child: IconButton(
              color: Colors.yellow,
              icon: ImageIcon(
                AppIcons.record,
                color: model.currentIndex != 2
                    ? Colors.white
                    : AppColors.recordColor,
              ),
              onPressed: () {
                model.setCurrentIndex = 2;
              }),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          'Запись',
          style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 12,
              color: model.currentIndex != 2
                  ? AppColors.recordColor
                  : Colors.white),
        )
      ],
    );
  }
}
