import 'package:flutter/material.dart';

// Singleton, upravlja zeljenom temom
class ThemeManager extends ChangeNotifier {
  static final ThemeManager _instance = ThemeManager._internal();
  ThemeMode _themeMode = ThemeMode.light;

  // getter za ThemeManager
  factory ThemeManager() {
    return _instance;
  }

  // privatni konstruktor
  ThemeManager._internal();

  // geteri i seteri za temu
  get themeMode => _themeMode;

  toggleTheme() {
    _themeMode =
        (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  changeTheme(bool isDark) {
    _themeMode = (isDark) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
