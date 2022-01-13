import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/add_audio_in_collection_page/add_audio_in_collection_page.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/view_model/view_model_audio_collection.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/widget/popup_item.dart';
import 'package:provider/provider.dart';

class PopupMenuCollectionAudioWidget extends StatelessWidget {
  final String coolectionName;
  const PopupMenuCollectionAudioWidget({
    Key? key,
    required this.coolectionName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _selected =
        context.select((ViewModelAudio vm) => vm.state.selected);
    final bool _editCollection = context
        .select((ViewModelCollectionAudio vm) => vm.state.editCollecrion);
    final _viewModel = context.read<ViewModelAudio>();

    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      iconSize: 40,
      onSelected: (value) async {
        if (value == 2) {
          if (_viewModel.state.audioMap.isEmpty) return;
          Navigator.pushNamed(context, AddAudioInCollectionPage.routeName,
              arguments: _viewModel.state.audioMap);
        } else if (value == 8) {
          await context
              .read<ViewModelCollectionAudio>()
              .updateCollection(coolectionName);
          Navigator.pop(context);
        }
      },
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      itemBuilder: !_selected
          ? (context) => [
                if (_editCollection)
                  popupMenuItem('Отменить ', () {
                    context
                        .read<ViewModelCollectionAudio>()
                        .editCollectionToogle();
                  }, 0),
                if (_editCollection) popupMenuItem('Сохранить', () {}, 8),
                if (!_editCollection)
                  popupMenuItem('Редактировать', () {
                    context
                        .read<ViewModelCollectionAudio>()
                        .editCollectionToogle();
                  }, 1),
                popupMenuItem('Выбрать несколько', () {
                  context.read<ViewModelAudio>().selected();
                }, 3),
                popupMenuItem('Удалить подбоку', () {
                  context
                      .read<ViewModelCollectionAudio>()
                      .deleteCollection(coolectionName);
                  Navigator.of(context).pop();
                }, 4),
              ]
          : (context) => [
                popupMenuItem('Отменить выбор', () {
                  context.read<ViewModelAudio>().selected();
                }, 1),
                popupMenuItem('Добавить в подборку', () {
                  context.read<ViewModelAudio>().selected();
                }, 2),
                popupMenuItem('Удалить из подборки', () {
                  context
                      .read<ViewModelAudio>()
                      .removeCollectionAudioList(coolectionName);
                  context.read<ViewModelAudio>().selected();
                }, 3),
              ],
    );
  }
}
