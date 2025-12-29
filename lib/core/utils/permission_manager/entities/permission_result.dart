// entities/permission_result.dart
part of '../permission_manager.dart';

/// Result class for permission requests
class PermissionResult {
  const PermissionResult({
    required this.isGranted,
    required this.status,
    required this.permission,
    required this.requestedAt,
    this.failureReason,
    this.canRequestAgain = false,
    this.isPermanentlyDenied = false,
    this.shouldShowRationale = false,
    this.didShowRationale = false,
    this.isLimited = false,
  });

  final bool isGranted;
  final PermissionStatus status;
  final Permission permission;
  final String? failureReason;
  final bool canRequestAgain;
  final bool isPermanentlyDenied;
  final bool shouldShowRationale;
  final bool didShowRationale;
  final bool isLimited;
  final DateTime requestedAt;

  factory PermissionResult.fromStatus({
    required PermissionStatus status,
    required Permission permission,
    bool canRequestAgain = false,
    bool shouldShowRationale = false,
    bool didShowRationale = false,
  }) {
    return PermissionResult(
      isGranted: status.isGranted || status.isLimited,
      status: status,
      permission: permission,
      canRequestAgain: canRequestAgain,
      isPermanentlyDenied: status.isPermanentlyDenied,
      shouldShowRationale: shouldShowRationale,
      didShowRationale: didShowRationale,
      isLimited: status.isLimited,
      requestedAt: DateTime.now(),
      failureReason: _getFailureReason(status),
    );
  }

  static String? _getFailureReason(PermissionStatus status) {
    if (status.isGranted || status.isLimited) return null;

    return switch (status) {
      PermissionStatus.denied => 'Permission was denied by user.',
      PermissionStatus.permanentlyDenied =>
        'Permission was permanently denied. Please enable it in app settings.',
      PermissionStatus.restricted => 'Permission is restricted by the system.',
      PermissionStatus.provisional => 'Permission is granted provisionally.',
      _ => 'Permission status is unknown or not granted.',
    };
  }

  @override
  String toString() {
    return 'PermissionResult(permission: $permission, isGranted: $isGranted, '
        'status: $status, canRequestAgain: $canRequestAgain)';
  }

  Map<String, dynamic> toJson() {
    return {
      'permission': permission.toString(),
      'isGranted': isGranted,
      'status': status.toString(),
      'canRequestAgain': canRequestAgain,
      'isPermanentlyDenied': isPermanentlyDenied,
      'shouldShowRationale': shouldShowRationale,
      'didShowRationale': didShowRationale,
      'requestedAt': requestedAt.toIso8601String(),
    };
  }
}
