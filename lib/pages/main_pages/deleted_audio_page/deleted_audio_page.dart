import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/pages/main_pages/deleted_audio_page/widget/sliver_app_bar_deleted_page.dart';
import 'package:memory_box/repositories/deleted_audio_repositories.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio/list_audio.dart';
import 'package:provider/provider.dart';

class DeletedAudioPage extends StatelessWidget {
  static const String routeName = '/deleted_audio';
  const DeletedAudioPage({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ViewModelAudioPlayer()),
        ChangeNotifierProvider(create: (_) => ViewModelAudio()),
        StreamProvider(
            create: (_) => DeletedAudioRepositories.instance.audio,
            initialData: null)
      ],
      child: const DeletedAudioPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AudioBuilder>? _data = context.watch<List<AudioBuilder>?>();
    final bool _isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    final int _indexAudio =
        context.select((ViewModelAudioPlayer vm) => vm.state.indexAudio ?? 0);
    final bool _selected =
        context.select((ViewModelAudio vm) => vm.state.selected);

    if (_data == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const SliverAppBarDeletedPage(),
              SliverAudioList(
                stastusButton:
                    _selected ? ButtonStatus.selected : ButtonStatus.deleted,
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
        if (_data.isEmpty)
          const Center(
            child: Text(
              'У вас нет удаленных \n аудиозаписей',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontFamily: AppFonts.mainFont,
                  fontSize: 24),
            ),
          )
      ],
    );
  }
}
