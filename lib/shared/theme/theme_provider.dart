import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/utils/toasts/toasts.dart';
import 'package:testable/shared/theme/theme_storage.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._storage) : super(ThemeMode.system) {
    _initialize();
  }
  final ThemeStorage _storage;
  late final Future<void> _initialization;

  Future<void> _initialize() async {
    _initialization = _load();
    await _initialization;
  }

  Future<void> _load() async {
    final mode = await _storage.loadThemeMode();
    state = mode;
  }

  Future<void> setTheme(ThemeMode mode) async {
    await _initialization; // Wait for initialization to complete
    state = mode;
    await _storage.saveThemeMode(mode);
  }

  Future<void> toggle({bool toast = true}) async {
    await _initialization; // Wait for initialization to complete

    if (state == ThemeMode.light) {
      await setTheme(ThemeMode.dark);
    } else {
      await setTheme(ThemeMode.light);
    }
    /* if (toast) {
      AppToastification.success(
        'Switched to ${state.name} mode.',
        title: 'Theme Changed',
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 40),
      );
    } */
  }

  // Helper to wait for initialization in tests
  @visibleForTesting
  Future<void> waitForInitialization() => _initialization;
}
