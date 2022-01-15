import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/view_model/view_model_create_collection.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:memory_box/widget/search_wigdet.dart';
import 'package:provider/provider.dart';

class SliverAppBarSearchPage extends StatelessWidget {
  const SliverAppBarSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchKeyChanged = context.read<ViewModelAudio>().searchKeyInput;

    return SliverAppBar(
      leading: leftArrowButton(() {
        context.read<ViewModelCreateCoolection>().openAddAudioPage();
      }),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextButton(
              onPressed: () {
                context.read<ViewModelAudio>().addAudioToCollection('selected');
                context.read<ViewModelCreateCoolection>().openAddAudioPage();
              },
              child: const Text(
                'Добавить',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.mainFont,
                    fontSize: 16),
              )),
        ),
      ],
      backgroundColor: Colors.white,
      expandedHeight: MediaQuery.of(context).size.height / 3,
      floating: false,
      pinned: false,
      snap: false,
      title: Column(
        children: const [
          Text(
            'Выбрать',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            CircleAppBar(
              heightCircle: MediaQuery.of(context).size.height / 6,
              colorCircle: AppColors.collectionsColor,
            ),
            SearchWidget(
              onChanged: _searchKeyChanged,
            )
          ],
        ),
      ),
    );
  }
}
