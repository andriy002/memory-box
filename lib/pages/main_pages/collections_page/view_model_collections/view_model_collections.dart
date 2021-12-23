import 'package:flutter/material.dart';

class _ViewModelCoolectionsState {
  bool openCollection = false;
  int currentIndex = 0;
  String? nameCollections;
  String? dispalyNameCollections;
  String? imgCollections;
  String? lengthCollections;
  String? descriptionCollections;
}

class ViewModelCoolections with ChangeNotifier {
  final _ViewModelCoolectionsState _state = _ViewModelCoolectionsState();
  _ViewModelCoolectionsState get state => _state;

  void openCollections() {
    _state.openCollection = true;
    notifyListeners();
  }

  void nameCollections(String nameCollections) {
    if (nameCollections.isEmpty) return;
    _state.nameCollections = nameCollections;
    notifyListeners();
  }

  void sendInfoCollecion(
      {required String? displayNameCollections,
      required String? descriptionCollections,
      required String? lengthCollections,
      required String? imgCollections}) {
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
}
