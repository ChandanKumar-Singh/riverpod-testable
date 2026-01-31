import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_theme.dart';

class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final bool isGlowing;

  const NeonText(
    this.text, {
    super.key,
    this.fontSize = 24.0,
    this.color = AppTheme.accentCyan,
    this.isGlowing = true,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: color,
        shadows: isGlowing
            ? [
                Shadow(
                  blurRadius: 10.0,
                  color: color,
                  offset: const Offset(0, 0),
                ),
                Shadow(
                  blurRadius: 20.0,
                  color: color.withOpacity(0.5),
                  offset: const Offset(0, 0),
                ),
              ]
            : [],
      ),
    );
  }
}
