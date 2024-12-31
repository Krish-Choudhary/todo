import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  Brightness _themeMode = Brightness.dark;

  Brightness get themeMode => _themeMode;

  void setTheme(Brightness newThemeMode) {
    _themeMode = newThemeMode;
    notifyListeners();
  }
}