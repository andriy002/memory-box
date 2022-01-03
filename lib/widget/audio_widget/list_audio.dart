import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio.dart';

import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:provider/provider.dart';

import '../popup_item.dart';

enum ButtonStatus { selected, delete, edit }

class SliverAudioList extends StatelessWidget {
  final List<AudioBuilder> data;
  final int childCount;
  final Color? colorButton;
  final ButtonStatus stastusButton;
  const SliverAudioList({
    Key? key,
    required this.data,
    required this.childCount,
    this.colorButton,
    required this.stastusButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return _AudioUiCard(
          audioDuration: data[index].duration,
          audioName: data[index].audioName,
          index: index,
          audioUrl: data[index].audioUrl,
          audioUid: data[index].uid,
          colorButton: colorButton,
          stastusButton: stastusButton,
        );
      }, childCount: childCount),
    );
  }
}

class _AudioUiCard extends StatelessWidget {
  final String? audioName;
  final String? audioDuration;
  final int? index;
  final Color? colorButton;
  final String? audioUrl;
  final String? audioUid;
  final ButtonStatus stastusButton;

  const _AudioUiCard({
    Key? key,
    required this.audioDuration,
    required this.audioName,
    required this.index,
    this.colorButton,
    required this.audioUrl,
    required this.audioUid,
    required this.stastusButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PlayButtonWidget(
                index: index!,
                colorButton: colorButton,
              ),
              _NameAndDurationWidget(
                audioDuration: audioDuration!,
                audioName: audioName!,
                index: index!,
                uidAudio: audioUid!,
              ),
              if (stastusButton == ButtonStatus.selected)
                _AddAudioToList(
                  audioUid: audioUid,
                ),
              if (stastusButton == ButtonStatus.edit)
                _PopupMenuWidget(
                  audioDuration: audioDuration!,
                  audioName: audioName!,
                  audioUid: audioUid!,
                  audioUrl: audioUrl!,
                  index: index!,
                )
            ],
          ),
        ),
        shape: const StadiumBorder(
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _AddAudioToList extends StatefulWidget {
  final String? audioUid;
  const _AddAudioToList({
    Key? key,
    required this.audioUid,
  }) : super(key: key);

  @override
  State<_AddAudioToList> createState() => _AddAudioToListState();
}

class _AddAudioToListState extends State<_AddAudioToList> {
  @override
  Widget build(BuildContext context) {
    bool isCheck = false;
    final chekUid = context.select((ViewModelAudio vm) => vm.state.audioMap);

    if (chekUid[widget.audioUid] == true) {
      isCheck = true;
    }

    return GestureDetector(
      onTap: () {
        if (isCheck) {
          context
              .read<ViewModelAudio>()
              .removeAudioInMap(widget.audioUid ?? '');
        } else {
          isCheck = false;
          context.read<ViewModelAudio>().addAudioToMap(widget.audioUid ?? '');
        }
        setState(() {});
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(60),
            ),
          ),
          if (isCheck) const ImageIcon(AppIcons.done)
        ],
      ),
    );
  }
}

class _NameAndDurationWidget extends StatelessWidget {
  final String audioName;
  final String audioDuration;
  final int index;
  final String uidAudio;
  const _NameAndDurationWidget({
    Key? key,
    required this.audioName,
    required this.audioDuration,
    required this.index,
    required this.uidAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? textEditingController = TextEditingController();

    final bool? renameAudio;

    final checkerRenameAudio =
        context.select((ViewModelAudio vm) => vm.state.indexRename);

    checkerRenameAudio == index ? renameAudio = true : renameAudio = false;

    final String substringAudio =
        audioName.length > 31 ? audioName.substring(0, 31) : audioName;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 220,
          height: 20,
          child: !renameAudio
              ? Text(
                  substringAudio,
                  style: const TextStyle(
                    fontFamily: AppFonts.mainFont,
                  ),
                )
              : TextField(
                  controller: textEditingController,
                  onEditingComplete: () {
                    context
                        .read<ViewModelAudio>()
                        .renameAudio(uidAudio, textEditingController.text);
                  },
                  style: const TextStyle(
                    fontFamily: AppFonts.mainFont,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: substringAudio,
                    isCollapsed: true,
                  ),
                ),
        ),
        Text(
          audioDuration.substring(0, 7),
          style: const TextStyle(
            fontFamily: AppFonts.mainFont,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _PopupMenuWidget extends StatelessWidget {
  final String audioName;
  final String audioDuration;
  final String audioUrl;
  final String audioUid;
  final int index;

  const _PopupMenuWidget({
    Key? key,
    required this.audioDuration,
    required this.audioName,
    required this.audioUrl,
    required this.audioUid,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<ViewModelAudio>();

    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      itemBuilder: (context) => [
        popupMenuItem('Переименовать', () {
          viewModel.setIndexReanme(index);
        }),
        popupMenuItem('Добавить в подборк', () {
          // viewModel.deleteSelectedAudio();
        }),
        popupMenuItem('Удалить', () {
          viewModel.sendAudioToDeleteColection(
              audioName, audioUrl, audioDuration, audioUid);
        }),
        popupMenuItem('Поделиться', () {
          viewModel.shareUrlFile(audioUrl, audioName);
        }),
      ],
    );
  }
}

class _PlayButtonWidget extends StatelessWidget {
  final int index;
  final Color? colorButton;
  const _PlayButtonWidget({
    Key? key,
    required this.index,
    this.colorButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool? isPlaying;

    final indexAudio =
        context.select((ViewModelAudioPlayer vm) => vm.state.indexAudio);

    indexAudio == index ? isPlaying = true : isPlaying = false;

    final iconCheker =
        !isPlaying ? const Icon(Icons.play_arrow) : const Icon(Icons.stop);
    final onPressedChecker = !isPlaying
        ? () => context.read<ViewModelAudioPlayer>().setPlayingIndex(index)
        : () => context.read<ViewModelAudioPlayer>().stop();
    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        color: colorButton ?? AppColors.allAudioColor,
        child: IconButton(
            icon: iconCheker,
            iconSize: 30,
            color: Colors.white,
            onPressed: onPressedChecker),
      ),
    );
  }
}
