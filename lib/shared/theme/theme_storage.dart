import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/core/services/storage_adapter.dart';

final themeStorageProvider = Provider<ThemeStorage>((ref) {
  final storage = ref.read(storageProvider);
  return ThemeStorage(storage);
});

class ThemeStorage {
  const ThemeStorage(this.storage);
  final StorageAdapter storage;

  static const rootKey = 'theme';
  static const modeKey = '$rootKey.mode';

  Future<void> saveThemeMode(ThemeMode mode) async {
    await storage.save(modeKey, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final saved = await storage.getString(modeKey);
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
