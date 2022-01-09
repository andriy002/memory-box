import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';

import 'package:memory_box/widget/audio_widget/poup_menu_widget.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:provider/provider.dart';

class SliverAudioAppBar extends StatelessWidget {
  final int data;
  const SliverAudioAppBar({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: const [
        PopupMenuAudioWidget(),
        SizedBox(
          width: 10,
        )
      ],
      backgroundColor: Colors.white,
      expandedHeight: MediaQuery.of(context).size.height / 3.5,
      floating: false,
      pinned: false,
      snap: false,
      title: Column(
        children: const [
          Text(
            'Аудиозаписи',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'Все в одном месте',
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 16,
            ),
          )
        ],
      ),
      centerTitle: true,
      flexibleSpace: Stack(
        alignment: Alignment.center,
        children: [
          CircleAppBar(
            heightCircle: MediaQuery.of(context).size.height / 5,
            colorCircle: AppColors.allAudioColor,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$data аудио',
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: AppFonts.mainFont,
                        fontSize: 18),
                  ),
                  PlayRepeatButton(
                    dataLength: data,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PlayRepeatButton extends StatelessWidget {
  final int dataLength;
  const PlayRepeatButton({Key? key, required this.dataLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool _toogleButtonRepeat =
        context.select((ViewModelAudioPlayer vm) => vm.state.repeatAudio);
    return SizedBox(
      width: 223.0,
      height: 50.0,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 90,
              height: 50,
              decoration: BoxDecoration(
                  color: const Color(0x33F6F6F6),
                  borderRadius: BorderRadius.circular(30)),
              child: const Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Icon(
                  Icons.repeat,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            width: _toogleButtonRepeat ? 223.0 : 170.0,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                const SizedBox(
                  width: 2,
                ),
                ClipOval(
                  child: Container(
                    color: AppColors.mainColor,
                    child: IconButton(
                      icon: Icon(
                        _toogleButtonRepeat ? Icons.stop : Icons.play_arrow,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        context
                            .read<ViewModelAudioPlayer>()
                            .toogleRepeatAudio(dataLength);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: _toogleButtonRepeat ? 30.0 : 5.0,
                ),
                Text(
                  _toogleButtonRepeat ? 'Остановить' : 'Запустить все',
                  style: const TextStyle(
                    color: AppColors.mainColor,
                    fontFamily: AppFonts.mainFont,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
