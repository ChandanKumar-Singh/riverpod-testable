import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/di/providers.dart';
import '../l10n/app_localizations.dart';
import '../shared/connectivity/connectivity_watcher.dart';
import '../shared/theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(langProvider);
    final router = ref.watch(appRouterProvider);
    return AnimatedTheme(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      data: themeMode == ThemeMode.dark ? AppTheme.dark : AppTheme.light,
      child: MaterialApp.router(
        title: 'Testable App',
        routerConfig: router.config(
          navigatorObservers: () => router.observers        ),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: locale,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,

        // home: MyHomePage(title: ''),
        builder: (context, child) {
          return ConnectivityWatcher(
            onlineBannerDuration: Duration(seconds: 3),
            showTransitionAnimations: true,
            showDebugPanel: false,
            child: child!,
          );
        },
      ),
    );
  }
}
