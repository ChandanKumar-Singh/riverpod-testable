import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_theme.dart';
import 'package:testable/core/routing/app_router.dart';
import 'package:testable/ui/dashboard/noc_screen.dart';

void main() {
  runApp(const ProviderScope(child: OneCoreApp()));
}

class OneCoreApp extends ConsumerWidget {
  const OneCoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp(
      title: 'One Core System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const NOCScreen(),
    );
    return MaterialApp.router(
      title: 'One Core System',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
