import 'package:flutter/material.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:provider/provider.dart';

import '../popup_item.dart';

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
                }),
              ]
          : (context) => [
                popupMenuItem('Отменить выбор', () {
                  context.read<ViewModelAudio>().selected();
                }),
                popupMenuItem('Добавить в подборку', () {
                  context.read<ViewModelAudio>().selected();
                }),
                popupMenuItem('Удалить все', () {
                  context.read<ViewModelAudio>().removeAudioList();

                  context.read<ViewModelAudio>().selected();
                }),
              ],
    );
  }
}
