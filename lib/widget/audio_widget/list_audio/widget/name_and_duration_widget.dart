import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:provider/provider.dart';

class NameAndDurationWidget extends StatelessWidget {
  final String audioName;
  final String audioDuration;
  final int index;
  final String uidAudio;
  const NameAndDurationWidget({
    Key? key,
    required this.audioName,
    required this.audioDuration,
    required this.index,
    required this.uidAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? _textEditingController = TextEditingController();

    final bool? _renameAudio;

    final checkerRenameAudio =
        context.select((ViewModelAudio vm) => vm.state.indexRename);

    checkerRenameAudio == index ? _renameAudio = true : _renameAudio = false;

    final String _substringAudio =
        audioName.length > 31 ? audioName.substring(0, 31) : audioName;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          height: 20,
          child: !_renameAudio
              ? Text(
                  _substringAudio,
                  style: const TextStyle(
                    fontFamily: AppFonts.mainFont,
                  ),
                )
              : TextField(
                  controller: _textEditingController,
                  onEditingComplete: () {
                    context
                        .read<ViewModelAudio>()
                        .renameAudio(uidAudio, _textEditingController.text);
                  },
                  style: const TextStyle(
                    fontFamily: AppFonts.mainFont,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: _substringAudio,
                    isCollapsed: true,
                  ),
                ),
        ),
        Text(
          audioDuration.substring(0, 7),
          style: const TextStyle(
            fontFamily: AppFonts.mainFont,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
