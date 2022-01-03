import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/collections_page/view_model_collections/view_model_collections.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/sliver_adapter.dart';
import 'package:memory_box/pages/main_pages/main_page/widget/sliver_app_bar.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelCoolections()),
        ChangeNotifierProvider(create: (_) => ViewModelAudio()),
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
        StreamProvider(
          create: (_) => CollectionsRepositories.instance.colllections,
          initialData: null,
        ),
      ],
      child: const MainPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AudioBuilder> data = context.watch<List<AudioBuilder>?>() ?? [];
    final bool _isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    final int _indexAudio =
        context.select((ViewModelAudioPlayer vm) => vm.state.indexAudio ?? 0);
    return SizedBox(
      height: MediaQuery.of(context).size.height - 80,
      child: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverAppBarWidget(),
              const SliverAdapterWidget(),
              SliverAudioList(
                stastusButton: ButtonStatus.edit,
                data: data,
                childCount: data.length > 10 ? 10 : data.length,
                colorButton: AppColors.mainColor,
              ),
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
          if (_isPlaying)
            AudioPlayerWidget(
              audioUrl: data[_indexAudio].audioUrl,
              maxLength: data.length > 10 ? 10 : data.length,
              audioName: data[_indexAudio].audioName,
            )
        ],
      ),
    );
  }
}
