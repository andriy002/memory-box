import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memory_box/repositories/coolections_repositories.dart';

class _ViewModelCollectionAudioState {
  bool detailsMore = false;
  bool editCollecrion = false;
  String? displayName;
  String? discrition;
  File? image;
  String? description;
}

class ViewModelCollectionAudio with ChangeNotifier {
  final _ViewModelCollectionAudioState _state =
      _ViewModelCollectionAudioState();
  _ViewModelCollectionAudioState get state => _state;

  final CollectionsRepositories _collectionRepo =
      CollectionsRepositories.instance;

  void showMore() {
    if (_state.detailsMore) {
      _state.detailsMore = false;
      notifyListeners();
    } else {
      _state.detailsMore = true;
      notifyListeners();
    }
  }

  void editDisplayName(String displayName) {
    _state.displayName = displayName;
    notifyListeners();
  }

  void editDescription(String descriprion) {
    _state.description = descriprion;
    notifyListeners();
  }

  void editCollectionToogle() {
    if (_state.editCollecrion) {
      _state.editCollecrion = false;
      _state.detailsMore = false;
      _state.displayName = null;
      _state.image = null;
      _state.description = null;
      notifyListeners();
    } else {
      _state.editCollecrion = true;
      _state.detailsMore = true;

      notifyListeners();
    }
  }

  Future<void> updateCollection(String nameCollection) async {
    if (_state.displayName != null) {
      _collectionRepo.updateCollectionDisplayName(
          nameCollection, _state.displayName!);
    }
    if (_state.description != null) {
      _collectionRepo.updateCollectionDescription(
          nameCollection, _state.description!);
    }
    if (_state.image != null) {
      _collectionRepo.updateImage(nameCollection, _state.image!);
    }
  }

  void deleteCollection(String name) {
    _collectionRepo.deletedAudioInCollection([name]);
    _collectionRepo.deleteCollection(name);
  }

  Future<void> imagePicker() async {
    try {
      final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 720,
        maxWidth: 720,
      );
      if (image == null) return;

      final _lmageTemporary = File(image.path);
      _state.image = _lmageTemporary;

      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
