import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class _ViewModelAudioState {
  int? indexRename;
  String? audioName;
  String searchKey = '';
  Set<String> audioList = {};
  bool ckeckBool = false;
  int? indexCheck;
  Map<String, bool> audioMap = {};
}

class ViewModelAudio with ChangeNotifier {
  final _ViewModelAudioState _state = _ViewModelAudioState();
  _ViewModelAudioState get state => _state;
  final AudioRepositories _audioRepo = AudioRepositories.instance;

  void setIndexReanme(int index) {
    _state.indexRename = index;
    notifyListeners();
  }

  void searchKeyInput(String searchKey) {
    _state.searchKey = searchKey;
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

  void addAudioToMap(String audio) {
    _state.audioMap[audio] = true;
    notifyListeners();
  }

  void removeAudioInMap(String audio) {
    _state.audioMap.remove(audio);
    notifyListeners();
  }

  void addAudioToCollection(String nameCollection) {
    _state.audioMap.forEach((key, value) {
      _audioRepo.addAudioInCollection(nameCollection, key);
    });
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
}
