// FEATURE: Lang Provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'lang_storage.dart';
import 'supported_locales.dart';


class LangNotifier extends StateNotifier<Locale> {
  final LangStorage _storage;

  LangNotifier(this._storage) : super(SupportedLocales.en) {
    _load();
  }

  Future<void> _load() async {
    final locale = await _storage.loadLocale();
    state = locale;
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    await _storage.saveLocale(locale);
  }

  Future<void> nextLocale() async {
    final all = SupportedLocales.all;
    final currentIndex = all.indexWhere(
      (l) => l.languageCode == state.languageCode,
    );
    final next = all[(currentIndex + 1) % all.length];
    await setLocale(next);
  }
}
