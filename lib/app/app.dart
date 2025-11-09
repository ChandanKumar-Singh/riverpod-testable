import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';
import '../core/di/providers.dart';
import '../l10n/app_localizations.dart';
import '../shared/connectivity/connectivity_watcher.dart';
import '../shared/theme/app_theme.dart';


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(langProvider);
    final router = ref.watch(appRouterProvider);
    return ToastificationWrapper(
      config: ToastificationConfig(
        maxTitleLines: 2,
        maxDescriptionLines: 6,
        marginBuilder: (context, alignment) =>
            const EdgeInsets.fromLTRB(0, 16, 0, 110),
      ),
      child: AnimatedTheme(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        data: themeMode == ThemeMode.dark ? AppTheme.dark : AppTheme.light,
        child: MaterialApp.router(
          title: 'Testable App',
          routerConfig: router.config(navigatorObservers: () => router.observers),
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
      ),
    );
  }
}
