import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/model/firebase_file.dart';
import 'package:memory_box/services/app_images.dart';

import 'package:memory_box/services/auth_services.dart';
import 'package:memory_box/services/firebase_api.dart';
import 'package:provider/src/provider.dart';

class Audio extends StatefulWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  State<Audio> createState() => _AudioState();
}

class _AudioState extends State<Audio> {
  late Future<List<FirebaseFile>> futureFile;
  bool playerToogle = false;

  callback(bool tog) {
    setState(() {
      playerToogle = tog;
    });
    setState(() {});
  }

  @override
  void initState() {
    futureFile =
        FirebaseApi.listAll('/user/QWnaTIzxyWS02ZHBcyrqs4vDrEo2/audio');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FirebaseFile>>(
        future: futureFile,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );

            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error'),
                );
              }

              final file = snapshot.data!;
              final indexProvider = context.watch<AuthServices>().indexAudio;
              final audioLength = context.read<AuthServices>().audioLength;
              String twoDigits(int n) => n.toString().padLeft(2, '0');
              final durationSeconds =
                  twoDigits(audioLength.inSeconds.remainder(60));
              final durationMinutes =
                  twoDigits(audioLength.inMinutes.remainder(60));
              final hour = twoDigits(audioLength.inHours);

              String showTimeAudio() {
                if (audioLength.inMinutes > 60) {
                  return '${hour}:${durationMinutes} часов';
                } else if (audioLength.inSeconds > 60) {
                  return '${hour}:${durationMinutes} ${audioLength.inMinutes >= 2 ? 'минут' : 'минута'} ';
                }
                return '${durationSeconds} ${audioLength.inSeconds >= 2 ? 'секунд' : 'секунда'}';
              }

              return Stack(
                children: [
                  CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        actions: [
                          IconButton(
                            icon: Icon(
                              Icons.more_horiz,
                              size: 40,
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                          ),
                          SizedBox(
                            width: 10,
                          )
                        ],
                        backgroundColor: Colors.white,
                        expandedHeight:
                            MediaQuery.of(context).size.height / 3.2,
                        floating: false,
                        pinned: false,
                        snap: false,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              CustomAppBarAudio(),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 35,
                                  ),
                                  Text(
                                    'Аудиозаписи',
                                    style: TextStyle(
                                        fontFamily: 'ttNormal',
                                        fontSize: 36,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Все в одном месте',
                                    style: TextStyle(
                                      fontFamily: 'ttNormal',
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${file.length} аудио',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'ttNormal',
                                                  fontSize: 14),
                                            ),
                                            Text(
                                              '${showTimeAudio()}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'ttNormal',
                                                  fontSize: 14),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width: 200,
                                          height: 40,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final files = file[index];

                            return AudioPlayerList(
                                files.name, files.url, index, callback);
                          },
                          childCount: file.length,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 160,
                        ),
                      ),
                    ],
                  ),
                  if (playerToogle)
                    BgPlayer(file[indexProvider].url, file[indexProvider].name,
                        indexProvider, file.length)
                ],
              );
          }
        });
  }
}

class BgPlayer extends StatefulWidget {
  final String audio;
  final String name;
  final index;
  final maxLenth;

  BgPlayer(this.audio, this.name, this.index, this.maxLenth, {Key? key})
      : super(key: key);

  @override
  _BgPlayerState createState() => _BgPlayerState();
}

class _BgPlayerState extends State<BgPlayer> {
  AudioPlayer? audioPlayer;
  Duration position = Duration();
  Duration musicLength = Duration();
  bool playerToogle = false;
  String? audio;

  @override
  void initState() {
    audioPlayer = AudioPlayer();

    super.initState();
  }

  void play() async {
    playerToogle = false;
    audioPlayer?.play(await widget.audio);
  }

  @override
  void didChangeDependencies() {
    context.watch<AuthServices>().indexAudio;
    play();
    audioPlayer?.onDurationChanged.listen((d) => setState(() {
          musicLength = d;
        }));

    audioPlayer?.onAudioPositionChanged.listen(
      (p) => setState(
        () {
          position = p;
        },
      ),
    );

    audioPlayer?.onPlayerCompletion.listen((event) {
      setState(() {
        playerToogle = true;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }

  void nextAudio() {
    context.read<AuthServices>().nextAudio(widget.maxLenth);
  }

  Widget slider() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 1,
        inactiveTrackColor: Colors.white,
        activeTrackColor: Colors.white,
        thumbColor: Colors.white,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 3),
      ),
      child: Slider.adaptive(
          value: position.inSeconds.toDouble(),
          max: musicLength.inSeconds.toDouble(),
          onChanged: (val) {
            sekToSec(val.toInt());
          }),
    );
  }

