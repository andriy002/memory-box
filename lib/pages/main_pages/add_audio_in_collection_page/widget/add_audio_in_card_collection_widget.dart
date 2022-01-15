import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/add_audio_in_collection_page/view_model/view_model_add_audio_in_collection.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:provider/provider.dart';

class AddInCollectionsCardWidget extends StatefulWidget {
  final String? img;
  final String? displayName;
  final String? name;
  const AddInCollectionsCardWidget({
    Key? key,
    required this.img,
    required this.displayName,
    required this.name,
  }) : super(key: key);

  @override
  State<AddInCollectionsCardWidget> createState() =>
      _AddInCollectionsCardWidgetState();
}

class _AddInCollectionsCardWidgetState
    extends State<AddInCollectionsCardWidget> {
  @override
  Widget build(BuildContext context) {
    bool isCheck = false;
    final chekUid = context
        .select((ViewModelAddAudioInColection vm) => vm.state.collectionMap);
    if (chekUid[widget.name] == true) {
      isCheck = true;
    }
    return GestureDetector(
      onTap: () {
        if (isCheck) {
          context
              .read<ViewModelAddAudioInColection>()
              .removeCollectionInMap(widget.name ?? '');
        } else {
          isCheck = false;
          context
              .read<ViewModelAddAudioInColection>()
              .addCollectionToMap(widget.name ?? '');
        }
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(widget.img!),
                  fit: BoxFit.cover,
                  colorFilter: !isCheck
                      ? const ColorFilter.mode(
                          Color(0x73000000), BlendMode.multiply)
                      : null,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              )
          ],
        ),
      ),
    );
  }
}
