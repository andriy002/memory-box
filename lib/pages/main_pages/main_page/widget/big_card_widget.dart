import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/create_collection_page.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/sliver_collection_widget.dart';
import 'package:memory_box/resources/app_fonts.dart';

class BigCard extends StatelessWidget {
  final List dataCollections;

  const BigCard({Key? key, required this.dataCollections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.3,
      height: MediaQuery.of(context).size.height,
      child: dataCollections.length > 2
          ? SliverCollectionsWidget(
              img: dataCollections[2].image,
              name: dataCollections[2].name,
              displayName: dataCollections[2].displayName,
              description: dataCollections[2].descriptions)
          : Card(
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
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(CreateNewCollection.routeName);
                      },
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
}
