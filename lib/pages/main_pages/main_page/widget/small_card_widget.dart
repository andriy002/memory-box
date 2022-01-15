import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/sliver_collection_widget.dart';
import 'package:memory_box/resources/app_fonts.dart';

class SmallCard extends StatelessWidget {
  final List dataCollections;
  const SmallCard({Key? key, required this.dataCollections}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: dataCollections.length > 1
                ? SliverCollectionsWidget(
                    img: dataCollections[1].image,
                    name: dataCollections[1].name,
                    displayName: dataCollections[1].displayName,
                    description: dataCollections[1].descriptions)
                : Card(
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
            child: dataCollections.isNotEmpty
                ? SliverCollectionsWidget(
                    img: dataCollections[0].image,
                    name: dataCollections[0].name,
                    displayName: dataCollections[0].displayName,
                    description: dataCollections[0].descriptions)
                : Card(
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
}
