import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/view_model/view_model_audio_collection.dart';

import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:provider/provider.dart';

class CollectionsAudioPage extends StatelessWidget {
  final String img;
  final String displayName;
  final String description;

  const CollectionsAudioPage({
    Key? key,
    required this.img,
    required this.displayName,
    required this.description,
  }) : super(key: key);

  static const String routeName = '/audio_in_collection';

  static Widget create({
    required String nameCollections,
    required String img,
    required String displayName,
    required String description,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAudio()),
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
        ChangeNotifierProvider(create: (_) => ViewModelCollectionAudio()),
        StreamProvider(
            create: (_) => CollectionsRepositories.instance.audioFromCollection(
                  nameCollections,
                ),
            initialData: null),
      ],
      child: CollectionsAudioPage(
        img: img,
        description: description,
        displayName: displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    final List<AudioBuilder> data = context.watch<List<AudioBuilder>?>() ?? [];
    final int _indexAudio = context.select(
      (ViewModelAudioPlayer vm) => vm.state.indexAudio ?? 0,
    );

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                AppBarCollectionAudio(
                  dataLength: data.length,
                  img: img,
                  description: description,
                  displayName: displayName,
                ),
                SliverAudioList(
                  stastusButton: ButtonStatus.edit,
                  data: data,
                  childCount: data.length,
                  colorButton: AppColors.collectionsColor,
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 160,
                  ),
                ),
              ],
            ),
            if (_isPlaying)
              AudioPlayerWidget(
                audioUrl: data[_indexAudio].audioUrl,
                maxLength: data.length,
                audioName: data[_indexAudio].audioName,
              )
          ],
        ));
  }
}

class AppBarCollectionAudio extends StatelessWidget {
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _toogleButtonRepeat =
        context.select((ViewModelAudioPlayer vm) => vm.state.repeatAudio);

    final bool _showMore =
        context.select((ViewModelCollectionAudio vm) => vm.state.detailsMore);
    return SliverAppBar(
      leading: leftArrowButton(() {
        Navigator.of(context).pop();
      }),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_horiz,
            size: 40,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        const SizedBox(
          width: 10,
        )
      ],
      backgroundColor: Colors.white,
      expandedHeight: _showMore
          ? MediaQuery.of(context).size.height / 1.6
          : MediaQuery.of(context).size.height / 2,
      floating: false,
      pinned: false,
      snap: false,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            CircleAppBar(
              heightCircle: MediaQuery.of(context).size.height / 6,
              colorCircle: AppColors.collectionsColor,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: FractionallySizedBox(
                    widthFactor: 0.9,
                    heightFactor: 0.6,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: NetworkImage(img), fit: BoxFit.cover),
                        color: Colors.amber,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(
                                '$dataLength аудио',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Container(
                              width: 168.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                  color: const Color(0x33F6F6F6),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  ClipOval(
                                    child: Container(
                                      color: Colors.white,
                                      child: IconButton(
                                        icon: Icon(
                                          _toogleButtonRepeat
                                              ? Icons.stop
                                              : Icons.play_arrow,
                                          color: const Color(0x80000000),
                                        ),
                                        onPressed: () {
                                          context
                                              .read<ViewModelAudioPlayer>()
                                              .toogleRepeatAudio(dataLength);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    _toogleButtonRepeat
                                        ? 'Остановить'
                                        : 'Запустить все',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: AppFonts.mainFont,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 90, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  displayName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontFamily: AppFonts.mainFont),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: SizedBox(
                  width: double.infinity,
                  height: _showMore ? 140 : 100,
                  child: Column(
                    children: [
                      _showMore
                          ? Text(description,
                              style: const TextStyle(
                                fontFamily: AppFonts.mainFont,
                              ))
                          : description.length >
                                  MediaQuery.of(context).size.width / 2
                              ? Text(
                                  description.substring(0,
                                      MediaQuery.of(context).size.width ~/ 4.5),
                                  style: const TextStyle(
                                    fontFamily: AppFonts.mainFont,
                                  ),
                                )
                              : Text(
                                  description,
                                  style: const TextStyle(
                                    fontFamily: AppFonts.mainFont,
                                  ),
                                ),
                      if (description.length >
                          MediaQuery.of(context).size.width / 2)
                        TextButton(
                          onPressed: () {
                            context.read<ViewModelCollectionAudio>().showMore();
                          },
                          child: Text(
                            _showMore ? 'Свернуть' : 'Подробнее',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontFamily: AppFonts.mainFont,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


// Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Container(
//                     width: double.infinity,
//                     height: MediaQuery.of(context).size.height / 4,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       image: DecorationImage(
//                           image: NetworkImage(img), fit: BoxFit.cover),
//                       color: Colors.amber,
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 10),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.end,
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           SizedBox(
//                             width: 100,
//                             child: Text(
//                               '$dataLength аудио',
//                               style: const TextStyle(color: Colors.white),
//                             ),
//                           ),
//                           Container(
//                             width: 168.0,
//                             height: 50.0,
//                             decoration: BoxDecoration(
//                                 color: const Color(0x33F6F6F6),
//                                 borderRadius: BorderRadius.circular(30)),
//                             child: Row(
//                               children: [
//                                 const SizedBox(
//                                   width: 2,
//                                 ),
//                                 ClipOval(
//                                   child: Container(
//                                     color: Colors.white,
//                                     child: IconButton(
//                                       icon: Icon(
//                                         _toogleButtonRepeat
//                                             ? Icons.stop
//                                             : Icons.play_arrow,
//                                         color: const Color(0x80000000),
//                                       ),
//                                       onPressed: () {
//                                         context
//                                             .read<ViewModelAudioPlayer>()
//                                             .toogleRepeatAudio(dataLength);
//                                       },
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(width: 5.0),
//                                 Text(
//                                   _toogleButtonRepeat
//                                       ? 'Остановить'
//                                       : 'Запустить все',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontFamily: AppFonts.mainFont,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       horizontal: 16.0, vertical: 10),
//                   child: Align(
//                     alignment: Alignment.bottomLeft,
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: _showMore ? 160 : 90,
//                       child: Column(
//                         children: [
//                           _showMore
//                               ? Text(description,
//                                   style: const TextStyle(
//                                     fontFamily: AppFonts.mainFont,
//                                   ))
//                               : description.length >
//                                       MediaQuery.of(context).size.width / 2
//                                   ? Text(
//                                       description.substring(
//                                           0,
//                                           MediaQuery.of(context).size.width ~/
//                                               4.5),
//                                       style: const TextStyle(
//                                         fontFamily: AppFonts.mainFont,
//                                       ),
//                                     )
//                                   : Text(
//                                       description,
//                                       style: const TextStyle(
//                                         fontFamily: AppFonts.mainFont,
//                                       ),
//                                     ),
//                           if (description.length >
//                               MediaQuery.of(context).size.width / 2)
//                             TextButton(
//                               onPressed: () {
//                                 context
//                                     .read<ViewModelCollectionAudio>()
//                                     .showMore();
//                               },
//                               child: Text(
//                                 _showMore ? 'Свернуть' : 'Подробнее',
//                                 style: const TextStyle(
//                                   color: Colors.grey,
//                                   fontFamily: AppFonts.mainFont,
//                                 ),
//                               ),
//                             )
//                         ],
//                       ),
//                     ),
//                   ),
//                 )