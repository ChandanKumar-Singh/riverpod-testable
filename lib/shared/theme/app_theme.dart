import 'package:flutter/material.dart';

part 'theme_builder.dart';
// Usage examples:
class AppTheme {
  static final light = AppThemeBuilder(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  ).build();

  static final dark = AppThemeBuilder(
    seedColor: Colors.indigo,
    brightness: Brightness.dark,
  ).build();

  // Custom themes
  static final blueLight = AppThemeBuilder(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ).build();

  static final purpleDark = AppThemeBuilder(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ).build();

  static final tealLight = AppThemeBuilder(
    seedColor: Colors.teal,
    brightness: Brightness.light,
    fontFamily: 'Inter',
  ).build();
}
