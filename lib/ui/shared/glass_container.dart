import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final double blur;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Border? border;

  const GlassContainer({
    super.key,
    required this.child,
    this.radius = 16.0,
    this.blur = 10.0,
    this.color,
    this.padding,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: color ?? Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(radius),
            border:
                border ??
                Border.all(color: Colors.white.withOpacity(0.1), width: 1.0),
          ),
          child: child,
        ),
      ),
    );
  }
}
