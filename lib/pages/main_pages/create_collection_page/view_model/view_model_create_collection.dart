import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';

class _ViewModelCreateCoolectionsState {
  bool openSearchAudio = false;

  String? collectionName;
  String? collectionDescription;
  File? imageUrl;
  bool error = false;
  bool selected = false;
}

class ViewModelCreateCoolection with ChangeNotifier {
  final _ViewModelCreateCoolectionsState _state =
      _ViewModelCreateCoolectionsState();
  _ViewModelCreateCoolectionsState get state => _state;
  final CollectionsRepositories _collectionRepo =
      CollectionsRepositories.instance;

  void setCollectionName(String name) {
    _state.collectionName = name;
    notifyListeners();
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

  Future<bool> createCollection() async {
    if (_state.imageUrl == null || _state.collectionName == null) {
      _state.error = true;
      notifyListeners();
      return _state.error;
    } else {
      _state.error = false;
      notifyListeners();
      final imageUrl = await _collectionRepo.uploadImage(
          _state.imageUrl!, _state.collectionName!);
      _collectionRepo.createNewCollection(
          _state.collectionName!, _state.collectionDescription ?? '', imageUrl);
      deleteFields();
      return _state.error;
    }
  }

  void removeSelected() {
    _collectionRepo.deletedAudioInCollectionList(['selected']);
  }

  void setCollectionDescription(String description) {
    _state.collectionDescription = description;
    notifyListeners();
  }

  Future<void> imagePicker() async {
    if (_state.collectionName == null) {
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

      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void deleteFields() {
    removeSelected();
    _state.error = false;
    _state.imageUrl = null;
    _state.collectionName = null;
    _state.collectionDescription = null;
  }
}
