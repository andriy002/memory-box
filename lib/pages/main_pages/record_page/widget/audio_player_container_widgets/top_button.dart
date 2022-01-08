import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/main.dart';
import 'package:memory_box/pages/main_pages/record_page/record_page.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/navigation.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

class TopButtonWidget extends StatelessWidget {
  const TopButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _duration =
        context.select((ViewModelAudioPlayer vm) => vm.state.audioLength);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () async {
              final _localAudio =
                  context.read<ViewModelRecord>().getLoacalAudio();

              context.read<ViewModelAudioPlayer>().share(await _localAudio);
            },
            icon: const ImageIcon(AppIcons.upload),
          ),
          IconButton(
            onPressed: () {
              context.read<ViewModelRecord>().saveAudioFileToLocalStorage();
            },
            icon: const ImageIcon(AppIcons.download),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(Record.routeName);
            },
            icon: const ImageIcon(AppIcons.delete),
          ),
          const SizedBox(
            width: 50,
          ),
          TextButton(
            onPressed: () async {
              context
                  .read<ViewModelRecord>()
                  .adddAudioToFireStore(_duration.toString());

              context.read<Navigation>().setCurrentIndex = 3;
            },
            child: const Text(
              'Сохранить',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: AppFonts.mainFont,
                  fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
