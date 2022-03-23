///purplay.dart
///Custom Colors => Primary Swatch

import 'package:flutter/material.dart';

class Purplay {
  static const MaterialColor kToDark = const MaterialColor(
    0xff4c1a54, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff947698), //10%
      100: const Color(0xff947698), //20%
      200: const Color(0xff704876), //30%
      300: const Color(0xff684876), //40%
      400: const Color(0xff6f4876), //50%
      500: const Color(0xff4f1a54), //60%
      600: const Color(0xff4f1a54), //70%
      700: const Color(0xff5f3165), //80%
      800: const Color(0xff5f1a54), //90%
      900: const Color(0xff4c1a54), //100%
    },
  );
}
