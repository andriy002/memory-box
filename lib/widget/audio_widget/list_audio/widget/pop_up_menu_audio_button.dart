import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/add_audio_in_collection_page/add_audio_in_collection_page.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

import '../../../popup_item.dart';

class PopupMenuAudioButton extends StatelessWidget {
  final String audioName;
  final String audioUrl;
  final String audioUid;
  final int index;

  const PopupMenuAudioButton({
    Key? key,
    required this.audioName,
    required this.audioUrl,
    required this.audioUid,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _viewModel = context.read<ViewModelAudio>();

    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      onSelected: (value) async {
        if (value == 1) {
          _viewModel.addAudioToMap(audioUid);
          await Navigator.pushNamed(context, AddAudioInCollectionPage.routeName,
              arguments: _viewModel.state.audioMap);
          _viewModel.removeAudioInMap(audioUid);
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      itemBuilder: (context) => [
        popupMenuItem('Переименовать', () {
          _viewModel.setIndexReanme(index);
        }, 0),
        popupMenuItem('Добавить в подборку', () {}, 1),
        popupMenuItem('Удалить', () {
          context.read<ViewModelAudioPlayer>().stop();
          _viewModel.sendAudioToDeleteColection(audioUid);
        }, 2),
        popupMenuItem('Поделиться', () {
          _viewModel.shareUrlFile(audioUrl, audioName);
        }, 3),
      ],
    );
  }
}
