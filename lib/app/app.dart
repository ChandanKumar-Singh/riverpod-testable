import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/router/app_router.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/shared/widgets/unfocus_wrapper.dart';
import 'package:toastification/toastification.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/l10n/app_localizations.dart';
import 'package:testable/shared/connectivity/connectivity_watcher.dart';
import 'package:testable/shared/theme/app_theme.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(langProvider);
    final router = ref.watch(appRouterProvider);
    ref.listen(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        router.replaceAll([const HomeScreenRoute()]);
      } else if (next.status == AuthStatus.unauthenticated) {
        router.replaceAll([const LoginScreenRoute()]);
      }
    });
    final appTheme = AppTheme();
    return ToastificationWrapper(
      config: ToastificationConfig(
        maxTitleLines: 2,
        maxDescriptionLines: 6,
        marginBuilder: (context, alignment) =>
            const EdgeInsets.fromLTRB(0, 16, 0, 110),
      ),
      child: UnfocusWrapper(
        child: AnimatedTheme(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          data: themeMode == ThemeMode.dark ? appTheme.dark : appTheme.light,
          child: MaterialApp.router(
            title: 'Testable App',
            routerConfig: router.config(
              navigatorObservers: () => router.observers,
            ),
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: appTheme.light,
            darkTheme: appTheme.dark,
            themeMode: themeMode,

            // home: MyHomePage(title: ''),
            builder: (context, child) {
              return ConnectivityWatcher(
                onlineBannerDuration: const Duration(seconds: 3),
                showTransitionAnimations: true,
                showDebugPanel: false,
                child: child!,
              );
            },
          ),
        ),
      ),
    );
  }
}
