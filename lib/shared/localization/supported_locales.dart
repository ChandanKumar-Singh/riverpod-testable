import 'package:flutter/material.dart';

class SupportedLocales {
  static const en = Locale('en');
  static const hi = Locale('hi');
  static const es = Locale('es');

  static const all = [en, hi, es];

  static String localeName(Locale code) {
    switch (code.languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'हिन्दी';
      case 'es':
        return 'Español';
      default:
        return code.languageCode.toUpperCase();
    }
  }

  static String localeFlag(Locale code) {
    switch (code.languageCode) {
      case 'en':
        return '🇺🇸';
      case 'hi':
        return '🇮🇳';
      case 'es':
        return '🇪🇸';
      default:
        return '🌐';
    }
  }
}
