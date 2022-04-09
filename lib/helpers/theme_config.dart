import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/pallete/deepBlue.dart';

ThemeData lightTheme = ThemeData.light();

ThemeData darkTheme = ThemeData.dark();

ThemeData dayTheme = ThemeData(
  brightness: Brightness.light,
  cursorColor: DeepBlue.kToDark,
  fontFamily: 'Lato',
  primaryColor: DeepBlue.kToDark,
  accentColor: Colors.deepOrange,
  appBarTheme: AppBarTheme(
    backgroundColor: DeepBlue.kToDark,
  ),
  iconTheme: IconThemeData(
    color: DeepBlue.kToDark,
  ),
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.deepOrange,
    selectionColor: Colors.deepOrange,
    selectionHandleColor: Colors.deepOrange,
  ),
    colorScheme: ColorScheme(
      background: Colors.white,
      onBackground: Colors.white,
      brightness: Brightness.light,
      primaryVariant: DeepBlue.kToDark,
      primary: DeepBlue.kToDark,
      secondaryVariant: Colors.deepOrange,
      secondary: Colors.deepOrange,
      surface: Colors.white,
      onSurface: Colors.white,
      error: Colors.red,
      onError: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.deepOrange,
    ),
);

ThemeData nightTheme = ThemeData(
  cursorColor: Colors.deepOrange,
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.deepOrange,
    selectionColor: Colors.deepOrange,
    selectionHandleColor: Colors.deepOrange,
  ),
  fontFamily: 'Lato',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  splashColor: Colors.black,
  backgroundColor: Colors.black,
  primaryColor: DeepBlue.kToDark,
  accentColor: Colors.deepOrange,
  cardColor: DeepBlue.kToDark.shade500,
  colorScheme: ColorScheme(
    background: DeepBlue.kToDark,
    onBackground: Colors.white,
    brightness: Brightness.dark,
    primaryVariant: DeepBlue.kToDark,
    primary: DeepBlue.kToDark,
    secondaryVariant: Colors.deepOrange,
    secondary: Colors.deepOrange,
    surface: Colors.white,
    onSurface: Colors.white,
    error: Colors.red,
    onError: Colors.red,
    onPrimary: DeepBlue.kToDark,
    onSecondary: Colors.deepOrange,
  ),
  canvasColor: Colors.black,
  iconTheme: IconThemeData(
    color: Colors.deepOrange,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: DeepBlue.kToDark,
  ),
);