  void sekToSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    audioPlayer?.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = twoDigits(position.inSeconds.remainder(60));
    final minutes = twoDigits(position.inMinutes.remainder(60));

    final durationSeconds = twoDigits(musicLength.inSeconds.remainder(60));
    final durationMinutes = twoDigits(musicLength.inMinutes.remainder(60));

    return Padding(
      padding: const EdgeInsets.only(bottom: 85),
      child: Container(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF8C84E2),
                    Color(0xFF6C689F),
                  ],
                ),
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            width: double.infinity,
            height: 65,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipOval(
                    child: Container(
                      width: 50,
                      height: 50,
                      color: Colors.white,
                      child: IconButton(
                        icon: playerToogle
                            ? Icon(Icons.play_arrow)
                            : Icon(Icons.pause),
                        color: Color(0xFF8C84E2),
                        iconSize: 30,
                        onPressed: playerToogle
                            ? () {
                                audioPlayer?.resume();
                                playerToogle = false;
                                setState(() {});
                              }
                            : () {
                                audioPlayer?.pause();
                                playerToogle = true;
                                setState(() {});
                              },
                      ),
                    ),
                  ),
                  Container(
                    width: 260,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 0, 0, 30),
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  '${widget.name}',
                                  style: TextStyle(
                                      fontFamily: 'ttNormal',
                                      color: Colors.white,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            slider(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(21, 20, 21, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$minutes:$seconds',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ttNormal',
                                        fontSize: 10),
                                  ),
                                  Text(
                                    '$durationMinutes:$durationSeconds',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ttNormal',
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        nextAudio();
                      },
                      icon: ImageIcon(
                        AppImages.arrowNext,
                        size: 40,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AudioPlayerList extends StatefulWidget {
  final String audio;
  final String data;
  final int index;
  final Function callback;
  AudioPlayerList(this.data, this.audio, this.index, this.callback, {Key? key})
      : super(key: key);

  @override
  _AudioPlayerListState createState() => _AudioPlayerListState();
}

class _AudioPlayerListState extends State<AudioPlayerList> {
  AudioPlayer? audioPlayer;
  Duration position = Duration();
  Duration musicLength = Duration();
  bool playerToogle = true;
  String? audio;
  int? index;

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    playerToogle = true;

    audio = widget.audio;

    audioPlayer?.setUrl(audio!, isLocal: false);

    audioPlayer?.onDurationChanged.listen((d) => setState(() {
          musicLength = d;
        }));

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    context.watch<AuthServices>().indexAudio == widget.index
        ? playerToogle = false
        : playerToogle = true;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    final durationSeconds = twoDigits(musicLength.inSeconds.remainder(60));
    final durationMinutes = twoDigits(musicLength.inMinutes.remainder(60));

    String showTimeAudio() {
      if (musicLength.inMinutes > 60) {
        return '${musicLength.inHours} часов';
      } else if (musicLength.inSeconds > 60) {
        return '${durationMinutes} ${musicLength.inMinutes >= 2 ? 'минут' : 'минута'} ';
      }
      return '${durationSeconds} ${musicLength.inSeconds >= 2 ? 'секунд' : 'секунда'}';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        height: 60,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipOval(
                child: Container(
                  width: 50,
                  height: 50,
                  color: Color(0xFF5E77CE),
                  child: IconButton(
                    icon: playerToogle
                        ? Icon(Icons.play_arrow)
                        : Icon(Icons.stop),
                    color: Colors.white,
                    iconSize: 30,
                    onPressed: playerToogle
                        ? () {
                            playerToogle = false;
                            context.read<AuthServices>().setIndexAudio =
                                widget.index;
                            widget.callback(true);
                          }
                        : () {
                            playerToogle = true;
                            setState(() {});
                            widget.callback(false);
                          },
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 200,
                    child: Text(
                      '${widget.data}',
                      style: TextStyle(fontFamily: 'ttNormal', fontSize: 14),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${showTimeAudio()}',
                    style: TextStyle(
                        fontFamily: 'ttNormal',
                        fontSize: 14,
                        color: Colors.grey),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBarAudio extends StatelessWidget {
  const CustomAppBarAudio({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 3),
        painter: MyPainter(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = Color(0xff5E77CE);
    canvas.drawCircle(
        Offset(size.width / 1.8, size.height - size.width), size.width, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
