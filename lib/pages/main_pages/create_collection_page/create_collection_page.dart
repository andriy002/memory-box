import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/create_collection_page/widget/app_bar_collection.dart';
import 'package:memory_box/view_model/view_model_collections.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio.dart';
import 'package:provider/provider.dart';
import 'search_page.dart';
import 'widget/open_search_audio.dart';

class CreateNewCollection extends StatelessWidget {
  const CreateNewCollection({Key? key}) : super(key: key);
  static const String routeName = '/create_collection';

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAudio()),
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
        ChangeNotifierProvider(create: (_) => ViewModelCoolections()),
        StreamProvider(
            create: (_) => CollectionsRepositories.instance.audioFromCollection(
                  'selected',
                ),
            initialData: null),
      ],
      child: const CreateNewCollection(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool _isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    final List<AudioBuilder> _data = context.watch<List<AudioBuilder>?>() ?? [];
    final int _indexAudio = context.select(
      (ViewModelAudioPlayer vm) => vm.state.indexAudio ?? 0,
    );
    final bool openSearchAudio =
        context.select((ViewModelCoolections vm) => vm.state.openSearchAudio);
    return openSearchAudio
        ? const SearchPageCollections()
        : Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const AppBarCollectionCreate(),
                  const OpenAudioSearchWidget(),
                  SliverAudioList(
                    stastusButton: ButtonStatus.edit,
                    data: _data,
                    childCount: _data.length,
                    colorButton: AppColors.collectionsColor,
                  )
                ],
              ),
              if (_isPlaying)
                AudioPlayerWidget(
                  audioUrl: _data[_indexAudio].audioUrl,
                  maxLength: _data.length,
                  audioName: _data[_indexAudio].audioName,
                )
            ],
          );
  }
}
