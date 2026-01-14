// entities/multiple_permission_result.dart
part of '../permission_manager.dart';

/// Result class for multiple permission requests
class MultiplePermissionResult {
  const MultiplePermissionResult({
    required this.results,
    required this.completedPermissions,
  });

  factory MultiplePermissionResult.fromMap({
    required Map<Permission, PermissionResult> results,
    required List<Permission> completedPermissions,
  }) {
    return MultiplePermissionResult(
      results: results,
      completedPermissions: completedPermissions,
    );
  }

  final Map<Permission, PermissionResult> results;
  final List<Permission> completedPermissions;

  bool get allGranted => results.values.every((result) => result.isGranted);
  bool get anyGranted => results.values.any((result) => result.isGranted);
  bool get anyPermanentlyDenied =>
      results.values.any((result) => result.isPermanentlyDenied);
  bool get hasEssentialGranted => results.values.any(
    (result) => !result.isGranted && result.isPermanentlyDenied,
  );

  List<Permission> get grantedPermissions => results.entries
      .where((entry) => entry.value.isGranted)
      .map((entry) => entry.key)
      .toList();

  List<Permission> get deniedPermissions => results.entries
      .where((entry) => !entry.value.isGranted)
      .map((entry) => entry.key)
      .toList();

  List<Permission> get permanentlyDeniedPermissions => results.entries
      .where((entry) => entry.value.isPermanentlyDenied)
      .map((entry) => entry.key)
      .toList();

  DateTime get completedAt => DateTime.now();

  double get grantPercentage {
    if (results.isEmpty) return 0.0;
    final grantedCount = results.values.where((r) => r.isGranted).length;
    return grantedCount / results.length;
  }

  bool isGranted(Permission permission) =>
      results[permission]?.isGranted ?? false;

  PermissionResult? getResult(Permission permission) => results[permission];

  @override
  String toString() {
    return 'MultiplePermissionResult(allGranted: $allGranted, '
        'granted: ${grantedPermissions.length}/${results.length}, '
        'permanentlyDenied: ${permanentlyDeniedPermissions.length})';
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map(
        (key, value) => MapEntry(key.toString(), value.toJson()),
      ),
      'allGranted': allGranted,
      'anyPermanentlyDenied': anyPermanentlyDenied,
      'grantedCount': grantedPermissions.length,
      'deniedCount': deniedPermissions.length,
      'completedAt': completedAt.toIso8601String(),
    };
  }
}
