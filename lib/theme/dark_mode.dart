import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  fontFamily: "Raleway",
  colorScheme: ColorScheme.dark(
    // background: Colors.grey.shade900,
    // primary: Colors.grey.shade800,
    // secondary: Colors.grey.shade700,
    // tertiary: Colors.grey.shade400,
    // inversePrimary: Colors.grey.shade300,
    background: Color(0xFF091413),
    primary: Color(0xFF285A48),
    secondary: Color(0xFF408A71),
    tertiary: Color(0xFFB0E4CC),
    inversePrimary: Color.fromARGB(255, 24, 36, 34),
    // inversePrimary: Color.fromARGB(255, 33, 46, 43),
  ),
  textTheme: ThemeData.dark().textTheme.apply(
    bodyColor: Colors.grey.shade300,
    displayColor: Colors.white,
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white),
  ),
);

// 091413
// 285A48
// 408A71
// B0E4CC
