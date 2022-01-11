import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/record_page/view_model_record/view_mode_record.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

import 'widget/audio_player_container_widgets/audio_name.dart';
import 'widget/audio_player_container_widgets/audio_slider.dart';
import 'widget/audio_player_container_widgets/bottom_button.dart';
import 'widget/audio_player_container_widgets/top_button.dart';

class AudioContainerWidget extends StatefulWidget {
  const AudioContainerWidget({Key? key}) : super(key: key);

  @override
  State<AudioContainerWidget> createState() => _AudioContainerWidgetState();
}

class _AudioContainerWidgetState extends State<AudioContainerWidget> {
  Future<void> setAudio() async {
    final localAudio = context.read<ViewModelRecord>().getLoacalAudio();
    context.read<ViewModelAudioPlayer>().setLocalAudio(await localAudio, false);
  }

  @override
  void initState() {
    setAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height - 310,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              TopButtonWidget(),
              SizedBox(),
              AudioNameWidget(),
              SizedBox(),
              SliderAudioWidget(),
              SizedBox(),
              BottomButtonWidget(),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
