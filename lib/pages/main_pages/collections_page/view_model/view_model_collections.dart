import 'package:flutter/material.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';
import 'package:memory_box/repositories/user_repositories.dart';

class _ViewModelCoolectionsState {
  Map<String, bool> collectionMap = {};
  bool selected = false;
}

class ViewModelCoolections with ChangeNotifier {
  final _ViewModelCoolectionsState _state = _ViewModelCoolectionsState();
  _ViewModelCoolectionsState get state => _state;
  final CollectionsRepositories _collectionRepo =
      CollectionsRepositories.instance;
  final UsersRepositories _userRepo = UsersRepositories.instance;

  void selected() {
    if (_state.selected) {
      _state.selected = false;
      notifyListeners();
    } else {
      _state.selected = true;
      notifyListeners();
    }
  }

  bool checkAuthUser() {
    return _userRepo.checkAuthUser();
  }

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

  void deletedCollection() {
    List colection = [];
    _state.collectionMap.forEach((key, value) {
      colection.add(key);
    });
    _collectionRepo.deletedAudioInCollectionList(colection);

    for (var element in colection) {
      _collectionRepo.deletedCollection(element);
      _state.collectionMap.remove(element);
    }
  }
}
