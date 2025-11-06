import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testable/core/di/providers.dart';
import '../../core/services/local_storage_adapter.dart';

final themeStorageProvider = Provider<ThemeStorage>((ref) {
  final storage = ref.read(storageProvider);
  return ThemeStorage(storage);
});

class ThemeStorage {
  final LocalStorage storage;
  const ThemeStorage(this.storage);

  static const _key = 'theme_mode';

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_key);
    switch (saved) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }
}
