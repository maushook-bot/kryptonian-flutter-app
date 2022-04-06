import 'package:flutter/material.dart';

class Light with ChangeNotifier {
  bool _isDark = false;

  bool get themeDark => _isDark;

  void toggleLights() {
    _isDark = !_isDark;
    notifyListeners();
  }
}
