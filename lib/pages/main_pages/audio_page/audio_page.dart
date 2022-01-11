import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/audio_page/widget/sliver_audio_app_bar.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio.dart';

import 'package:provider/provider.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({Key? key}) : super(key: key);

  static const routeName = '/audio_page';

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
        ChangeNotifierProvider(create: (_) => ViewModelAudio()),
      ],
      child: const AudioPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AudioBuilder>? data = context.watch<List<AudioBuilder>?>();
    final bool _isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    final int _indexAudio =
        context.select((ViewModelAudioPlayer vm) => vm.state.indexAudio ?? 0);
    final bool _selected =
        context.select((ViewModelAudio vm) => vm.state.selected);

    if (data == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAudioAppBar(data: data.length),
            SliverAudioList(
              stastusButton:
                  _selected ? ButtonStatus.selected : ButtonStatus.edit,
              data: data,
              childCount: data.length,
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
          ),
      ],
    );
  }
}
