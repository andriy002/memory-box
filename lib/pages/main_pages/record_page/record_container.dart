import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:memory_box/pages/main_pages/record_page/widget/timer_record.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:provider/provider.dart';

import 'widget/voice_animation.dart';

class RecordContainerWidget extends StatelessWidget {
  const RecordContainerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        const TimerRecordWidget(),
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
              context.read<ViewModelRecord>().stop();

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
          context.read<ViewModelRecord>().stop();
        },
      ),
    ),
  );
}
