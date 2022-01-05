import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/view_model/view_model_collections.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
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

class CollectionsAudioContainer extends StatelessWidget {
  const CollectionsAudioContainer({
    Key? key,
  }) : super(key: key);

  static Widget create(String nameCollections) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAudio()),
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
        StreamProvider(
            create: (_) => CollectionsRepositories.instance.audioFromCollection(
                  nameCollections,
                ),
            initialData: null),
      ],
      child: const CollectionsAudioContainer(),
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
    final displayName = context.select(
      (ViewModelCoolections vm) => vm.state.dispalyNameCollections,
    );

    final img = context.select(
      (ViewModelCoolections vm) => vm.state.imgCollections,
    );
    final description = context.select(
      (ViewModelCoolections vm) => vm.state.descriptionCollections,
    );
    final length = context.select(
      (ViewModelCoolections vm) => vm.state.lengthCollections,
    );
    return Scaffold(
        body: SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                leading: leftArrowButton(() {
                  context.read<ViewModelCoolections>().setCurrentIndex = 0;
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
                expandedHeight: MediaQuery.of(context).size.height / 2,
                floating: false,
                pinned: false,
                snap: false,
                centerTitle: true,
                flexibleSpace: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAppBar(
                      heightCircle: MediaQuery.of(context).size.height / 5,
                      colorCircle: AppColors.collectionsColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: FractionallySizedBox(
                        widthFactor: 0.9,
                        heightFactor: 0.5,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                                image: NetworkImage(img!), fit: BoxFit.cover),
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
                                    '${data.length} аудио',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                                Text(
                                  '$length',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
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
                          displayName ?? '',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: AppFonts.mainFont),
                        ),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            height: 90,
                            child: Text(description ?? ''),
                          ),
                        ))
                  ],
                ),
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
      ),
    ));
  }
}
