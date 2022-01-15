import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:provider/provider.dart';

class TimerRecordWidget extends StatelessWidget {
  const TimerRecordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final seconds = context.select((ViewModelRecord vm) => vm.second());
    final minutes = context.select((ViewModelRecord vm) => vm.minutes());
    final hour = context.select((ViewModelRecord vm) => vm.hour());
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
}
