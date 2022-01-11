import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/utils/two_digits.dart';
import 'package:share/share.dart';

class _ViewModelAudioPlayerState {
  Duration audioPosition = const Duration();
  Duration audioLength = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool pause = false;
  int? indexAudio;
  bool repeatAudio = false;
  int lengthAudio = 0;
}

class ViewModelAudioPlayer with ChangeNotifier {
  final _ViewModelAudioPlayerState _state = _ViewModelAudioPlayerState();
  _ViewModelAudioPlayerState get state => _state;

  String audioLengthSecond() =>
      twoDigits(_state.audioLength.inSeconds.remainder(60));
  String audioLengthMinutes() =>
      twoDigits(_state.audioLength.inMinutes.remainder(60));
  String audioPositionSecond() =>
      twoDigits(_state.audioPosition.inSeconds.remainder(60));
  String audioPositionMinutes() =>
      twoDigits(_state.audioPosition.inMinutes.remainder(60));

  void share(paths) {
    Share.shareFiles([paths]);
  }

  void toogleRepeatAudio(int lengthAudio) {
    if (lengthAudio == 0) return;
    if (_state.repeatAudio) {
      _state.repeatAudio = false;
      stop();

      notifyListeners();
    } else {
      _state.repeatAudio = true;
      setPlayingIndex(0);
      _state.lengthAudio = lengthAudio;

      notifyListeners();
    }
  }

  void nextAudio(int max) {
    _state.audioPlayer.release();

    int maxLength = max - 1;
    if (_state.indexAudio == maxLength) {
      _state.indexAudio = 0;
      notifyListeners();
    } else {
      if (_state.indexAudio != null) _state.indexAudio = _state.indexAudio! + 1;
      notifyListeners();
    }
  }

  Future<void> setAudioUrl(String audio, bool isLocal) async {
    if (audio.isEmpty) return;
    _state.audioPlayer = AudioPlayer();

    await _state.audioPlayer.setUrl(audio, isLocal: isLocal);
    play(audio);

    _state.audioPlayer.onDurationChanged.listen((d) {
      _state.audioLength = d;
      notifyListeners();
    });
    _state.audioPlayer.onAudioPositionChanged.listen((p) {
      _state.audioPosition = p;
      notifyListeners();
    });

    _state.audioPlayer.onPlayerCompletion.listen((e) {
      if (_state.repeatAudio) {
        nextAudio(_state.lengthAudio);
      } else {
        _state.audioPosition = const Duration(microseconds: 0);
        _state.isPlaying = false;
        _state.indexAudio = null;
        notifyListeners();
      }
    });
  }

  Future<void> setLocalAudio(String audio, bool isLocal) async {
    if (audio.isEmpty) return;

    await _state.audioPlayer.setUrl(audio, isLocal: isLocal);

    _state.audioPlayer.onDurationChanged.listen((d) {
      _state.audioLength = d;
      notifyListeners();
    });
    _state.audioPlayer.onAudioPositionChanged.listen((p) {
      _state.audioPosition = p;
      notifyListeners();
    });
    _state.audioPlayer.onPlayerCompletion.listen((_) {
      _state.audioPosition = const Duration(microseconds: 0);
      _state.isPlaying = false;
      _state.indexAudio = null;
      notifyListeners();
    });
  }

  void play(String audio) async {
    if (audio.isEmpty) return;
    await _state.audioPlayer.play(audio);
    _state.isPlaying = true;
    _state.pause = false;
  }

  void resume() {
    _state.audioPlayer.resume();
    _state.pause = false;
    notifyListeners();
  }

  void pause() {
    _state.audioPlayer.pause();
    _state.pause = true;
    notifyListeners();
  }

  void setPlayingIndex(int index) {
    _state.audioPlayer.release();

    _state.indexAudio = index;
    _state.isPlaying = true;
    notifyListeners();
  }

  void stop() {
    _state.audioPlayer.stop();
    _state.isPlaying = false;
    _state.indexAudio = null;
    notifyListeners();
  }

  void sekToSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    _state.audioPlayer.seek(newPosition);
    notifyListeners();
  }

  void secDown() {
    if (_state.audioPosition.inSeconds >= 15) {
      _state.audioPlayer.seek(
        _state.audioPosition - const Duration(seconds: 15),
      );
      notifyListeners();
    } else {
      _state.audioPlayer.seek(
        _state.audioPosition = const Duration(seconds: 0),
      );
      notifyListeners();
    }
  }

  void secUp() {
    if ((_state.audioPosition.inSeconds - _state.audioLength.inSeconds) <=
        -15) {
      _state.audioPlayer.seek(
        _state.audioPosition + const Duration(seconds: 15),
      );
      notifyListeners();
    } else {
      _state.audioPlayer.seek(
        _state.audioPosition =
            Duration(seconds: _state.audioLength.inSeconds - 0),
      );
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _state.audioPlayer.stop();
    _state.audioPlayer.dispose();
    super.dispose();
  }
}
