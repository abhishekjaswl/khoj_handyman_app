import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  fontFamily: 'Comfortaa',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  datePickerTheme: const DatePickerThemeData(
      headerBackgroundColor: Colors.teal,
      dayOverlayColor: MaterialStatePropertyAll(Colors.teal)),
  progressIndicatorTheme: const ProgressIndicatorThemeData(color: Colors.teal),
  drawerTheme: const DrawerThemeData(backgroundColor: Colors.black),
  appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
  cardTheme: CardTheme(
      color: Colors.grey[900]!,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)))),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  colorScheme: ColorScheme.dark(
    background: Colors.grey[900]!,
    primary: Colors.white,
    secondary: Colors.grey[700]!,
    tertiary: Colors.teal,
  ),
);
