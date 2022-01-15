import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory_box/pages/main_pages/collections_audio_page/view_model/view_model_audio_collection.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

class ImageWidget extends StatelessWidget {
  final String img;
  final int dataLength;
  const ImageWidget({
    Key? key,
    required this.img,
    required this.dataLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final File? _image =
        context.select((ViewModelCollectionAudio vm) => vm.state.image);
    final bool _showMore =
        context.select((ViewModelCollectionAudio vm) => vm.state.detailsMore);
    final bool _toogleButtonRepeat =
        context.select((ViewModelAudioPlayer vm) => vm.state.repeatAudio);
    final bool _editCollection = context
        .select((ViewModelCollectionAudio vm) => vm.state.editCollecrion);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: double.infinity,
            height: _showMore
                ? MediaQuery.of(context).size.height / 3.2
                : MediaQuery.of(context).size.height / 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: _image == null
                  ? DecorationImage(
                      image: NetworkImage(img),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: FileImage(_image),
                      fit: BoxFit.cover,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text(
                      '$dataLength аудио',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (!_editCollection)
                    Container(
                      width: 168.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                          color: const Color(0x33F6F6F6),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 2,
                          ),
                          ClipOval(
                            child: Container(
                              color: Colors.white,
                              child: IconButton(
                                icon: Icon(
                                  _toogleButtonRepeat
                                      ? Icons.stop
                                      : Icons.play_arrow,
                                  color: const Color(0x80000000),
                                ),
                                onPressed: () {
                                  context
                                      .read<ViewModelAudioPlayer>()
                                      .toogleRepeatAudio(dataLength);
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 5.0),
                          Text(
                            _toogleButtonRepeat
                                ? 'Остановить'
                                : 'Запустить все',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: AppFonts.mainFont,
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (_editCollection)
            IconButton(
                iconSize: 100,
                onPressed: () {
                  context.read<ViewModelCollectionAudio>().imagePicker();
                },
                icon: const ImageIcon(
                  AppIcons.photoEdit,
                  color: Colors.white,
                ))
        ],
      ),
    );
  }
}
