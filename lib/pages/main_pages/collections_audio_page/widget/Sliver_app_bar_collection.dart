import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/view_model/view_model_audio_collection.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/widget/pop_up_menu_collection_audio.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

import 'description_widget.dart';
import 'display_name_widget.dart';
import 'image_widget.dart';

class AppBarCollectionAudio extends StatelessWidget {
  final String nameCollections;
  final String displayName;
  final String description;
  final int dataLength;
  final String img;
  const AppBarCollectionAudio({
    Key? key,
    required this.displayName,
    required this.description,
    required this.dataLength,
    required this.img,
    required this.nameCollections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _showMore =
        context.select((ViewModelCollectionAudio vm) => vm.state.detailsMore);
    return SliverAppBar(
      leading: leftArrowButton(() {
        Navigator.of(context).pop();
      }),
      actions: [
        PopupMenuCollectionAudioWidget(
          coolectionName: nameCollections,
        ),
        const SizedBox(
          width: 10,
        )
      ],
      backgroundColor: Colors.white,
      expandedHeight: _showMore
          ? MediaQuery.of(context).size.height / 1.5
          : MediaQuery.of(context).size.height / 2,
      floating: false,
      pinned: false,
      snap: false,
      centerTitle: true,
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
                children: [
                  DisplayNameWidget(displayName: displayName),
                  ImageWidget(
                    dataLength: dataLength,
                    img: img,
                  ),
                  DescriptionWidget(description: description)
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
