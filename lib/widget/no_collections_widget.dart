import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/create_collection_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';

class NoCollectionWidget extends StatelessWidget {
  const NoCollectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            const Text(
              'У вас пока нет подборок',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.mainFont,
                fontSize: 24,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, CreateNewCollection.routeName);
              },
              child: const Text(
                'Создать',
                style: TextStyle(
                  color: AppColors.recordColor,
                  fontSize: 24,
                  fontFamily: AppFonts.mainFont,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
