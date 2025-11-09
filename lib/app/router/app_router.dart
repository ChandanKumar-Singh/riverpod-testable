import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/features/auth/presentation/screens/login_screen.dart';
import 'package:testable/main.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../shared/widgets/sample_screen.dart';

part 'app_router.gr.dart';
part '../../shared/widgets/app_breadcrumb.dart';

/// ------------------------------------------------------
/// AUTO ROUTE SETUP
/// ------------------------------------------------------
@AutoRouterConfig(replaceInRouteName: 'Page,Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.ref});

  final Ref ref;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashScreenRoute.page, initial: true),
    AutoRoute(page: HomeScreenRoute.page),
    AutoRoute(page: ProfileScreenRoute.page),
    AutoRoute(page: SettingsScreenRoute.page),
    AutoRoute(page: AboutScreenRoute.page),
    AutoRoute(page: LoginScreenRoute.page),
  ];

  /// Attach a custom observer for logging or breadcrumb
  List<NavigatorObserver> get observers => [AppRouteObserver(ref)];
}

/// Sample screens (for demo/testing)
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const SampleScreen(title: 'Home', color: Colors.blueAccent);
}

@RoutePage()
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const SampleScreen(title: 'Profile', color: Colors.greenAccent);
}

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const SampleScreen(title: 'Settings', color: Colors.deepOrangeAccent);
}

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const SampleScreen(title: 'About', color: Colors.purpleAccent);
}

/// ------------------------------------------------------
/// ROUTE HISTORY PROVIDER
/// ------------------------------------------------------
/// ------------------------------------------------------
/// ROUTE OBSERVER (logs navigation actions)
/// ------------------------------------------------------
class AppRouteObserver extends AutoRouterObserver {
  final Ref ref;
  AppRouteObserver(this.ref);

  void _addLog(Route? route, String action) {
    final routeData = (route?.settings is AutoRoutePage)
        ? (route!.settings as AutoRoutePage).routeData
        : null;
    if (routeData == null) return;

    final entry = RouteLogEntry(
      name: routeData.name,
      path: routeData.path,
      action: action,
      timestamp: DateTime.now(),
    );
    Future.microtask(() {
      final history = ref.read(routeHistoryProvider);
      final notifier = ref.read(routeHistoryProvider.notifier);
      if (action == 'replace' && history.isNotEmpty) {
        final oldEntry = history.last;
        notifier.replaceEntry(oldEntry, entry);
      } else if (action == 'pop' && history.isNotEmpty) {
        notifier.removeLast();
      } else {
        notifier.addEntry(entry);
      }

      notifier.addEntry(entry);

      // Print to console for debugging
      debugPrint(
        '[ROUTE] ${entry.action.toUpperCase()} -> ${entry.name} (${entry.path})',
      );
    });
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _addLog(route, 'push');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _addLog(route, 'pop');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _addLog(newRoute, 'replace');
  }
}

/// ------------------------------------------------------
/// ROUTE HISTORY PROVIDER
/// ------------------------------------------------------
final routeHistoryProvider =
    StateNotifierProvider<RouteHistoryNotifier, List<RouteLogEntry>>(
      (ref) => RouteHistoryNotifier(),
    );

// TODO: [RouteHistoryNotifier] Enhance RouteLogEntry with more precise data
///
/// `[RouteHistoryNotifier]` manages the list of route navigation logs.
class RouteHistoryNotifier extends StateNotifier<List<RouteLogEntry>> {
  RouteHistoryNotifier() : super([]);

  void addEntry(RouteLogEntry entry) {
    state = [...state, entry];
  }

  void removeLast() {
    if (state.isNotEmpty) {
      state = state.sublist(0, state.length - 1);
    }
  }

  void removeEntry(RouteLogEntry entry) {
    state = state.where((e) => e != entry).toList();
  }

  void replaceEntry(RouteLogEntry oldEntry, RouteLogEntry newEntry) {
    removeLast();
    addEntry(newEntry);
  }

  void clear() => state = [];
}

class RouteLogEntry {
  final String name;
  final String path;
  final String action;
  final DateTime timestamp;

  const RouteLogEntry({
    required this.name,
    required this.path,
    required this.action,
    required this.timestamp,
  });
}
