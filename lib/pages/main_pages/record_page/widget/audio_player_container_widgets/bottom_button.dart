import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/audio_player.dart';
import 'package:provider/provider.dart';

class BottomButtonWidget extends StatelessWidget {
  const BottomButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const localAudio =
        '/storage/15FD-100D/Android/data/com.andrewdezh.memory_box/cache/Аудизапись.aac';
    final isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            context.read<ViewModelAudioPlayer>().secDown();
          },
          icon: const ImageIcon(
            AppIcons.secDown,
            size: 40,
          ),
        ),
        const SizedBox(
          width: 40,
        ),
        ClipOval(
            child: Container(
          width: 80,
          height: 80,
          color: AppColors.recordColor,
          child: IconButton(
              icon: !isPlaying
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.pause),
              color: Colors.white,
              iconSize: 40,
              onPressed: !isPlaying
                  ? () {
                      context.read<ViewModelAudioPlayer>().play(localAudio);
                    }
                  : () {
                      context.read<ViewModelAudioPlayer>().stop();
                    }),
        )),
        const SizedBox(
          width: 40,
        ),
        IconButton(
          onPressed: () {
            context.read<ViewModelAudioPlayer>().secUp();
          },
          icon: const ImageIcon(
            AppIcons.secUp,
            size: 40,
          ),
        ),
      ],
    );
  }
}
