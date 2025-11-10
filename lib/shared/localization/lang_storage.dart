import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/di/providers.dart';
import '../../core/services/storage_adapter.dart';

final langStorageProvider = Provider<LangStorage>((ref) {
  final storage = ref.watch(storageProvider);
  return LangStorage(storage);
});

class LangStorage {
  final StorageAdapter storage;
  LangStorage(this.storage);
  static const _key = 'language_code';

  Future<void> saveLocale(Locale locale) async {
    await storage.save(_key, locale.languageCode);
  }

  Future<Locale> loadLocale() async {
    final code = await storage.getString(_key);
    if (code == null) return const Locale('en');
    return Locale(code);
  }
}
