import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Comfortaa',
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey[300]!,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey[300]!,
    primary: Colors.black,
    secondary: Colors.grey[200]!,
  ),
);
