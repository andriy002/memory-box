import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_page/view_model/view_model_collections.dart';
import 'package:memory_box/widget/popup_item.dart';
import 'package:provider/provider.dart';

class PopupMenuCollectionPage extends StatelessWidget {
  const PopupMenuCollectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool selected =
        context.select((ViewModelCoolections vm) => vm.state.selected);
    final _viewModel = context.read<ViewModelCoolections>();

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
                  _viewModel.selected();
                }, 0),
              ]
          : (context) => [
                popupMenuItem('Отменить выбор', () {
                  _viewModel.selected();
                }, 1),
                popupMenuItem('Удалить все', () {
                  context.read<ViewModelCoolections>().deletedCollection();
                  _viewModel.selected();
                }, 2),
              ],
    );
  }
}
