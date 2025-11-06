import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/core/services/local_storage_adapter.dart';

final langStorageProvider = Provider<LangStorage>((ref) {
  final storage = ref.watch(storageProvider);
  return LangStorage(storage);
});

class LangStorage {
  final LocalStorage storage;
  LangStorage(this.storage);
  static const _key = 'language_code';

  Future<void> saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, locale.languageCode);
  }

  Future<Locale> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_key);
    if (code == null) return const Locale('en');
    return Locale(code);
  }
}
