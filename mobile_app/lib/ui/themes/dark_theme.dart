import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Comfortaa',
  brightness: Brightness.dark,
  drawerTheme: const DrawerThemeData(
    backgroundColor: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.white,
    primary: Colors.white,
    secondary: Colors.grey[900]!,
  ),
);
