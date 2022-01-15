import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/widget/audio_widget/list_audio/widget/add_audio_to_list_button.dart';
import 'package:memory_box/widget/audio_widget/list_audio/widget/button_play.dart';
import 'package:memory_box/widget/audio_widget/list_audio/widget/deleted_button.dart';
import 'package:memory_box/widget/audio_widget/list_audio/widget/name_and_duration_widget.dart';
import 'package:memory_box/widget/audio_widget/list_audio/widget/pop_up_menu_audio_button.dart';

enum ButtonStatus { selected, deleted, edit }

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
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _AudioUiCard(
            audioDuration: data[index].duration,
            audioName: data[index].audioName,
            index: index,
            audioUrl: data[index].audioUrl,
            audioUid: data[index].uid,
            colorButton: colorButton,
            stastusButton: stastusButton,
          );
        },
        childCount: childCount,
      ),
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
              ButtonPlay(
                index: index!,
                colorButton: colorButton,
              ),
              NameAndDurationWidget(
                audioDuration: audioDuration!,
                audioName: audioName!,
                index: index!,
                uidAudio: audioUid!,
              ),
              if (stastusButton == ButtonStatus.selected)
                AddAudioToListButton(
                  audioUid: audioUid,
                ),
              if (stastusButton == ButtonStatus.edit)
                PopupMenuAudioButton(
                  audioName: audioName!,
                  audioUid: audioUid!,
                  audioUrl: audioUrl!,
                  index: index!,
                ),
              if (stastusButton == ButtonStatus.deleted)
                DeletedButton(
                  doc: audioUid!,
                ),
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
