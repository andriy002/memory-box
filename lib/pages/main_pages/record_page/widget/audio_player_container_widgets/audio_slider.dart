import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/slider_audio_player.dart';
import 'package:provider/provider.dart';

class SliderAudioWidget extends StatelessWidget {
  const SliderAudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioLengthSecond = context.select(
      (ViewModelAudioPlayer vm) => vm.audioLengthSecond(),
    );
    final audioLengthMinutes = context.select(
      (ViewModelAudioPlayer vm) => vm.audioLengthMinutes(),
    );
    final audioPositionMinutes = context.select(
      (ViewModelAudioPlayer vm) => vm.audioPositionMinutes(),
    );
    final audioPositionSeconds = context.select(
      (ViewModelAudioPlayer vm) => vm.audioPositionSecond(),
    );

    final audioPosition = context.select(
      (ViewModelAudioPlayer vm) => vm.state.audioPosition,
    );
    final audioLength =
        context.select((ViewModelAudioPlayer vm) => vm.state.audioLength);
    return Column(
      children: [
        SliderAudioPlayer(
          position: audioPosition.inSeconds.toDouble(),
          audioLength: audioLength.inSeconds.toDouble(),
          positionFoo: (double val) {
            context.read<ViewModelAudioPlayer>().sekToSec(val.toInt());
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$audioPositionMinutes:$audioPositionSeconds',
                style: const TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 16,
                ),
              ),
              Text(
                '$audioLengthMinutes:$audioLengthSecond',
                style: const TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
