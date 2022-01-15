import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/deleted_audio_page/widget/pop_up_deleted_page.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/circle_app_bar.dart';

class SliverAppBarDeletedPage extends StatelessWidget {
  const SliverAppBarDeletedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: const [
        PopupMenuDeletedPage(),
        SizedBox(
          width: 10,
        )
      ],
      backgroundColor: Colors.white,
      expandedHeight: MediaQuery.of(context).size.height / 4,
      floating: false,
      pinned: false,
      snap: false,
      toolbarHeight: 85,
      title: Column(
        children: const [
          Text(
            'Недавно \n удаленные',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.mainFont,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 15,
          )
        ],
      ),
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: Alignment.center,
          children: [
            CircleAppBar(
              heightCircle: MediaQuery.of(context).size.height / 10,
              colorCircle: AppColors.allAudioColor,
            ),
          ],
        ),
      ),
    );
  }
}
