///turquoise.dart
///Custom Colors => Primary Swatch

import 'package:flutter/material.dart';

class Turquoise {
  static const MaterialColor kToDark = const MaterialColor(
    0xff035f6a, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff058f9e), //10%
      100: const Color(0xff047f8d), //20%
      200: const Color(0xff046f7b), //30%
      300: const Color(0xff035f6a), //40%
      400: const Color(0xff035058), //50%
      500: const Color(0xff024046), //60%
      600: const Color(0xff013035), //70%
      700: const Color(0xff012023), //80%
      800: const Color(0xff001012), //90%
      900: const Color(0xff000000), //100%
    },
  );
}
