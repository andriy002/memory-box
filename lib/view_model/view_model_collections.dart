import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';

class _ViewModelCoolectionsState {
  bool openSearchAudio = false;

  int currentIndex = 0;

  String? newCollectionName;
  String? newCollectionDescription;
  File? imageUrl;
  bool error = false;
  Map<String, bool> collectionMap = {};

  bool selected = false;

  String? nameCollections;
}

class ViewModelCoolections with ChangeNotifier {
  final _ViewModelCoolectionsState _state = _ViewModelCoolectionsState();
  _ViewModelCoolectionsState get state => _state;
  final CollectionsRepositories _collectionRepo =
      CollectionsRepositories.instance;

  void nameCollections(String nameCollections) {
    if (nameCollections.isEmpty) return;
    _state.nameCollections = nameCollections;
    notifyListeners();
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

  void addCollectionToMap(String name) {
    _state.collectionMap[name] = true;
    notifyListeners();
  }

  void addAudioToCollection(String uid) {
    _state.collectionMap.forEach((key, value) {
      _collectionRepo.addAudioInCollection(key, uid);
    });
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

  set setCurrentIndex(int inx) {
    if (_state.currentIndex != inx) {
      _state.currentIndex = inx;
      notifyListeners();
    }
  }

  void setCollectionName(String name) {
    _state.newCollectionName = name;
    notifyListeners();
  }

  void setCollectionDescription(String description) {
    _state.newCollectionDescription = description;
    notifyListeners();
  }

  Future<bool> createCollection() async {
    if (_state.imageUrl == null || _state.newCollectionName == null) {
      _state.error = true;
      notifyListeners();
      return _state.error;
    } else {
      _state.error = false;
      notifyListeners();

      final imageNameUrl =
          await _collectionRepo.updatePhoto(_state.newCollectionName ?? '');
      _collectionRepo.createNewCollection(_state.newCollectionName ?? '',
          _state.newCollectionDescription ?? '', imageNameUrl);
      deleteFields();
      return _state.error;
    }
  }

  void openAddAudioPage() {
    if (_state.openSearchAudio == false) {
      _state.openSearchAudio = true;
      _state.error = false;
      notifyListeners();
    } else {
      _state.openSearchAudio = false;
      notifyListeners();
    }
  }

  void removeSelected() {
    _collectionRepo.deletedAudioInCollection(['selected']);
  }

  void deletedCollection() {
    List colection = [];
    _state.collectionMap.forEach((key, value) {
      colection.add(key);
    });
    _collectionRepo.deletedAudioInCollection(colection);

    for (var element in colection) {
      _collectionRepo.deleteCollection(element);
      _state.collectionMap.remove(element);
    }
  }

  void deleteFields() {
    removeSelected();
    _state.error = false;
    _state.imageUrl = null;
    _state.newCollectionName = null;
    _state.newCollectionDescription = null;
  }

  Future<void> imagePicker() async {
    if (_state.newCollectionName == null) {
      _state.error = true;
      notifyListeners();
      return;
    }
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 720,
        maxWidth: 720,
      );
      if (image == null) return;

      final _lmageTemporary = File(image.path);
      _state.imageUrl = _lmageTemporary;
      _collectionRepo.uploadProfilePhoto(
          _lmageTemporary, _state.newCollectionName ?? '');

      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    removeSelected();
    super.dispose();
  }
}
