import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Investor-Grade Dark (Control Plane)
  static const _bgPrimary = Color(0xFF0F1115);
  static const _bgSecondary = Color(0xFF181B21);
  static const _bgTertiary = Color(0xFF232730);

  // Accents (Cyber-Security / AI Vibe)
  static const _accentPrimary = Color(0xFF6C5DD3); // Deep Purple
  static const _accentSecondary = Color(0xFF00D1FF); // Cyan
  static const _accentCritical = Color(0xFFFF4C61); // Red
  static const _accentSuccess = Color(0xFF3DD598); // Green
  static const _accentWarning = Color(0xFFFFB039); // Yellow

  // Text
  static const _textPrimary = Color(0xFFFFFFFF);
  static const _textSecondary = Color(0xFF8F9BB3);
  static const _textTertiary = Color(0xFF5A6B87);

  final Color bgPrimary;
  final Color bgSecondary;
  final Color bgTertiary;
  final Color accentPrimary;
  final Color accentSecondary;
  final Color accentCritical;
  final Color accentSuccess;
  final Color accentWarning;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  const AppColors({
    required this.bgPrimary,
    required this.bgSecondary,
    required this.bgTertiary,
    required this.accentPrimary,
    required this.accentSecondary,
    required this.accentCritical,
    required this.accentSuccess,
    required this.accentWarning,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
  });

  // Aliases for compatibility
  Color get accentCyan => accentSecondary;

  // Factory for the default "Dark Mode" locked theme
  factory AppColors.dark() {
    return const AppColors(
      bgPrimary: _bgPrimary,
      bgSecondary: _bgSecondary,
      bgTertiary: _bgTertiary,
      accentPrimary: _accentPrimary,
      accentSecondary: _accentSecondary,
      accentCritical: _accentCritical,
      accentSuccess: _accentSuccess,
      accentWarning: _accentWarning,
      textPrimary: _textPrimary,
      textSecondary: _textSecondary,
      textTertiary: _textTertiary,
    );
  }

  @override
  ThemeExtension<AppColors> copyWith({
    Color? bgPrimary,
    Color? bgSecondary,
    Color? bgTertiary,
    Color? accentPrimary,
    Color? accentSecondary,
    Color? accentCritical,
    Color? accentSuccess,
    Color? accentWarning,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
  }) {
    return AppColors(
      bgPrimary: bgPrimary ?? this.bgPrimary,
      bgSecondary: bgSecondary ?? this.bgSecondary,
      bgTertiary: bgTertiary ?? this.bgTertiary,
      accentPrimary: accentPrimary ?? this.accentPrimary,
      accentSecondary: accentSecondary ?? this.accentSecondary,
      accentCritical: accentCritical ?? this.accentCritical,
      accentSuccess: accentSuccess ?? this.accentSuccess,
      accentWarning: accentWarning ?? this.accentWarning,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      bgPrimary: Color.lerp(bgPrimary, other.bgPrimary, t)!,
      bgSecondary: Color.lerp(bgSecondary, other.bgSecondary, t)!,
      bgTertiary: Color.lerp(bgTertiary, other.bgTertiary, t)!,
      accentPrimary: Color.lerp(accentPrimary, other.accentPrimary, t)!,
      accentSecondary: Color.lerp(accentSecondary, other.accentSecondary, t)!,
      accentCritical: Color.lerp(accentCritical, other.accentCritical, t)!,
      accentSuccess: Color.lerp(accentSuccess, other.accentSuccess, t)!,
      accentWarning: Color.lerp(accentWarning, other.accentWarning, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
    );
  }
}

// Global helper for cleaner syntax: context.appColors.accentPrimary
extension AppColorsExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
