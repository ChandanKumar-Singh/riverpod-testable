// FEATURE: Lang Provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/shared/localization/lang_storage.dart';
import 'package:testable/shared/localization/supported_locales.dart';

class LangNotifier extends StateNotifier<Locale> {
  LangNotifier(this._storage) : super(SupportedLocales.en) {
    _load();
  }
  final LangStorage _storage;

  Future<void> _load() async {
    final locale = await _storage.loadLocale();
    state = locale;
  }

  Future<void> setLocale(Locale locale) async {
    await _storage.saveLocale(locale);
    state = locale;
  }

  Future<void> nextLocale() async {
    const all = SupportedLocales.all;
    final currentIndex = all.indexWhere(
      (l) => l.languageCode == state.languageCode,
    );
    final next = all[(currentIndex + 1) % all.length];
    await setLocale(next);
  }
}
