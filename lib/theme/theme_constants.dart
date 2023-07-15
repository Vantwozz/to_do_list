import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFF7F6F2),
  appBarTheme: const AppBarTheme(
    color: Color(0xFFF7F6F2),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF007AFF),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF007AFF),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      color: Colors.black,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      color: Color.fromRGBO(0, 0, 0, 0.3),
    ),
    headlineMedium: TextStyle(
      color: Color(0xFFFF3B30),
    ),
    titleSmall: TextStyle(
      color: Color.fromRGBO(0, 0, 0, 0.15),
    ),
  ),
  canvasColor: const Color.fromRGBO(255, 255, 255, 1),
  dividerColor: const Color.fromRGBO(0, 0, 0, 0.1),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF161618),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF161618),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFF0A84FF),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF0A84FF),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32,
      color: Colors.white,
    ),
    headlineSmall: TextStyle(
      fontSize: 16,
      color: Color.fromRGBO(255, 255, 255, 0.4),
    ),
    headlineMedium: TextStyle(
      color: Color(0xFFFF453A),
    ),
    titleSmall: TextStyle(
      color: Color.fromRGBO(255, 255, 255, 0.15),
    ),
  ),
  canvasColor: const Color(0xFF252528),
  dividerColor: const Color.fromRGBO(255, 255, 255, 0.1),
);
