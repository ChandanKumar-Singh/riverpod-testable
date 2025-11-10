// FEATURE: Routing

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/features/auth/presentation/screens/login_screen.dart';
import 'package:testable/features/auth/presentation/screens/splash_screen.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/features/user/presentation/screens/profile_screen.dart';
import 'package:testable/features/payment/presentation/screens/payment_screen.dart';
import 'package:testable/shared/widgets/sample_screen.dart';

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
    AutoRoute(page: UserProfileScreenRoute.page),
    AutoRoute(page: PaymentScreenRoute.page),
    AutoRoute(page: ProfileScreenRoute.page),
    AutoRoute(page: SettingsScreenRoute.page),
    AutoRoute(page: AboutScreenRoute.page),
    AutoRoute(page: LoginScreenRoute.page),
  ];

  /// Attach a custom observer for logging or breadcrumb
  List<NavigatorObserver> get observers => [AppRouteObserver(ref)];
}

/// Home screen with navigation to main features
@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.pushRoute(const UserProfileScreenRoute());
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (authState.user != null)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(authState.user!.name[0].toUpperCase()),
                ),
                title: Text('Welcome, ${authState.user!.name}'),
                subtitle: Text(authState.user!.email ?? ''),
              ),
            ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            context,
            title: 'Profile',
            icon: Icons.person,
            color: Colors.blue,
            onTap: () => context.pushRoute(const UserProfileScreenRoute()),
          ),
          _buildFeatureCard(
            context,
            title: 'Payments',
            icon: Icons.payment,
            color: Colors.green,
            onTap: () => context.pushRoute(const PaymentScreenRoute()),
          ),
          _buildFeatureCard(
            context,
            title: 'Settings',
            icon: Icons.settings,
            color: Colors.orange,
            onTap: () => context.pushRoute(const SettingsScreenRoute()),
          ),
          _buildFeatureCard(
            context,
            title: 'About',
            icon: Icons.info,
            color: Colors.purple,
            onTap: () => context.pushRoute(const AboutScreenRoute()),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(51),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
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
