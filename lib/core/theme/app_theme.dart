import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundBlack = Color(0xFF050505);
  static const Color surfaceGlass = Color(0x1AFFFFFF); // 10% white
  static const Color accentCyan = Color(0xFF00F0FF);
  static const Color accentMagenta = Color(0xFFFF003C);
  static const Color textWhite = Color(0xFFEEEEEE);
  static const Color textGrey = Color(0xFF888888);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundBlack,
      primaryColor: accentCyan,

      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: textWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          fontFamily: 'Roboto', // Fallback, assume Inter/Orbitron later
        ),
        bodyLarge: TextStyle(
          color: textWhite,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          color: accentCyan,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.0,
        ),
      ),

      colorScheme: const ColorScheme.dark(
        primary: accentCyan,
        secondary: accentMagenta,
        surface: surfaceGlass,
        background: backgroundBlack,
      ),

      useMaterial3: true,
    );
  }
}
