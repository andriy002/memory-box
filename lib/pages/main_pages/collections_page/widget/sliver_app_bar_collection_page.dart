import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_page/widget/pop_up_menu_collection_page.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/create_collection_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';

class SliverAppBarCollectionPage extends StatelessWidget {
  const SliverAppBarCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.of(context).pushNamed(CreateNewCollection.routeName);
        },
        icon: const Icon(Icons.add),
      ),
      actions: const [
        PopupMenuCollectionPage(),
        SizedBox(
          width: 10,
        )
      ],
      backgroundColor: AppColors.collectionsColor,
      expandedHeight: MediaQuery.of(context).size.height / 10,
      floating: false,
      pinned: false,
      snap: false,
      title: Column(
        children: const [
          Text(
            'Подборки',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'Все в одном месте',
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 16,
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
      centerTitle: true,
    );
  }
}
