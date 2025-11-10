import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/di/providers.dart';

class ThemeSwitcher extends ConsumerWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    final isDark = themeMode == ThemeMode.dark;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, animation) => RotationTransition(
        turns: Tween(begin: 0.75, end: 1.0).animate(animation),
        child: FadeTransition(opacity: animation, child: child),
      ),
      child: IconButton(
        key: ValueKey(isDark),
        icon: Icon(isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
        onPressed: () => ref.read(themeProvider.notifier).toggle(),
        tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      ),
    );
  }
}
