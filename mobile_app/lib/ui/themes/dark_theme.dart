import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  fontFamily: 'Comfortaa',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  cardTheme: CardTheme(color: Colors.grey[900]!),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.grey[900]!,
    primary: Colors.white,
    secondary: Colors.grey[500]!,
  ),
);
