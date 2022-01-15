import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/view_model/view_model_create_collection.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/widget/collection_image_widget.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/widget/description_widget.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

import 'collection_name_widget.dart';

class AppBarCollectionCreate extends StatelessWidget {
  const AppBarCollectionCreate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _nameCollection = context
        .select((ViewModelCreateCoolection vm) => vm.state.collectionName);

    return SliverAppBar(
      leading: leftArrowButton(
        () {
          context.read<ViewModelCreateCoolection>().deleteFields();
          Navigator.of(context).pop();
        },
      ),
      actions: [
        TextButton(
          onPressed: () async {
            if (await context
                    .read<ViewModelCreateCoolection>()
                    .createCollection() ==
                false) {
              Navigator.of(context).pop();

              context.read<ViewModelAudio>().addAudioToCollection(
                    _nameCollection!,
                  );
            }
          },
          child: const Text(
            'Готово',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                color: Colors.white,
                fontSize: 16),
          ),
        ),
      ],
      expandedHeight: MediaQuery.of(context).size.height / 2,
      floating: false,
      pinned: false,
      snap: false,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.white,
      title: const Text(
        'Создание',
        style: TextStyle(
          fontFamily: AppFonts.mainFont,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Stack(
            children: [
              CircleAppBar(
                heightCircle: MediaQuery.of(context).size.height / 4,
                colorCircle: AppColors.collectionsColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 85),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SetCollectionNameWidget(),
                    SetCollectionImageWidget(),
                    SetDescriptionWidget()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
