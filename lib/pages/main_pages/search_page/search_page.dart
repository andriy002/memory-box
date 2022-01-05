import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/search_page/widget/sliver_app_bar.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio.dart';

import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _BodySearchPage.create(),
    );
  }
}

class _BodySearchPage extends StatelessWidget {
  const _BodySearchPage({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAudio()),
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
      ],
      child: const _BodySearchPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String _searchKey =
        context.select((ViewModelAudio vm) => vm.state.searchKey);
    final bool _isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    final int _indexAudio = context.select(
      (ViewModelAudioPlayer vm) => vm.state.indexAudio ?? 0,
    );

    return StreamBuilder<Object>(
      stream: AudioRepositories.instance.searchAudio(_searchKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<AudioBuilder> _data = snapshot.data as List<AudioBuilder>;
          final bool _selected =
              context.select((ViewModelAudio vm) => vm.state.selected);

          return Scaffold(
            body: SizedBox(
              height: MediaQuery.of(context).size.height - 80,
              child: Stack(
                children: [
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      const SliverAppBarSearchPage(),
                      SliverAudioList(
                        stastusButton: _selected
                            ? ButtonStatus.selected
                            : ButtonStatus.edit,
                        data: _data,
                        childCount: _data.length,
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 80,
                        ),
                      ),
                    ],
                  ),
                  if (_isPlaying)
                    AudioPlayerWidget(
                      audioUrl: _data[_indexAudio].audioUrl,
                      maxLength: _data.length,
                      audioName: _data[_indexAudio].audioName,
                    )
                ],
              ),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
