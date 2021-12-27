import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/widget/circle_app_bar.dart';

class SliverAudioAppBar extends StatelessWidget {
  final data;
  const SliverAudioAppBar({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_horiz,
            size: 40,
          ),
          onPressed: () {},
        ),
        const SizedBox(
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${data.length} аудио',
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: AppFonts.mainFont,
                    ),
                  ),
                  Text('data')
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
