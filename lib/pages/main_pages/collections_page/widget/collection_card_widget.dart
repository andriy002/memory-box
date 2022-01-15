import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/audio_collections_page.dart';
import 'package:memory_box/pages/main_pages/collections_page/view_model/view_model_collections.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:provider/provider.dart';

class CollectionsCardWidget extends StatefulWidget {
  final String? img;
  final String? name;
  final String? displayName;
  final String? description;

  const CollectionsCardWidget(
      {Key? key,
      required this.img,
      required this.name,
      required this.displayName,
      required this.description})
      : super(key: key);

  @override
  State<CollectionsCardWidget> createState() => _CollectionsCardWidgetState();
}

class _CollectionsCardWidgetState extends State<CollectionsCardWidget> {
  @override
  Widget build(BuildContext context) {
    final bool _selected =
        context.select((ViewModelCoolections vm) => vm.state.selected);
    bool isCheck = false;
    final chekUid =
        context.select((ViewModelCoolections vm) => vm.state.collectionMap);
    if (chekUid[widget.name] == true) {
      isCheck = true;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: GestureDetector(
        onTap: _selected
            ? () {
                if (isCheck) {
                  context
                      .read<ViewModelCoolections>()
                      .removeCollectionInMap(widget.name ?? '');
                } else {
                  isCheck = false;
                  context
                      .read<ViewModelCoolections>()
                      .addCollectionToMap(widget.name ?? '');
                }
                setState(() {});
              }
            : () {
                Navigator.pushNamed(
                  context,
                  CollectionsAudioPage.routeName,
                  arguments: {
                    'img': widget.img,
                    'displayName': widget.displayName,
                    'nameCollections': widget.name,
                    'description': widget.description
                  },
                );
              },
        child: _selectedCollection(_selected, isCheck),
      ),
    );
  }

  Stack _selectedCollection(bool _selected, bool isCheck) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
                image: NetworkImage(widget.img!),
                fit: BoxFit.cover,
                colorFilter: _selected
                    ? !isCheck
                        ? const ColorFilter.mode(
                            Color(0x73000000), BlendMode.multiply)
                        : null
                    : null),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: SizedBox(
                width: 100,
                child: Text(
                  widget.displayName ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
        if (_selected)
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
        if (isCheck)
          const ImageIcon(
            AppIcons.done,
            color: Colors.white,
          ),
      ],
    );
  }
}
