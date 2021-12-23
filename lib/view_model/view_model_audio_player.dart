import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:memory_box/repositories/audio_repositories.dart';

import 'package:memory_box/utils/two_digits.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

class _ViewModelAudioPlayerState {
  Duration audioPosition = const Duration();
  Duration audioLength = const Duration();
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool pause = false;
  int? indexAudio;
  int? indexRename;
  String? audioName;
}

class ViewModelAudioPlayer with ChangeNotifier {
  final _ViewModelAudioPlayerState _state = _ViewModelAudioPlayerState();
  _ViewModelAudioPlayerState get state => _state;
  final AudioRepositories _audioRepo = AudioRepositories.instance;

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

  void setIndexReanme(int index) {
    _state.indexRename = index;
    notifyListeners();
  }

  void renameAudio(String uid, String audioName) {
    if (audioName.isEmpty) {
      _state.indexRename = null;
      notifyListeners();
      return;
    }
    _audioRepo.updateAudioName(uid, audioName);
    _state.indexRename = null;
    notifyListeners();
  }

  void sendAudioToDeleteColection(
    String audioName,
    String audioUrl,
    String duration,
    String uid,
  ) {
    _audioRepo.sendAudioDeleteColection(audioName, audioUrl, duration, uid);
  }

  Future<void> shareUrlFile(String url, String name) async {
    final urlParse = Uri.parse(url);
    final respose = await http.get(urlParse);
    final bytes = respose.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/$name.aac';
    File(path).writeAsBytes(bytes);
    await Share.shareFiles([path]);
  }

  void nextAudio(int max) {
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
    _state.audioPlayer.release();
    if (audio.isEmpty) return;
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
    // _state.audioPlayer.onAudioPositionChanged.listen((_) {

    // });

    _state.audioPlayer.onPlayerCompletion.listen((_) {
      _state.audioPosition = const Duration(microseconds: 0);
      _state.isPlaying = false;
      _state.indexAudio = null;
      notifyListeners();
    });
  }

  void a() {
    _audioRepo.a();
  }

  void play(String audio) async {
    if (audio.isEmpty) return;
    await _state.audioPlayer.play(audio);
    _state.isPlaying = true;
    _state.pause = false;

    notifyListeners();
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

// class _ViewModelAudioPlayerState {
//   Duration audioPosition = const Duration();
//   Duration audioLength = const Duration();
//   AudioPlayer audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   int? indexAudio;
// }

// class ViewModelAudioPlayer with ChangeNotifier {
//   final _ViewModelAudioPlayerState _state = _ViewModelAudioPlayerState();
//   _ViewModelAudioPlayerState get state => _state;

//   String audioLengthSecond() =>
//       twoDigits(_state.audioLength.inSeconds.remainder(60));
//   String audioLengthMinutes() =>
//       twoDigits(_state.audioLength.inMinutes.remainder(60));
//   String audioPositionSecond() =>
//       twoDigits(_state.audioPosition.inSeconds.remainder(60));
//   String audioPositionMinutes() =>
//       twoDigits(_state.audioPosition.inMinutes.remainder(60));

//   void share(paths) {
//     Share.shareFiles([paths]);
//   }

//   void setAudioLocal(String audio) {
//     _state.audioPlayer.setFilePath(audio);
//     _state.audioPlayer.positionStream.listen((p) {
//       _state.audioPosition = p;

//       notifyListeners();
//     });
//     _state.audioPlayer.durationStream.listen((d) {
//       _state.audioLength = d ?? const Duration(seconds: 0);
//       notifyListeners();
//     });
//   }



//   void play() {
//     _state.audioPlayer.play();
//     _state.isPlaying = true;
//     notifyListeners();
//   }

//   void setAudioUrl(String url) {
//     _state.audioPlayer.setUrl(url).then(
//           (_) => _state.audioPlayer.play(),
//         );
//   }

// //   await player.setAudioSource(
// //   ConcatenatingAudioSource(
// //     // Start loading next item just before reaching it.
// //     useLazyPreparation: true, // default
// //     // Customise the shuffle algorithm.
// //     shuffleOrder: DefaultShuffleOrder(), // default
// //     // Specify the items in the playlist.
// //     children: [
// //       AudioSource.uri(Uri.parse("https://example.com/track1.mp3")),
// //       AudioSource.uri(Uri.parse("https://example.com/track2.mp3")),
// //       AudioSource.uri(Uri.parse("https://example.com/track3.mp3")),
// //     ],
// //   ),
// //   // Playback will be prepared to start from track1.mp3
// //   initialIndex: 0, // default
// //   // Playback will be prepared to start from position zero.
// //   initialPosition: Duration.zero, // default
// // );
// // await player.seekToNext();
// // await player.seekToPrevious();
// // // Jump to the beginning of track3.mp3.
// // await player.seek(Duration(milliseconds: 0), index: 2);

//   // if ((_state.audioPosition.inSeconds - _state.audioLength.inSeconds) ==
//   //     0) {
//   //   _state.audioPlayer.seek(const Duration(seconds: 0));
//   //   _state.isPlaying = false;
//   //   _state.indexAudio = null;
//   //   _state.audioPlayer.stop();
//   //   notifyListeners();
//   // }

//   void setPlayingIndex(int index) {
//     _state.indexAudio = index;
//     _state.isPlaying = true;
//     notifyListeners();
//   }

//   void printDuration() {
//     print(_state.audioPlayer.duration);
//   }

//   void stop() {
//     _state.audioPlayer.stop();
//     _state.audioPlayer.seek(const Duration(seconds: 0));

//     _state.isPlaying = false;
//     notifyListeners();
//   }

//   void sekToSec(int sec) {
//     Duration newPosition = Duration(seconds: sec);
//     _state.audioPlayer.seek(newPosition);
//     notifyListeners();
//   }

//   void secUp() {
//     if ((_state.audioPosition.inSeconds - _state.audioLength.inSeconds) <=
//         -15) {
//       _state.audioPlayer.seek(
//         _state.audioPosition + const Duration(seconds: 15),
//       );
//       notifyListeners();
//     } else {
//       _state.audioPlayer.seek(
//         _state.audioPosition =
//             Duration(seconds: _state.audioLength.inSeconds - 0),
//       );
//       notifyListeners();
//     }
//   }

//   void secDown() {
//     if (_state.audioPosition.inSeconds >= 15) {
//       _state.audioPlayer.seek(
//         _state.audioPosition - const Duration(seconds: 15),
//       );
//       notifyListeners();
//     } else {
//       _state.audioPlayer.seek(
//         _state.audioPosition = const Duration(seconds: 0),
//       );
//       notifyListeners();
//     }
//   }
// }
