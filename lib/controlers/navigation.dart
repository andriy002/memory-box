import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  String screanName = '/';

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set setCurrentIndex(int inx) {
    if (_currentIndex != inx) {
      _currentIndex = inx;
      notifyListeners();
    }
  }
}
