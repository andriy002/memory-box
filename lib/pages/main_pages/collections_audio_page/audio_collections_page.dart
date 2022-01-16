import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/view_model/view_model_audio_collection.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio/list_audio.dart';
import 'package:provider/provider.dart';
import 'widget/sliver_app_bar_collection.dart';

class CollectionsAudioPage extends StatelessWidget {
  final String img;
  final String displayName;
  final String description;
  final String nameCollections;

  const CollectionsAudioPage({
    Key? key,
    required this.img,
    required this.nameCollections,
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
        ChangeNotifierProvider(create: (_) => ViewModelCollectionAudio()),
        ChangeNotifierProxyProvider(
            create: (_) => ViewModelAudio(),
            update: (_, ___, __) => ViewModelAudio()),
        ChangeNotifierProxyProvider(
            create: (_) => ViewModelAudioPlayer(),
            update: (_, ___, __) => ViewModelAudioPlayer()),
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
        nameCollections: nameCollections,
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
    final bool _selected =
        context.select((ViewModelAudio vm) => vm.state.selected);

    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              AppBarCollectionAudio(
                dataLength: data.length,
                img: img,
                description: description,
                displayName: displayName,
                nameCollections: nameCollections,
              ),
              SliverAudioList(
                stastusButton:
                    _selected ? ButtonStatus.selected : ButtonStatus.edit,
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
        ),
        if (_isPlaying)
          AudioPlayerWidget(
            audioUrl: data[_indexAudio].audioUrl,
            maxLength: data.length,
            audioName: data[_indexAudio].audioName,
          )
      ],
    );
  }
}
