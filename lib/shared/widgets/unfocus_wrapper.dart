// lib/core/utils/unfocus_extension.dart
import 'package:flutter/material.dart';

/// Widget that unfocuses when tapping outside text fields
class UnfocusWrapper extends StatelessWidget {
  const UnfocusWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Unfocus when tapping outside any text field
        FocusManager.instance.primaryFocus?.unfocus();

        // Alternative: Unfocus specific context
        // FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.deferToChild,
      child: child,
    );
  }
}
