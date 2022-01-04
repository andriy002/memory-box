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

  String? nameCollections;
  String? dispalyNameCollections;
  String? imgCollections;
  int? lengthCollections;
  String? descriptionCollections;
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

  void sendInfoCollecion({
    required String? displayNameCollections,
    required String? descriptionCollections,
    required int? lengthCollections,
    required String? imgCollections,
  }) {
    _state.descriptionCollections = descriptionCollections;
    _state.dispalyNameCollections = displayNameCollections;
    _state.imgCollections = imgCollections;
    _state.lengthCollections = lengthCollections;
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

  void createCollection() async {
    if (_state.imageUrl == null || _state.newCollectionName == null) {
      _state.error = true;
      notifyListeners();
      return;
    }

    _state.error = false;
    setCurrentIndex = 0;
    notifyListeners();

    final imageNameUrl =
        await _collectionRepo.updatePhoto(_state.newCollectionName ?? '');
    _collectionRepo.createNewCollection(_state.newCollectionName ?? '',
        _state.newCollectionDescription ?? '', imageNameUrl);
    deleteFields();
  }

  void openAddAudioPage() {
    if (_state.openSearchAudio == false) {
      _state.openSearchAudio = true;
      notifyListeners();
    } else {
      _state.openSearchAudio = false;
      notifyListeners();
    }
  }

  void removeSelected() {
    _collectionRepo.deleteSelectedAudio();
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
