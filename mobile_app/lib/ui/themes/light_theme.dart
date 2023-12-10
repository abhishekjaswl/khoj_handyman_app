import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Comfortaa',
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey[300]!,
  drawerTheme: DrawerThemeData(
    backgroundColor: Colors.grey[300]!,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[300]!,
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
