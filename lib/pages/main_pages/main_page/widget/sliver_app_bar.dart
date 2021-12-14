import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:provider/provider.dart';

class SliverAppBarWidget extends StatelessWidget {
  const SliverAppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        backgroundColor: Colors.white,
        expandedHeight: MediaQuery.of(context).size.height / 2.3,
        floating: false,
        pinned: false,
        snap: false,
        flexibleSpace: FlexibleSpaceBar(
          background: Stack(
            alignment: Alignment.center,
            children: [
              CircleAppBar(
                  heightCircle: MediaQuery.of(context).size.height / 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 90,
                    ),
                    _appBarTitle(context),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 3.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _bigCard(context),
                          _smallCards(context),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Row _appBarTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Подборки',
          style: TextStyle(
            color: Colors.white,
            fontFamily: AppFonts.mainFont,
            fontSize: 24,
          ),
        ),
        TextButton(
            onPressed: () {
              context.read<Navigation>().setCurrentIndex = 1;
            },
            child: const Text(
              'Открыть все',
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                  fontSize: 14),
            ))
      ],
    );
  }
}

SizedBox _bigCard(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 2.3,
    height: MediaQuery.of(context).size.height,
    child: Card(
      color: const Color(0xE671A59F),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 150,
            child: Text(
              'Здесь будет твой набор сказок',
              style: TextStyle(
                fontFamily: AppFonts.mainFont,
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 30),
          TextButton(
              onPressed: () {},
              child: const Text(
                'Добавить',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: AppFonts.mainFont,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ))
        ],
      ),
    ),
  );
}

SizedBox _smallCards(BuildContext context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 2.3,
    height: MediaQuery.of(context).size.height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 7.2,
          width: double.infinity,
          child: Card(
            color: const Color(0xE6F1B488),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'Тут',
                style: TextStyle(
                    fontFamily: AppFonts.mainFont,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 7.2,
          width: double.infinity,
          child: Card(
            color: const Color(0xE6678BD2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
              child: Text(
                'И тут',
                style: TextStyle(
                    fontFamily: AppFonts.mainFont,
                    color: Colors.white,
                    fontSize: 20),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
