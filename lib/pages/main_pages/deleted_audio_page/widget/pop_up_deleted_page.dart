import 'package:flutter/material.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/widget/popup_item.dart';
import 'package:provider/provider.dart';

class PopupMenuDeletedPage extends StatelessWidget {
  const PopupMenuDeletedPage({Key? key}) : super(key: key);

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
