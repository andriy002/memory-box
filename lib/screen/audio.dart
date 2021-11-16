import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/components/bottom_nav.dart';
import 'package:memory_box/components/drawer.dart';

class Audio extends StatelessWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
          expandedHeight: MediaQuery.of(context).size.height / 3.2,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '0 аудио',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'ttNormal',
                                    fontSize: 14),
                              ),
                              Text(
                                '00:00 часов',
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  height: 65.0,
                  child: Center(
                    child: AudioPlayerList('$index'),
                  ),
                ),
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}

class AudioPlayerList extends StatefulWidget {
  final String data;
  AudioPlayerList(this.data, {Key? key}) : super(key: key);

  @override
  _AudioPlayerListState createState() => _AudioPlayerListState();
}

class _AudioPlayerListState extends State<AudioPlayerList> {
  AudioPlayer? audioPlayer;
  Duration position = Duration();
  Duration musicLength = Duration();
  bool playerToogle = true;

  String audio =
      'https://firebasestorage.googleapis.com/v0/b/memorybox-d633c.appspot.com/o/user%2FQWnaTIzxyWS02ZHBcyrqs4vDrEo2%2Faudio%2FTest21.aac?alt=media&token=a3f34978-359d-451c-863b-447b68558f43';

  @override
  void initState() {
    audioPlayer = AudioPlayer();
    audioPlayer?.setUrl(audio, isLocal: false);

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
        audioPlayer?.stop();
        playerToogle = true;
        position = Duration(milliseconds: 0);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    audioPlayer?.dispose();
    super.dispose();
  }

  Widget slider() {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 1,
        inactiveTrackColor: Colors.black,
        activeTrackColor: Colors.black,
        thumbColor: Colors.black,
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

    String showTimeAudio() {
      if (musicLength.inMinutes > 60) {
        return '${musicLength.inHours} часов';
      } else if (musicLength.inSeconds > 60) {
        return '${durationMinutes} ${musicLength.inMinutes >= 1 ? 'минута' : 'минут'} ';
      }
      return '${durationSeconds} ${musicLength.inSeconds >= 1 ? 'секунда' : 'секунд'}';
    }

    return Padding(
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
                icon: playerToogle ? Icon(Icons.play_arrow) : Icon(Icons.stop),
                color: Colors.white,
                iconSize: 30,
                onPressed: playerToogle
                    ? () async {
                        audioPlayer?.play(audio, isLocal: true);
                        playerToogle = false;
                        setState(() {});
                      }
                    : () async {
                        audioPlayer?.stop();
                        position = Duration(seconds: 0);
                        playerToogle = true;
                        setState(() {});
                      },
              ),
            ),
          ),
          playerToogle
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'data',
                      style: TextStyle(fontFamily: 'ttNormal', fontSize: 14),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text('${showTimeAudio()}',
                        style: TextStyle(
                            fontFamily: 'ttNormal',
                            fontSize: 14,
                            color: Colors.grey)),
                  ],
                )
              : Container(
                  width: 270,
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          slider(),
                          Padding(
                            padding: const EdgeInsets.only(top: 30),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '$minutes:$seconds',
                                    style: TextStyle(fontFamily: 'ttNormal'),
                                  ),
                                  Text('$durationMinutes:$durationSeconds',
                                      style: TextStyle(fontFamily: 'ttNormal')),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
          SizedBox(
            width: playerToogle ? 60 : 0,
          ),
          if (playerToogle)
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.more_horiz,
                size: 20,
              ),
            ),
        ],
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
