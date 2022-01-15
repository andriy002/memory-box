import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:provider/provider.dart';

class AddAudioToListButton extends StatefulWidget {
  final String? audioUid;
  const AddAudioToListButton({
    Key? key,
    required this.audioUid,
  }) : super(key: key);

  @override
  State<AddAudioToListButton> createState() => _AddAudioToListButtonState();
}

class _AddAudioToListButtonState extends State<AddAudioToListButton> {
  @override
  Widget build(BuildContext context) {
    bool _isCheck = false;
    final _chekUid = context.select((ViewModelAudio vm) => vm.state.audioMap);

    if (_chekUid[widget.audioUid] == true) {
      _isCheck = true;
    }

    return GestureDetector(
      onTap: () {
        if (_isCheck) {
          context
              .read<ViewModelAudio>()
              .removeAudioInMap(widget.audioUid ?? '');
        } else {
          _isCheck = false;
          context.read<ViewModelAudio>().addAudioToMap(widget.audioUid ?? '');
        }
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          if (_isCheck) const ImageIcon(AppIcons.done)
        ],
      ),
    );
  }
}
