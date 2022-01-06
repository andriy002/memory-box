import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:memory_box/models/collections.model.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_collections.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

class AddAudioInCollectionPage extends StatelessWidget {
  static const routeName = '/add_audio_in_collection_page';
  const AddAudioInCollectionPage({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelCoolections()),
        StreamProvider(
          create: (_) => CollectionsRepositories.instance.colllections,
          initialData: null,
        ),
      ],
      child: const AddAudioInCollectionPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final List<CollectionsBuilder>? dataCollections =
        context.watch<List<CollectionsBuilder>?>();

    if (dataCollections == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height - 80,
        child: Stack(
          children: [
            const CircleAppBar(
              heightCircle: 0,
              colorCircle: AppColors.collectionsColor,
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
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
                            .read<ViewModelCoolections>()
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
                ),
                SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return SliverCollectionsWidget(
                        displayName: dataCollections[index].displayName,
                        img: dataCollections[index].image,
                        name: dataCollections[index].name,
                      );
                    },
                    childCount: dataCollections.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 10,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SliverCollectionsWidget extends StatefulWidget {
  final String? img;
  final String? displayName;
  final String? name;
  const SliverCollectionsWidget({
    Key? key,
    required this.img,
    required this.displayName,
    required this.name,
  }) : super(key: key);

  @override
  State<SliverCollectionsWidget> createState() =>
      _SliverCollectionsWidgetState();
}

class _SliverCollectionsWidgetState extends State<SliverCollectionsWidget> {
  @override
  Widget build(BuildContext context) {
    bool isCheck = false;
    final chekUid =
        context.select((ViewModelCoolections vm) => vm.state.collectionMap);
    if (chekUid[widget.name] == true) {
      isCheck = true;
    }
    return GestureDetector(
      onTap: () {
        if (isCheck) {
          context
              .read<ViewModelCoolections>()
              .removeCollectionInMap(widget.name ?? '');
        } else {
          isCheck = false;
          context
              .read<ViewModelCoolections>()
              .addCollectionToMap(widget.name ?? '');
        }
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(widget.img!),
                  fit: BoxFit.cover,
                  colorFilter: !isCheck
                      ? const ColorFilter.mode(
                          Color(0x73000000), BlendMode.multiply)
                      : null,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: SizedBox(
                    width: 100,
                    child: Text(
                      widget.displayName ?? '',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(60),
              ),
            ),
            if (isCheck)
              const ImageIcon(
                AppIcons.done,
                color: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}
