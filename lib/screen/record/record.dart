import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';

import 'package:memory_box/components/drawer.dart';
import 'package:memory_box/controlers/navigation.dart';
import 'package:memory_box/services/app_images.dart';

import 'package:memory_box/services/auth_services.dart';
import 'package:memory_box/widget/widget_auth/custom_app_bar.dart';
import 'package:noise_meter/noise_meter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

final patchToSaveAudio = 'Аудиозапись.aac';

class RecordPage extends StatelessWidget {
  const RecordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerComponents(context),
      appBar: AppBar(
        backgroundColor: Color(0xff8C84E2),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Icons.menu)),
      ),
      body: Record(),
    );
  }
}

// class CustomThumb extends SliderComponentShape {
//   double thumbRadius;

//   CustomThumb(this.thumbRadius);

//   @override
//   Size getPreferredSize(bool isEnabled, bool isDiscrete) {
//     return Size.fromRadius(thumbRadius);
//   }

//   @override
//   void paint(PaintingContext context, Offset center,
//       {required Animation<double> activationAnimation,
//       required Animation<double> enableAnimation,
//       required bool isDiscrete,
//       required TextPainter labelPainter,
//       required RenderBox parentBox,
//       required SliderThemeData sliderTheme,
//       required TextDirection textDirection,
//       required double value,
//       required double textScaleFactor,
//       required Size sizeWithOverflow}) {
//     final canvas = context.canvas;
//     final fillPaint = Paint()
//       ..color = Colors.black
//       ..style = PaintingStyle.fill;

//     canvas.drawCircle(center, thumbRadius, fillPaint);
//   }
// }

class AudioPlayerUI extends StatefulWidget {
  AudioPlayerUI({Key? key}) : super(key: key);

  @override
  _AudioPlayerUIState createState() => _AudioPlayerUIState();
}

class _AudioPlayerUIState extends State<AudioPlayerUI> {
  Duration position = Duration();
  Duration musicLength = Duration();
  AudioPlayer? audioPlayer;
  String audioCache =
      '/data/user/0/com.example.memory_box/cache/Аудиозапись.aac';
  bool playerToogle = true;
  bool secUp = false;
  bool toogleRedName = false;
  final audioName = TextEditingController(text: 'Аудиозапись');

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    audioPlayer?.setUrl(audioCache, isLocal: true);

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
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer?.dispose();
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

