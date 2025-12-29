// adapters/riverpod/permission_manager_provider.dart
part of '../../permission_manager.dart';

final permissionAnalyticsProvider = Provider<PermissionAnalytics?>(
  (ref) => ConsolePermissionAnalytics(logger: ref.read(loggerProvider)),
);

final permissionManagerProvider = Provider<PermissionManager>((ref) {
  return PermissionManager(
    dialogService2: PermissionDialogService(),
    analytics: ref.read(permissionAnalyticsProvider),
    navigatorKey: ref.read(appRouterProvider).navigatorKey,
  );
});
