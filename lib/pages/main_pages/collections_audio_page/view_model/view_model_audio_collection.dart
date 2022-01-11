import 'package:flutter/material.dart';

class _ViewModelCollectionAudioState {
  bool detailsMore = false;
}

class ViewModelCollectionAudio with ChangeNotifier {
  final _ViewModelCollectionAudioState _state =
      _ViewModelCollectionAudioState();
  _ViewModelCollectionAudioState get state => _state;

  void showMore() {
    if (_state.detailsMore) {
      _state.detailsMore = false;
      notifyListeners();
    } else {
      _state.detailsMore = true;
      notifyListeners();
    }
  }
}
