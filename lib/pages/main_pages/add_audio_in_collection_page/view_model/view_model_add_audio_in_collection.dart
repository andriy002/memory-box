import 'package:flutter/material.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';

class _ViewModelAddAudioInColectionState {
  Map<String, bool> collectionMap = {};
  bool selected = false;
}

class ViewModelAddAudioInColection with ChangeNotifier {
  final _ViewModelAddAudioInColectionState _state =
      _ViewModelAddAudioInColectionState();
  _ViewModelAddAudioInColectionState get state => _state;
  final CollectionsRepositories _collectionRepo =
      CollectionsRepositories.instance;

  void addCollectionToMap(String name) {
    _state.collectionMap[name] = true;
    notifyListeners();
  }

  void addAudioToCollectionList(Map uid) {
    List uidAudio = [];
    uid.forEach((key, value) {
      uidAudio.add(key);
    });

    List col = [];
    _state.collectionMap.forEach((key, value) {
      col.add(key);
    });

    for (String element in uidAudio) {
      _collectionRepo.addAudioInCollectionList(col, element);
    }
  }

  void removeCollectionInMap(String audio) {
    _state.collectionMap.remove(audio);
    notifyListeners();
  }
}
