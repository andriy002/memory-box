import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:memory_box/repositories/audio_repositories.dart';
import 'package:http/http.dart' as http;
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/repositories/deleted_audio_repositories.dart';
import 'package:memory_box/repositories/user_repositories.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';

class _ViewModelAudioState {
  int? indexRename;
  String? audioName;
  String searchKey = '';
  bool ckeckBool = false;
  int? indexCheck;
  Map<String, bool> audioMap = {};

  bool selected = false;
}

class ViewModelAudio with ChangeNotifier {
  final _ViewModelAudioState _state = _ViewModelAudioState();
  _ViewModelAudioState get state => _state;
  final AudioRepositories _audioRepo = AudioRepositories.instance;
  final CollectionsRepositories _collectionRepo =
      CollectionsRepositories.instance;
  final DeletedAudioRepositories _deletedAudioRepo =
      DeletedAudioRepositories.instance;
  final UsersRepositories _userRepo = UsersRepositories.instance;

  void setIndexReanme(int index) {
    _state.indexRename = index;
    notifyListeners();
  }

  bool checkAuthUser() {
    return _userRepo.checkAuthUser();
  }

  void selected() {
    if (_state.selected) {
      _state.selected = false;
      notifyListeners();
    } else {
      _state.selected = true;
      notifyListeners();
    }
  }

  void removeAudioList() {
    if (_state.audioMap.isEmpty) return;
    _state.audioMap.forEach((key, value) {
      _audioRepo.sendAudioToDeleteColection(key);
    });
  }

  void removeCollectionAudioList(String name) {
    if (_state.audioMap.isEmpty) return;
    _state.audioMap.forEach((key, value) {
      _collectionRepo.deleteAudioInCollections(key, [name]);
    });
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
      _collectionRepo.addAudioInCollection(nameCollection, key);
    });
  }

  void sendAudioToDeleteColection(String uid) {
    _audioRepo.sendAudioToDeleteColection(uid);
  }

  void deletedAudioInStorage(String doc) {
    _deletedAudioRepo.deletedAudioInStorage(doc);
  }

  void deletedAudioInStorageList() {
    if (_state.audioMap.isEmpty) return;
    _state.audioMap.forEach((key, value) {
      _deletedAudioRepo.deletedAudioInStorage(key);
    });
  }

  void restoreAudioList() {
    if (_state.audioMap.isEmpty) return;
    _state.audioMap.forEach((key, value) {
      _deletedAudioRepo.restoreAudio(key);
    });
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
