import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = "isDarkMode";

  ThemeMode get themeMode =>
      _loadThemeFormBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFormBox() {
    return _box.read<bool>(_key) ?? false;
  }

  void _saveThemeToBox(bool isDarkMode) {
    _box.write(_key, isDarkMode);
  }

  void switchTheme() {
    bool status = _loadThemeFormBox();
    Get.changeThemeMode(status ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(!status);
  }
}
