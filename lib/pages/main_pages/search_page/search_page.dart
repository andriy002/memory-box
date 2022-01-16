import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/search_page/widget/sliver_app_bar.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio/list_audio.dart';

import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);
  static const routeName = '/search_page';

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProxyProvider(
            create: (_) => ViewModelAudio(),
            update: (_, ___, __) => ViewModelAudio()),
        ChangeNotifierProxyProvider(
            create: (_) => ViewModelAudioPlayer(),
            update: (_, ___, __) => ViewModelAudioPlayer()),
      ],
      child: const SearchPage(),
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
    final bool _selected =
        context.select((ViewModelAudio vm) => vm.state.selected);

    return StreamBuilder<Object>(
      stream: AudioRepositories.instance.searchAudio(_searchKey),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<AudioBuilder> _data = snapshot.data as List<AudioBuilder>;

          return SizedBox(
            height: MediaQuery.of(context).size.height - 80,
            child: Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: CustomScrollView(
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
                          height: 160,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isPlaying)
                  AudioPlayerWidget(
                    audioUrl: _data[_indexAudio].audioUrl,
                    maxLength: _data.length,
                    audioName: _data[_indexAudio].audioName,
                  ),
              ],
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
