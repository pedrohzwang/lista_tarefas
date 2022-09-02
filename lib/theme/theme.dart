import 'package:flutter/material.dart';

final theme = ThemeData(
  brightness: Brightness.dark,
  primaryColorLight: Colors.indigo.shade400,
  primaryColor: Colors.indigo,
  primaryColorDark: Colors.indigo.shade900,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    elevation: 10,
  ),
  disabledColor: Colors.grey.shade300,
  bottomAppBarColor: Colors.indigo,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.indigo,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.indigo.shade400,
    actionTextColor: Colors.yellow,
    disabledActionTextColor: Colors.grey.shade300,
  ),
);
