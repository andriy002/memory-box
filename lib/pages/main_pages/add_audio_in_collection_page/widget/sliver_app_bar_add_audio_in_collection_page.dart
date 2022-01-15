import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/add_audio_in_collection_page/view_model/view_model_add_audio_in_collection.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

class SliverAppBarAddAudioInColectionPage extends StatelessWidget {
  final Map args;
  const SliverAppBarAddAudioInColectionPage({Key? key, required this.args})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: leftArrowButton(Navigator.of(context).pop),
      actions: [
        TextButton(
          child: const Text(
            'Добавить',
            style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainFont,
                fontSize: 16),
          ),
          onPressed: () {
            context
                .read<ViewModelAddAudioInColection>()
                .addAudioToCollectionList(args);
            Navigator.of(context).pop();
          },
        ),
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
          )
        ],
      ),
      centerTitle: true,
    );
  }
}
