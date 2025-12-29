// FEATURE: Routing

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/features/auth/presentation/screens/login_screen.dart';
import 'package:testable/features/auth/presentation/screens/splash_screen.dart';
import 'package:testable/features/home/home_screen.dart';
import 'package:testable/features/user/presentation/screens/profile_screen.dart';
import 'package:testable/features/payment/presentation/screens/payment_screen.dart';
import 'package:testable/shared/widgets/samples/alert_cards_screen.dart';
import 'package:testable/shared/widgets/samples/sample_dialog_screen.dart';
import 'package:testable/shared/widgets/samples/sample_permission_page.dart';
part 'app_router.gr.dart';
part '../../shared/widgets/app_breadcrumb.dart';

/// ------------------------------------------------------
/// AUTO ROUTE SETUP
/// ------------------------------------------------------

@AutoRouterConfig(replaceInRouteName: 'Page,Screen,Route')
class AppRouter extends RootStackRouter {
  AppRouter({required this.ref, super.navigatorKey});

  final Ref ref;

  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: SplashScreenRoute.page, initial: true),
    AutoRoute(page: HomeScreenRoute.page),
    AutoRoute(page: UserProfileScreenRoute.page),
    AutoRoute(page: PaymentScreenRoute.page),
    AutoRoute(page: EditProfileScreenRoute.page),
    AutoRoute(page: SecurityScreenRoute.page),
    AutoRoute(page: NotificationsScreenRoute.page),
    AutoRoute(page: SettingsScreenRoute.page),
    AutoRoute(page: AboutScreenRoute.page),
    AutoRoute(page: LoginScreenRoute.page),

    /// Tests
    ///
    AutoRoute(page: AlertCardsDemoScreenRoute.page),
    AutoRoute(page: SampleDialogScreenRoute.page),
    AutoRoute(page: SamplePermissionsPageRoute.page),
  ];

  /// Attach a custom observer for logging or breadcrumb
  List<NavigatorObserver> get observers => [AppRouteObserver(ref)];
}

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const SampleScreen(
        title: 'Settings',
        icon: Icons.settings_outlined,
      ),
    );
  }
}

@RoutePage()
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const SampleScreen(title: 'About', icon: Icons.info_outline),
    );
  }
}

// Enhanced SampleScreen to use theme colors
class SampleScreen extends StatelessWidget {
  const SampleScreen({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This is the $title screen',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

// Additional screens for quick actions
@RoutePage()
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const SampleScreen(
        title: 'Edit Profile',
        icon: Icons.edit_outlined,
      ),
    );
  }
}

@RoutePage()
class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security')),
      body: const SampleScreen(
        title: 'Security',
        icon: Icons.security_outlined,
      ),
    );
  }
}

@RoutePage()
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: const SampleScreen(
        title: 'Notifications',
        icon: Icons.notifications_outlined,
      ),
    );
  }
}

/// ------------------------------------------------------
/// ROUTE HISTORY PROVIDER
/// ------------------------------------------------------
/// ------------------------------------------------------
/// ROUTE OBSERVER (logs navigation actions)
/// ------------------------------------------------------
class AppRouteObserver extends AutoRouterObserver {
  AppRouteObserver(this.ref);
  final Ref ref;

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
  const RouteLogEntry({
    required this.name,
    required this.path,
    required this.action,
    required this.timestamp,
  });
  final String name;
  final String path;
  final String action;
  final DateTime timestamp;
}
