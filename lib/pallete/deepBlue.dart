///deepBlue.dart
///Custom Colors => Primary Swatch

import 'package:flutter/material.dart';

class DeepBlue {
  static const MaterialColor kToDark = const MaterialColor(
    0xff152238, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff23395d), //10%
      100: const Color(0xff23395d), //20%
      200: const Color(0xff203354), //30%
      300: const Color(0xff1c2e4a), //40%
      400: const Color(0xff192841), //50%
      500: const Color(0xff152238), //60%
      600: const Color(0xff152238), //70%
      700: const Color(0xff012023), //80%
      800: const Color(0xff001012), //90%
      900: const Color(0xff000000), //100%
    },
  );
}
