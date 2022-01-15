import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:provider/provider.dart';

class DeletedButton extends StatelessWidget {
  final String doc;

  const DeletedButton({
    Key? key,
    required this.doc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: IconButton(
        onPressed: () {
          context.read<ViewModelAudio>().deletedAudioInStorage(doc);
        },
        icon: const ImageIcon(
          AppIcons.delete,
          size: 30,
        ),
      ),
    );
  }
}
