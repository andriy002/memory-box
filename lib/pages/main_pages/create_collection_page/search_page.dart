import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/view_model/view_model_collections.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/left_arrow_button.dart';
import 'package:memory_box/widget/no_audio_widget.dart';
import 'package:memory_box/widget/search_wigdet.dart';

import 'package:provider/provider.dart';

class SearchPageCollections extends StatelessWidget {
  const SearchPageCollections({Key? key}) : super(key: key);

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

          return Scaffold(
            body: Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    const SliverAppBarSearchPage(),
                    SliverAudioList(
                      stastusButton: ButtonStatus.selected,
                      data: _data,
                      childCount: _data.length,
                      colorButton: AppColors.collectionsColor,
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
                  ),
                if (_data.isEmpty) const NoAudioWidget()
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

class SliverAppBarSearchPage extends StatelessWidget {
  const SliverAppBarSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchKeyChanged = context.read<ViewModelAudio>().searchKeyInput;

    return SliverAppBar(
      leading: leftArrowButton(() {
        context.read<ViewModelCoolections>().openAddAudioPage();
      }),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: TextButton(
              onPressed: () {
                context.read<ViewModelAudio>().addAudioToCollection('selected');
                context.read<ViewModelCoolections>().openAddAudioPage();
              },
              child: const Text(
                'Добавить',
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: AppFonts.mainFont,
                    fontSize: 16),
              )),
        ),
      ],
      backgroundColor: Colors.white,
      expandedHeight: MediaQuery.of(context).size.height / 3,
      floating: false,
      pinned: false,
      snap: false,
      title: Column(
        children: const [
          Text(
            'Выбрать',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            CircleAppBar(
              heightCircle: MediaQuery.of(context).size.height / 6,
              colorCircle: AppColors.collectionsColor,
            ),
            SearchWidget(
              onChanged: _searchKeyChanged,
            )
          ],
        ),
      ),
    );
  }
}
