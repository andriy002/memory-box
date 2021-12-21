import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

import '../slider_audio_player.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String? audioUrl;
  final String? audioName;
  final int? maxLength;

  const AudioPlayerWidget({
    Key? key,
    required this.audioUrl,
    required this.audioName,
    required this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ViewModelAudioPlayer>().setAudioUrl(audioUrl ?? '', false);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 85),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8C84E2),
                Color(0xFF6C689F),
              ],
            ),
            border: Border.all(color: Colors.grey),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const PlayerPlayPasueButtonWidget(),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 60,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 30),
                        child: Text(
                          audioName!.length > 30
                              ? audioName!.substring(0, 30)
                              : audioName ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: AppFonts.mainFont,
                          ),
                        ),
                      ),
                      const SliderAudioPlayerWidget(),
                      const PositionAudioWidget(),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      context
                          .read<ViewModelAudioPlayer>()
                          .nextAudio(maxLength ?? 0);
                    },
                    icon: const ImageIcon(
                      AppIcons.arrowNext,
                      size: 40,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SliderAudioPlayerWidget extends StatelessWidget {
  const SliderAudioPlayerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final audioPosition = context.select(
      (ViewModelAudioPlayer vm) => vm.state.audioPosition,
    );
    final audioLength =
        context.select((ViewModelAudioPlayer vm) => vm.state.audioLength);
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: SliderAudioPlayer(
        position: audioPosition.inSeconds.toDouble(),
        audioLength: audioLength.inSeconds.toDouble(),
        positionFoo: (double val) {
          context.read<ViewModelAudioPlayer>().sekToSec(val.toInt());
        },
        color: Colors.white,
      ),
    );
  }
}

class PositionAudioWidget extends StatelessWidget {
  const PositionAudioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String audioLengthSecond = context.select(
      (ViewModelAudioPlayer vm) => vm.audioLengthSecond(),
    );
    final String audioLengthMinutes = context.select(
      (ViewModelAudioPlayer vm) => vm.audioLengthMinutes(),
    );
    final String audioPositionMinutes = context.select(
      (ViewModelAudioPlayer vm) => vm.audioPositionMinutes(),
    );
    final String audioPositionSeconds = context.select(
      (ViewModelAudioPlayer vm) => vm.audioPositionSecond(),
    );
    return Padding(
      padding: const EdgeInsets.fromLTRB(21, 35, 21, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$audioPositionMinutes: $audioPositionSeconds',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: AppFonts.mainFont,
              fontSize: 10,
            ),
          ),
          Text('$audioLengthMinutes:$audioLengthSecond',
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.mainFont,
                fontSize: 10,
              )),
        ],
      ),
    );
  }
}

class PlayerPlayPasueButtonWidget extends StatelessWidget {
  const PlayerPlayPasueButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool playPause =
        context.select((ViewModelAudioPlayer vm) => vm.state.pause);
    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        color: Colors.white,
        child: IconButton(
          icon: playPause
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: const Color(0xFF8C84E2),
          onPressed: playPause
              ? () {
                  context.read<ViewModelAudioPlayer>().resume();
                }
              : () {
                  context.read<ViewModelAudioPlayer>().pause();
                },
        ),
      ),
    );
  }
}
