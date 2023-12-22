import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Comfortaa',
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey[300]!,
  dividerColor: Colors.teal,
  datePickerTheme: const DatePickerThemeData(
      headerBackgroundColor: Colors.teal,
      dayOverlayColor: MaterialStatePropertyAll(Colors.teal)),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.teal),
  drawerTheme: DrawerThemeData(backgroundColor: Colors.grey[300]!),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[300]!,
    foregroundColor: Colors.black,
  ),
  cardTheme: const CardTheme(color: Colors.white),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
  colorScheme: ColorScheme.light(
    background: Colors.grey[300]!,
    primary: Colors.black,
    secondary: Colors.grey[200]!,
    tertiary: Colors.teal,
  ),
);
