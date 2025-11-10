import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/services/storage_adapter.dart';

final themeStorageProvider = Provider<ThemeStorage>((ref) {
  final storage = ref.read(storageProvider);
  return ThemeStorage(storage);
});

class ThemeStorage {
  final StorageAdapter storage;
  const ThemeStorage(this.storage);

  static const _key = 'theme_mode';

  Future<void> saveThemeMode(ThemeMode mode) async {
    await storage.save(_key, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final saved = await storage.getString(_key);
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
