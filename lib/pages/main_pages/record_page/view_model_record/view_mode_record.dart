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
  bool editAudioName = false;
  String audioName = 'Аудиозапись';
  String? audioId;
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

  Future<void> addAudioToStorage(String path) async {
    try {
      _state.audioId = await _audioRepo.addAudio(path);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> adddAudioToFireStore(String duration) async {
    if (_state.audioName == 'Аудиозапись') {
      _state.audioName += ' ${DateTime.now()}';
    }
    await _audioRepo.addAudioInFirestore(
        _state.audioName, duration, _state.audioId!);
  }

  Future<void> _start() async {
    final status = await Permission.microphone.request();
    if (status.isDenied) return;
    await _record();
    _startTimer();
    _getAmplituder();
  }

  Future<String> getLoacalAudio() async {
    final temp = await getTemporaryDirectory();
    final pathAudio = '${temp.path}/Аудиозапись.aac';
    return pathAudio;
  }

  void editAudioNameToogle(String audioName) {
    if (_state.editAudioName) {
      _state.editAudioName = false;
      _state.audioName = audioName;

      notifyListeners();
    } else {
      _state.editAudioName = true;
      notifyListeners();
    }
  }

  void _getAmplituder() {
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
    final temp = await getTemporaryDirectory();
    final pathAudio = '${temp.path}/Аудиозапись.aac';
    if (name == 'Аудиозапись') {
      name += ' ${DateTime.now()}';
    }
    final appStorage = await getExternalStorageDirectory();
    final newFile = File('${appStorage?.path}/$name.aac');
    return File(pathAudio).copy(newFile.path);
  }

  Future<void> _record() async {
    _state.record = Record();
    final temp = await getTemporaryDirectory();
    final pathAudio = '${temp.path}/Аудиозапись.aac';
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
    _state.record = null;
    stop();
    super.dispose();
  }
}
