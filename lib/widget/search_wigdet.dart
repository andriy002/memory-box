import 'package:flutter/material.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  final Function onChanged;
  const SearchWidget({Key? key, required this.onChanged}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width - 30,
            height: 50,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: TextField(
                onChanged: (val) {
                  onChanged(val);
                  context.read<ViewModelAudioPlayer>().stop();
                },
                style: const TextStyle(
                  fontFamily: AppFonts.mainFont,
                  fontSize: 20,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Поиск',
                  hintStyle: TextStyle(
                    fontFamily: AppFonts.mainFont,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20),
            child: Align(
              alignment: Alignment.centerRight,
              child: ImageIcon(AppIcons.search),
            ),
          )
        ],
      ),
    );
  }
}
