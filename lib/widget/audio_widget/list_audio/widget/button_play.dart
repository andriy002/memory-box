import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

class ButtonPlay extends StatelessWidget {
  final int index;
  final Color? colorButton;
  const ButtonPlay({
    Key? key,
    required this.index,
    this.colorButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool? _isPlaying;

    final _indexAudio =
        context.select((ViewModelAudioPlayer vm) => vm.state.indexAudio);

    _indexAudio == index ? _isPlaying = true : _isPlaying = false;

    final _iconCheker =
        !_isPlaying ? const Icon(Icons.play_arrow) : const Icon(Icons.stop);
    final _onPressedChecker = !_isPlaying
        ? () => context.read<ViewModelAudioPlayer>().setPlayingIndex(index)
        : () => context.read<ViewModelAudioPlayer>().stop();
    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        color: colorButton ?? AppColors.allAudioColor,
        child: IconButton(
            icon: _iconCheker,
            iconSize: 30,
            color: Colors.white,
            onPressed: _onPressedChecker),
      ),
    );
  }
}
