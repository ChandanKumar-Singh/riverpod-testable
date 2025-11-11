// FEATURE: Theme Provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/utils/toasts/toasts.dart';
import 'package:testable/shared/theme/theme_storage.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._storage) : super(ThemeMode.system) {
    _load();
  }
  final ThemeStorage _storage;

  Future<void> _load() async {
    final mode = await _storage.loadThemeMode();
    state = mode;
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await _storage.saveThemeMode(mode);
  }

  Future<void> toggle() async {
    if (state == ThemeMode.light) {
      await setTheme(ThemeMode.dark);
    } else {
      await setTheme(ThemeMode.light);
    }
    AppToastification.success('Theme changed to ${state.name}');
  }
}
