import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/add_audio_in_collection_page/add_audio_in_collection_page.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:provider/provider.dart';

import '../popup_item.dart';

class PopupMenuAudioWidget extends StatelessWidget {
  const PopupMenuAudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _selected =
        context.select((ViewModelAudio vm) => vm.state.selected);
    final _viewModel = context.read<ViewModelAudio>();

    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      iconSize: 40,
      onSelected: (value) {
        if (value == 2) {
          if (_viewModel.state.audioMap.isEmpty) return;
          Navigator.pushNamed(context, AddAudioInCollectionPage.routeName,
              arguments: _viewModel.state.audioMap);
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      itemBuilder: !_selected
          ? (context) => [
                popupMenuItem('Выбрать несколько', () {
                  context.read<ViewModelAudio>().selected();
                }, 0),
              ]
          : (context) => [
                popupMenuItem('Отменить выбор', () {
                  context.read<ViewModelAudio>().selected();
                }, 1),
                popupMenuItem('Добавить в подборку', () {
                  context.read<ViewModelAudio>().selected();
                }, 2),
                popupMenuItem('Удалить все', () {
                  context.read<ViewModelAudio>().removeAudioList();

                  context.read<ViewModelAudio>().selected();
                }, 3),
              ],
    );
  }
}
