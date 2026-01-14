// permission_manager.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testable/core/di/providers.dart';
import 'package:testable/core/utils/logger.dart';
import 'package:testable/shared/theme/theme_switcher.dart';

part 'platform_wrapper.dart';
part 'services/permission_dialog_service.dart';
part 'services/permission_handler_service.dart';
part 'entities/permission_request_config.dart';
part 'entities/permission_result.dart';
part 'entities/multiple_permission_result.dart';

part 'analytics/permission_analytics.dart';
part 'analytics/permission_analytics_event.dart';
part 'analytics/use_case/console_permission_analytics.dart';

part 'adapters/riverpod/permission_manager_provider.dart';
part 'adapters/riverpod/permission_request_notifier.dart';

part 'ui/permission_prompt_card.dart';

class PermissionManager {
  PermissionManager({
    IPermissionHandler? permissionHandler,
    IDialogService? dialogService,
    PlatformWrapper? platformWrapper,
    PermissionAnalytics? analytics,
    PermissionDialogService? dialogService2,
    this.onPermissionGranted,
    this.onPermissionDenied,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : _permissionHandler = permissionHandler ?? PermissionHandlerImpl(),
       _dialogService = dialogService,
       _dialogService2 = dialogService2,
       _analytics = analytics,
       _navigatorKey = navigatorKey,
       _platform = platformWrapper ?? PlatformWrapperImpl();

  final IPermissionHandler _permissionHandler;
  final IDialogService? _dialogService;
  final PermissionDialogService? _dialogService2;
  final PermissionAnalytics? _analytics;
  final PlatformWrapper _platform;
  GlobalKey<NavigatorState>? _navigatorKey;

  /// Optional analytics / hooks
  final void Function(Permission)? onPermissionGranted;
  final void Function(Permission)? onPermissionDenied;

  /// ---------------- SINGLE ----------------
  Future<PermissionResult> requestSingle({
    required PermissionRequestConfig config,
    bool openSettingsOnPermanentDenial = true,
    bool fromMultiple = false,
  }) async {
    _analytics?.track(
      PermissionAnalyticsEvent(
        permission: config.permission,
        action: PermissionAnalyticsAction.requestStarted,
        timestamp: DateTime.now(),
      ),
    );
    final status = await _permissionHandler.status(config.permission);

    if (status.isGranted || status.isLimited) {
      onPermissionGranted?.call(config.permission);
      return PermissionResult.fromStatus(
        permission: config.permission,
        status: status,
      );
    }

    final shouldShowRationale = _platform.isAndroid
        ? await config.permission.shouldShowRequestRationale
        : status.isDenied;

    final bool didShowRationale = false;

    if (_dialogService2 != null) {
      // didShowRationale = true;
      if (!fromMultiple) {
        final userAllowed = await _dialogService2.show(
          navigatorKey: _navigatorKey,
          configs: [config],
          allowButtonText: 'Allow',
          cancelButtonText: 'Cancel',
        );

        if (!userAllowed) {
          onPermissionDenied?.call(config.permission);
          return PermissionResult.fromStatus(
            permission: config.permission,
            status: PermissionStatus.denied,
            canRequestAgain: true,
            shouldShowRationale: true,
            didShowRationale: true,
          );
        }
      }
    }

    final newStatus = await _permissionHandler.request(config.permission);

    if (newStatus.isGranted || newStatus.isLimited) {
      onPermissionGranted?.call(config.permission);
    } else {
      onPermissionDenied?.call(config.permission);

      if (newStatus.isPermanentlyDenied &&
          openSettingsOnPermanentDenial &&
          _dialogService != null) {
        final openSettings = await _dialogService.showOpenSettingsDialog(
          title: 'Permission Required',
          message:
              config.permanentDenialMessage ??
              'Please enable permission in settings.',
        );

        if (openSettings) {
          await openAppSettings();
        }
      }
    }

    return PermissionResult.fromStatus(
      permission: config.permission,
      status: newStatus,
      canRequestAgain:
          !newStatus.isPermanentlyDenied && !newStatus.isRestricted,
      shouldShowRationale: shouldShowRationale,
      didShowRationale: didShowRationale,
    );
  }

  /// ---------------- MULTIPLE ----------------
  /// ---------------- MULTIPLE ----------------
  Future<MultiplePermissionResult?> requestMultiple({
    required List<PermissionRequestConfig> configs,
    bool showBulkDialog = true,
    bool stopOnEssentialFailure = true,
    void Function(int current, int total)? onProgress,
  }) async {
    final results = <Permission, PermissionResult>{};
    final List<PermissionRequestConfig> pendingConfigs = [];

    // Check all permissions first
    for (int i = 0; i < configs.length; i++) {
      final config = configs[i];
      onProgress?.call(i + 1, configs.length);

      // Check current status
      final currentStatus = await config.permission.status;
      final isAlreadyGranted =
          currentStatus.isGranted || currentStatus.isLimited;

      if (isAlreadyGranted) {
        // Add granted permission to results
        results[config.permission] = PermissionResult.fromStatus(
          status: currentStatus,
          permission: config.permission,
          canRequestAgain: false,
          shouldShowRationale: false,
        );

        _log('Permission already granted: ${config.permission}');
      } else {
        // Add to pending list for request
        pendingConfigs.add(config);
      }
    }

    // If all permissions are already granted, return immediately
    if (pendingConfigs.isEmpty) {
      _log('All permissions are already granted');
      return MultiplePermissionResult(
        results: results,
        completedPermissions: results.keys.toList(),
      );
    }

    // Show bulk permission dialog if needed
    if (showBulkDialog && _dialogService2 != null) {
      final userAllowed = await _dialogService2.show(
        navigatorKey: _navigatorKey,
        configs: pendingConfigs,
        allowButtonText: 'Allow All',
        cancelButtonText: 'Cancel',
      );

      if (!userAllowed) {
        // User denied the bulk request, but we still have already granted permissions
        // Return partial results with granted permissions
        _log('User denied bulk permission request');
        return MultiplePermissionResult(
          results: results,
          completedPermissions: results.keys.toList(),
        );
      }
    }

    // Request pending permissions
    for (int i = 0; i < pendingConfigs.length; i++) {
      final config = pendingConfigs[i];
      onProgress?.call(results.length + i + 1, configs.length);

      _log('Requesting pending permission: ${config.permission}');

      try {
        final result = await requestSingle(config: config, fromMultiple: true);

        results[config.permission] = result;

        // Stop if essential permission is permanently denied
        if (config.isEssential &&
            result.isPermanentlyDenied &&
            stopOnEssentialFailure) {
          _log(
            'Essential permission permanently denied, stopping further requests',
          );
          break;
        }

        // Small delay between requests for better UX
        if (i < pendingConfigs.length - 1) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      } catch (e, stackTrace) {
        _logError(
          'Error requesting permission ${config.permission}',
          e,
          stackTrace,
        );

        results[config.permission] = PermissionResult.fromStatus(
          status: PermissionStatus.denied,
          permission: config.permission,
        );
      }
    }

    // Calculate completed permissions (granted or limited)
    final completedPermissions = results.entries
        .where((e) => e.value.isGranted)
        .map((e) => e.key)
        .toList();

    return MultiplePermissionResult(
      results: results,
      completedPermissions: completedPermissions,
    );
  }

  void _log(String s) {}

  void _logError(String s, Object e, StackTrace stackTrace) {}
}
