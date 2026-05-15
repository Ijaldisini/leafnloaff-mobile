import 'package:flutter/material.dart';
import 'package:leafnloaff/views/login_view.dart';

class WelcomeViewModel extends ChangeNotifier {
  int _currentSlideIndex = 0;
  int get currentSlideIndex => _currentSlideIndex;

  void onNextPressed(BuildContext context) {
    if (_currentSlideIndex < 2) {
      _currentSlideIndex++;
      notifyListeners();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  void setSlideIndex(int index) {
    _currentSlideIndex = index;
    notifyListeners();
  }
}
