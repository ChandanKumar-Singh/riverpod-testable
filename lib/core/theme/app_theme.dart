import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:testable/core/theme/app_colors.dart';

class AppTheme {
  static ThemeData get darkTheme {
    final colors = AppColors.dark();

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: colors.bgPrimary,
      primaryColor: colors.accentPrimary,

      // Font Family
      fontFamily: GoogleFonts.inter().fontFamily,

      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: colors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: colors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colors.accentPrimary,
        ),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: colors.bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colors.bgTertiary),
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: colors.textPrimary,
        ),
        iconTheme: IconThemeData(color: colors.textSecondary),
      ),

      // Extensions
      extensions: [colors],
    );
  }

  // Compatibility Proxies
  // NOTE: Duplicated from AppColors to support legacy 'const' requirements in default parameters
  static const Color accentCyan = Color(0xFF00D1FF);
  static const Color accentPrimary = Color(0xFF6C5DD3);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color bgPrimary = Color(0xFF0F1115);
}
