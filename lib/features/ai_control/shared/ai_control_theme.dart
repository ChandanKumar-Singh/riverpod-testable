import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_colors.dart';

class AIControlTheme {
  static const double glassOpacity = 0.08;
  static const double blurSigma = 12.0;
  static const double cardRadius = 16.0;

  static BoxDecoration glassDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.appColors.bgSecondary.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(cardRadius),
      border: Border.all(
        color: context.appColors.bgTertiary.withValues(alpha: 0.5),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static LinearGradient accentGradient(BuildContext context) {
    return LinearGradient(
      colors: [
        context.appColors.accentPrimary,
        context.appColors.accentSecondary,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static TextStyle headingStyle(BuildContext context) {
    return TextStyle(
      color: context.appColors.textPrimary,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    );
  }

  static TextStyle subHeadingStyle(BuildContext context) {
    return TextStyle(
      color: context.appColors.textTertiary,
      fontSize: 12,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.5,
    );
  }
}
