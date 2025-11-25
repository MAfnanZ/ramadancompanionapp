import 'package:flutter/material.dart';

ThemeData normalTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.green,
      primary: Colors.green,
      secondary: Colors.greenAccent,
      tertiary: Colors.lightGreen,
      inversePrimary: Colors.lightGreenAccent,
    ),
    scaffoldBackgroundColor: Colors.lightGreen,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.lightGreen,
      foregroundColor: Colors.white,
    ));
