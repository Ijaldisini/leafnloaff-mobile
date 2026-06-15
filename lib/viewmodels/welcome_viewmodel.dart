import 'package:flutter/material.dart';

class WelcomeViewModel extends ChangeNotifier {
  int _currentSlideIndex = 0;
  int get currentSlideIndex => _currentSlideIndex;

  void previousSlide() {
    if (_currentSlideIndex > 0) {
      _currentSlideIndex--;
      notifyListeners();
    }
  }

  bool onNextPressed() {
    if (_currentSlideIndex < 2) {
      _currentSlideIndex++;
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  void setSlideIndex(int index) {
    _currentSlideIndex = index;
    notifyListeners();
  }
}
