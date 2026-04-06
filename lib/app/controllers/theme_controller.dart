import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../core/constants/storage_keys.dart';

class ThemeController extends GetxController {
  ThemeController([GetStorage? storage]) : _storage = storage ?? GetStorage();

  final GetStorage _storage;
  final themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeMode();
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;

  void toggleTheme() {
    final nextMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    themeMode.value = nextMode;
    _storage.write(StorageKeys.themeMode, nextMode.name);
    Get.changeThemeMode(nextMode);
  }

  void _loadThemeMode() {
    final savedMode = _storage.read<String>(StorageKeys.themeMode);
    themeMode.value = savedMode == ThemeMode.dark.name
        ? ThemeMode.dark
        : ThemeMode.light;
  }
}
