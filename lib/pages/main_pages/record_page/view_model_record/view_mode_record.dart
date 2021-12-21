import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:memory_box/utils/two_digits.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class _ViewModelRecordState {
  Duration duration = const Duration();
  Timer? timer;
  Record? record;
  Amplitude? amplitude;
  Timer? timerAmplitude;
  double dcb = 0;
  double incWidth = 0;
  List listAmplitude = [];
  bool recordToogle = false;
  bool redactionAudioName = false;
  String audioName = 'Аудиозапись';
}

class ViewModelRecord with ChangeNotifier {
  final _ViewModelRecordState _state = _ViewModelRecordState();
  final AudioRepositories _audioRepo = AudioRepositories.instance;

  _ViewModelRecordState get state => _state;

  String second() => twoDigits(_state.duration.inSeconds.remainder(60));
  String minutes() => twoDigits(_state.duration.inMinutes.remainder(60));
  String hour() => twoDigits(_state.duration.inHours.remainder(60));

  void _addTime() {
    const addSecond = 1;
    final seconds = _state.duration.inSeconds + addSecond;
    _state.duration = Duration(seconds: seconds);
    notifyListeners();
  }

  ViewModelRecord() {
    Timer(const Duration(seconds: 1), _start);
  }

  Future<void> addAudio(String path, String duration) async {
    try {
      if (_state.audioName == 'Аудиозапись') {
        _state.audioName += ' ${DateTime.now()}';
      }

      await _audioRepo.addAudio(_state.audioName, path, duration);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _start() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) return;
    await _record();
    _startTimer();
    _getAmplituder();
  }

  void redactionAudioNameToogle(String audioName) {
    if (_state.redactionAudioName) {
      _state.redactionAudioName = false;
      _state.audioName = audioName;

      notifyListeners();
    } else {
      _state.redactionAudioName = true;
      notifyListeners();
    }
  }

  Future<void> _getAmplituder() async {
    _state.timerAmplitude = Timer.periodic(
      const Duration(milliseconds: 40),
      (_) async {
        _state.incWidth++;
        _state.amplitude = await _state.record!.getAmplitude();
        _state.dcb = _state.amplitude!.current + 45;
        if (_state.dcb < 2) {
          _state.dcb = 2;
        }
        _state.listAmplitude.add(_state.dcb);
        notifyListeners();
      },
    );
  }

  Future<File> saveAudioFileToLocalStorage() async {
    String name = _state.audioName;
    String file =
        '/storage/15FD-100D/Android/data/com.andrewdezh.memory_box/cache/Аудизапись.aac';
    if (name == 'Аудиозапись') {
      name += ' ${DateTime.now()}';
    }
    final appStorage = await getExternalStorageDirectory();
    final newFile = File('${appStorage?.path}/$name.aac');
    return File(file).copy(newFile.path);
  }

  Future<void> _record() async {
    _state.record = Record();
    final appStorage = await getExternalCacheDirectories();
    const pathAudio =
        '/storage/15FD-100D/Android/data/com.andrewdezh.memory_box/cache/Аудизапись.aac';
    _state.record?.start(path: pathAudio);
  }

  void _startTimer() {
    _state.timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _addTime());
  }

  void stop() {
    _state.timerAmplitude?.cancel();
    _state.record?.stop();
    _state.record?.dispose();
    _state.timer?.cancel();
    _state.recordToogle = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _state.timerAmplitude?.cancel();
    stop();
    super.dispose();
  }
}
