import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/view_model/view_model_audio.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/search_wigdet.dart';
import 'package:provider/provider.dart';

class SliverAppBarSearchPage extends StatelessWidget {
  const SliverAppBarSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchKeyChanged = context.read<ViewModelAudio>().searchKeyInput;

    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_horiz,
            size: 40,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        const SizedBox(
          width: 10,
        )
      ],
      backgroundColor: Colors.white,
      expandedHeight: MediaQuery.of(context).size.height / 3,
      floating: false,
      pinned: false,
      snap: false,
      title: Column(
        children: const [
          Text(
            'Поиск',
            style: TextStyle(
                fontFamily: AppFonts.mainFont,
                fontSize: 36,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'Найди потеряшку',
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
            heightCircle: MediaQuery.of(context).size.height / 6,
            colorCircle: AppColors.allAudioColor,
          ),
          SearchWidget(
            onChanged: _searchKeyChanged,
          )
        ],
      ),
    );
  }
}
