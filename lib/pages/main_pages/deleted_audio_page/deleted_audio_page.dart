import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/repositories/deleted_audio_repositories.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/audio_widget/list_audio.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/no_audio_widget.dart';
import 'package:memory_box/widget/popup_item.dart';
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
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              actions: const [
                PopupMenuAudioWidget(),
                SizedBox(
                  width: 10,
                )
              ],
              backgroundColor: Colors.white,
              expandedHeight: MediaQuery.of(context).size.height / 4,
              floating: false,
              pinned: false,
              snap: false,
              toolbarHeight: 85,
              title: Column(
                children: const [
                  Text(
                    'Недавно \n удаленные',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.mainFont,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAppBar(
                      heightCircle: MediaQuery.of(context).size.height / 10,
                      colorCircle: AppColors.allAudioColor,
                    ),
                  ],
                ),
              ),
            ),
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

class PopupMenuAudioWidget extends StatelessWidget {
  const PopupMenuAudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool selected =
        context.select((ViewModelAudio vm) => vm.state.selected);

    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      iconSize: 40,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      itemBuilder: !selected
          ? (context) => [
                popupMenuItem('Выбрать несколько', () {
                  context.read<ViewModelAudio>().selected();
                }, 0),
              ]
          : (context) => [
                popupMenuItem('Отменить выбор', () {
                  context.read<ViewModelAudio>().selected();
                }, 1),
                popupMenuItem('Востановить все', () {
                  context.read<ViewModelAudio>().selected();
                  context.read<ViewModelAudio>().restoreAudioList();
                }, 2),
                popupMenuItem('Удалить все', () {
                  context.read<ViewModelAudio>().selected();
                  context.read<ViewModelAudio>().deletedAudioInStorageList();
                }, 3),
              ],
    );
  }
}
