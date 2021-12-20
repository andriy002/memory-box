import 'package:flutter/material.dart';
import 'package:memory_box/models/audio_model.dart';
import 'package:memory_box/resources/app_colors.dart';
import 'package:memory_box/resources/app_fonts.dart';
import 'package:memory_box/resources/app_icons.dart';
import 'package:memory_box/view_model/view_model_audio_player.dart';
import 'package:memory_box/widget/audio_widget/audio_player.dart';
import 'package:memory_box/widget/circle_app_bar.dart';
import 'package:memory_box/widget/slider_audio_player.dart';
import 'package:provider/provider.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({Key? key}) : super(key: key);

  static Widget create() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ViewModelAudioPlayer()),
      ],
      child: const AudioPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AudioBuilder> data = context.watch<List<AudioBuilder>?>() ?? [];

    final bool _isPlaying =
        context.select((ViewModelAudioPlayer vm) => vm.state.isPlaying);
    final int _indexAudio =
        context.select((ViewModelAudioPlayer vm) => vm.state.indexAudio ?? 0);

    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
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
              expandedHeight: MediaQuery.of(context).size.height / 3.2,
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
              flexibleSpace: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAppBar(
                      heightCircle: MediaQuery.of(context).size.height / 4,
                      colorCircle: AppColors.allAudioColor,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 60),
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
                    )
                  ],
                ),
              ),
            ),
            SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return AudioUiCard(
                  audioDuration: data[index].duration ?? '00:00',
                  audioName: data[index].audioName ?? 'audio name',
                  index: index,
                );
              }, childCount: data.length),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(
                height: 160,
              ),
            ),
          ],
        ),
        if (_isPlaying)
          AudioPlayerWidget(
            audioUrl: data[_indexAudio].audioUrl,
            maxLength: data.length,
            audioName: data[_indexAudio].audioName,
          )
      ],
    );
  }
}

class AudioUiCard extends StatefulWidget {
  final String audioName;
  final String audioDuration;

  final int index;
  final Color? colorButton;

  const AudioUiCard({
    Key? key,
    required this.audioDuration,
    required this.audioName,
    required this.index,
    this.colorButton,
  }) : super(key: key);

  @override
  State<AudioUiCard> createState() => _AudioUiCardState();
}

class _AudioUiCardState extends State<AudioUiCard> {
  @override
  Widget build(BuildContext context) {
    final bool? isPlaying;

    final indexAudio =
        context.select((ViewModelAudioPlayer vm) => vm.state.indexAudio);

    indexAudio == widget.index ? isPlaying = true : isPlaying = false;

    final iconCheker =
        !isPlaying ? const Icon(Icons.play_arrow) : const Icon(Icons.stop);

    final onPressedChecker = !isPlaying
        ? () =>
            context.read<ViewModelAudioPlayer>().setPlayingIndex(widget.index)
        : () => context.read<ViewModelAudioPlayer>().stop();

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
              ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  color: widget.colorButton ?? AppColors.allAudioColor,
                  child: IconButton(
                      icon: iconCheker,
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: onPressedChecker),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: Text(
                      widget.audioName.length > 31
                          ? widget.audioName.substring(0, 31)
                          : widget.audioName,
                      style: const TextStyle(
                        fontFamily: AppFonts.mainFont,
                      ),
                    ),
                  ),
                  Text(
                    widget.audioDuration.length > 7
                        ? widget.audioDuration.substring(0, 7)
                        : widget.audioDuration,
                    style: const TextStyle(
                      fontFamily: AppFonts.mainFont,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  size: 20,
                ),
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

class PlayerPlayPasueButtonWidget extends StatelessWidget {
  const PlayerPlayPasueButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool playPause =
        context.select((ViewModelAudioPlayer vm) => vm.state.pause);
    return ClipOval(
      child: Container(
        width: 50,
        height: 50,
        color: Colors.white,
        child: IconButton(
          icon: playPause
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: const Color(0xFF8C84E2),
          onPressed: playPause
              ? () {
                  context.read<ViewModelAudioPlayer>().resume();
                }
              : () {
                  context.read<ViewModelAudioPlayer>().pause();
                },
        ),
      ),
    );
  }
}
