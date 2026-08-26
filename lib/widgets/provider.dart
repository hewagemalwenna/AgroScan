import "package:flutter/material.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:agroscan/tools/app_theme.dart";

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

  final darkTheme = AgroScanTheme.dark();
  final lightTheme = AgroScanTheme.light();

  changeTheme() {
    _isDark = !isDark;
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }

  init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark") ?? false;
    notifyListeners();
  }
}
