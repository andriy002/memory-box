import 'package:flutter/material.dart';

class Navigation extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set setCurrentIndex(int inx) {
    if (_currentIndex != inx) {
      _currentIndex = inx;
      notifyListeners();
    }
  }
}