  Future<File> saveAudioFileToLocalStorage(File file, String name) async {
    if (name == 'Аудиозапись') {
      name += ' ${DateTime.now()}';
    }
    final appStorage = await getExternalStorageDirectory();
    final newFile = File('${appStorage?.path}/$name.aac');
    print(newFile.length());
    return File(file.path).copy(newFile.path);
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = twoDigits(position.inSeconds.remainder(60));
    final minutes = twoDigits(position.inMinutes.remainder(60));
    final durationSeconds = twoDigits(musicLength.inSeconds.remainder(60));
    final durationMinutes = twoDigits(musicLength.inMinutes.remainder(60));

    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        Share.shareFiles(
                          ['${audioCache}'],
                        );
                      },
                      icon: ImageIcon(
                        AppImages.upload,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () async {
                        saveAudioFileToLocalStorage(
                            File(audioCache), audioName.text);
                      },
                      icon: ImageIcon(AppImages.download),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/main_screen');

                        setState(() {});
                      },
                      icon: ImageIcon(AppImages.deleteBottomNavBar),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthServices>()
                              .pushAudio(audioCache, audioName.text);
                        },
                        child: Text(
                          'Сохранить',
                          style: TextStyle(
                              fontFamily: 'ttNormal',
                              color: Colors.black,
                              fontSize: 16),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  toogleRedName = true;
                });
              },
              child: !toogleRedName
                  ? Text(
                      '${audioName.text}',
                      style: TextStyle(fontFamily: 'ttNormal', fontSize: 24),
                    )
                  : Container(
                      width: 300,
                      child: TextField(
                        controller: audioName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'ttNormal', fontSize: 24),
                        onEditingComplete: () {
                          toogleRedName = false;
                          setState(() {});
                        },
                      ),
                    ),
            ),
            SizedBox(
              height: 60,
            ),
            slider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${minutes}:${seconds} ',
                    style: TextStyle(fontFamily: 'ttNormal', fontSize: 16),
                  ),
                  Text(
                    '${durationMinutes}:${durationSeconds} ',
                    style: TextStyle(fontFamily: 'ttNormal', fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (position.inSeconds >= 15) {
                      audioPlayer?.seek(position - Duration(seconds: 15));
                    } else {
                      audioPlayer?.seek(position = Duration(seconds: 0));
                    }
                  },
                  icon: ImageIcon(
                    AppImages.secDown,
                    size: 40,
                  ),
                ),
                SizedBox(
                  width: 40,
                ),
                ClipOval(
                  child: Container(
                    width: 80,
                    height: 80,
                    color: Color(0xFFF1B488),
                    child: IconButton(
                      icon: playerToogle
                          ? Icon(Icons.play_arrow)
                          : Icon(Icons.stop),
                      color: Colors.white,
                      iconSize: 40,
                      onPressed: playerToogle
                          ? () async {
                              audioPlayer?.play(audioCache, isLocal: true);
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
                SizedBox(
                  width: 40,
                ),
                IconButton(
                  onPressed: () {
                    if ((position.inSeconds - musicLength.inSeconds) <= -15) {
                      audioPlayer?.seek(position + Duration(seconds: 15));
                    } else {
                      audioPlayer?.seek(position =
                          Duration(seconds: musicLength.inSeconds - 0));
                    }
                  },
                  icon: ImageIcon(
                    AppImages.secUp,
                    size: 40,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  bool _isRecording = false;
  StreamSubscription<NoiseReading>? _noiseSubscription;
  NoiseMeter? _noiseMeter;
  SoundRecorder soundRecorder = SoundRecorder();
  double voiseLevel = 0;
  Duration duration = Duration();
  Timer? timer;
  bool? record;

  @override
  void initState() {
    super.initState();
    record = true;
    _noiseMeter = new NoiseMeter(onError);
    soundRecorder.init();
    start();
    startTimer();
  }

  void addTime() {
    final addSecond = 1;
    setState(() {
      final seconds = duration.inSeconds + addSecond;
      duration = Duration(seconds: seconds);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) => addTime());
  }

  @override
  void dispose() {
    super.dispose();
    _noiseSubscription?.cancel();
    soundRecorder.dispose();
    timer?.cancel();
    stop();
    record = false;
  }

  void onError(Object error) {
    print(error.toString());
    _isRecording = false;
  }

  void start() async {
    try {
      if (_noiseMeter != null) {
        _noiseSubscription = _noiseMeter?.noiseStream.listen(onData);
      }
    } catch (err) {
      print(err);
    }
  }

  void stop() async {
    try {
      if (_noiseSubscription != null) {
        _noiseSubscription!.cancel();
        _noiseSubscription = null;
      }
      this.setState(() {
        this._isRecording = false;
      });
    } catch (err) {
      print('stopRecorder error: $err');
    }
  }

  void onData(NoiseReading noiseReading) {
    this.setState(() {
      if (!this._isRecording) {
        this._isRecording = true;
      }
    });
    // print(noiseReading.toString());
    voiseLevel = noiseReading.meanDecibel - 50;
  }

  @override
  Widget build(BuildContext context) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final hour = twoDigits(duration.inHours);
    // final recordTog = context.read<AuthServices>().record;

    AnimatedContainer buidBar(double vol) {
      double level = vol * voiseLevel * 2;
      if (level <= 0) {
        level = 0;
      }
      if (level >= 90) {
        level = 90;
      }
      return AnimatedContainer(
        duration: Duration(milliseconds: 50),
        height: level,
        width: 1,
        color: Colors.black,
      );
    }

    return Stack(
      children: [
        CustomAppBar(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              width: MediaQuery.of(context).size.width / 1.02,
              height: MediaQuery.of(context).size.height / 1.5,
              child: record!
                  ? Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                context
                                    .read<NavigationController>()
                                    .setCurrentIndex = 0;
                              },
                              child: Text(
                                'Отменить',
                                style: TextStyle(
                                    fontFamily: 'ttNormal',
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Запись',
                          style:
                              TextStyle(fontFamily: 'ttNormal', fontSize: 24),
                        ),
                        SizedBox(
                          height: 120,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 70,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.7),
                                  buidBar(0.9),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.8),
                                  buidBar(0.4),
                                  buidBar(0.2),
                                  buidBar(1),
                                  buidBar(0.5),
                                  buidBar(0.5),
                                  buidBar(0.8),
                                  buidBar(0.4),
                                  buidBar(0.2),
                                  buidBar(1),
                                  buidBar(0.5),
                                  buidBar(0.4),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.7),
                                  buidBar(0.9),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.8),
                                  buidBar(0.4),
                                  buidBar(0.2),
                                  buidBar(1),
                                  buidBar(0.5),
                                  buidBar(0.4),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.7),
                                  buidBar(0.9),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.8),
                                  buidBar(0.4),
                                  buidBar(0.2),
                                  buidBar(1),
                                  buidBar(0.5),
                                  buidBar(0.4),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.7),
                                  buidBar(0.9),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.8),
                                  buidBar(0.7),
                                  buidBar(0.9),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.8),
                                  buidBar(0.4),
                                  buidBar(0.2),
                                  buidBar(1),
                                  buidBar(0.5),
                                  buidBar(0.4),
                                  buidBar(0.2),
                                  buidBar(1),
                                  buidBar(0.5),
                                  buidBar(0.4),
                                  buidBar(1),
                                  buidBar(0.5),
                                  buidBar(0.4),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                  buidBar(0.5),
                                  buidBar(0.7),
                                  buidBar(0.9),
                                  buidBar(1.5),
                                  buidBar(1.3),
                                ],
                              ),
                              Center(
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 65,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Container(
                                width: 10,
                                height: 10,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              '$hour:$minutes:$seconds',
                              style: TextStyle(
                                  fontFamily: 'ttoNormal', fontSize: 18),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        ClipOval(
                          child: Container(
                            width: 80,
                            height: 80,
                            color: Color(0xFFF1B488),
                            child: IconButton(
                              icon: Icon(Icons.pause),
                              color: Colors.white,
                              iconSize: 40,
                              onPressed: () async {
                                stop();
                                soundRecorder.stop();
                                timer?.cancel();
                                record = false;
                                setState(() {});
                              },
                            ),
                          ),
                        )
                      ],
                    )
                  : AudioPlayerUI(),
            ),
          ),
        )
      ],
    );
  }
}

class SoundRecorder with ChangeNotifier {
  bool _isRecordingInitialised = false;

  set isRecord(bool rec) {
    _isRecordingInitialised = rec;
  }

  FlutterSoundRecorder? _audioRecorder;

  Future stop() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.stopRecorder();
  }

  Future record() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.startRecorder(toFile: patchToSaveAudio);
  }

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openAudioSession();

    _isRecordingInitialised = true;

    await record();
  }

  Future dispose() async {
    if (!_isRecordingInitialised) return;
    _audioRecorder!.closeAudioSession();

    _audioRecorder = null;
    _isRecordingInitialised = false;
  }
}
