import 'package:flutter/material.dart';

part 'theme_builder.dart';
// Usage examples:
class AppTheme {
   final light = AppThemeBuilder(
    seedColor: const Color.fromARGB(255, 47, 76, 239),
    brightness: Brightness.light,
  ).build();

   final dark = AppThemeBuilder(
    seedColor: const Color.fromARGB(255, 12, 112, 142),
    brightness: Brightness.dark,
  ).build();

  // Custom themes
   final blueLight = AppThemeBuilder(
    seedColor: Colors.blue,
    brightness: Brightness.light,
  ).build();

   final purpleDark = AppThemeBuilder(
    seedColor: Colors.purple,
    brightness: Brightness.dark,
  ).build();

   final tealLight = AppThemeBuilder(
    seedColor: Colors.teal,
    brightness: Brightness.light,
    fontFamily: 'Inter',
  ).build();
}
