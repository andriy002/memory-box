import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

import 'widget/voice_animation.dart';

class RecordContainerWidget extends StatelessWidget {
  const RecordContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seconds = context.select((ViewModelRecord vm) => vm.second());
    final minutes = context.select((ViewModelRecord vm) => vm.minutes());
    final hour = context.select((ViewModelRecord vm) => vm.hour());
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _cancelButton(context),
        const Center(
          child: Text(
            'Запись',
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 24,
            ),
          ),
        ),
        const VoiceAnimationWidget(),
        _timer(hour, minutes, seconds),
        _stopButton(context),
        const SizedBox(
          height: 80,
          width: double.infinity,
        ),
      ],
    );
  }

  SizedBox _cancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, top: 15),
        child: Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              context.read<Navigation>().setCurrentIndex = 0;
            },
            child: const Text(
              'Отменить',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: AppFonts.mainFont,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  Row _timer(String hour, String minutes, String seconds) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipOval(
          child: Container(
            width: 10,
            height: 10,
            color: Colors.red,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          '$hour:$minutes:$seconds',
          style: const TextStyle(
            fontFamily: AppFonts.mainFont,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  ClipOval _stopButton(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 80,
        height: 80,
        color: AppColors.recordColor,
        child: IconButton(
          icon: const Icon(Icons.pause),
          color: Colors.white,
          iconSize: 40,
          onPressed: () async {
            final _localAudio =
                context.read<ViewModelRecord>().getLoacalAudio();
            context
                .read<ViewModelRecord>()
                .addAudioToStorage(await _localAudio);
            context.read<ViewModelRecord>().stop();
          },
        ),
      ),
    );
  }
}
