/* // application/providers/toast_providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'toasts.dart';

// Default configuration
final defaultToastConfigProvider = Provider<ToastConfig>((ref) {
  return const ToastConfig(
    duration: Duration(seconds: 4),
    position: ToastPosition.bottom,
    animation: ToastAnimation.slideAndFade,
    dismissible: true,
    showProgressBar: true,
    borderRadius: 12.0,
    margin: EdgeInsets.all(16.0),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    queueMode: true,
    maxVisibleToasts: 3,
  );
});

// Theme provider (can be based on app theme)
final toastThemeProvider = Provider<ToastTheme>((ref) {
  return const ToastTheme(
    successColor: Color(0xFF4CAF50),
    errorColor: Color(0xFFF44336),
    warningColor: Color(0xFFFF9800),
    infoColor: Color(0xFF2196F3),
    textColor: Colors.white,
    backgroundColor: Color(0xFF424242),
    textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    elevation: 6.0,
    shadow: Shadow(blurRadius: 12, color: Colors.black26),
  );
});

// Main toast manager
final toastManagerProvider =
    StateNotifierProvider<ToastManager, List<ToastData>>((ref) {
      final config = ref.watch(defaultToastConfigProvider);
      final theme = ref.watch(toastThemeProvider);
      return ToastManager(config, theme);
    });

// Convenience provider for easy access
final toastProvider = Provider<AppToast>((ref) {
  final notifier = ref.watch(toastManagerProvider.notifier);
  return AppToast(notifier);
});

class AppToast {
  final ToastManager _manager;

  AppToast(this._manager);

  // Basic methods
  void show(ToastData toast) => _manager.show(toast);
  void dismiss(String id) => _manager.dismiss(id);
  void dismissAll() => _manager.dismissAll();

  // Convenience methods
  void success(String message, {ToastConfig? config, IconData? icon}) =>
      _manager.success(message, config: config, icon: icon);

  void error(String message, {ToastConfig? config, IconData? icon}) =>
      _manager.error(message, config: config, icon: icon);

  void warning(String message, {ToastConfig? config, IconData? icon}) =>
      _manager.warning(message, config: config, icon: icon);

  void info(String message, {ToastConfig? config, IconData? icon}) =>
      _manager.info(message, config: config, icon: icon);

  void custom(String message, {ToastConfig? config, IconData? icon}) =>
      _manager.custom(message, config: config, icon: icon);

  // Advanced methods with custom actions
  void showWithAction({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    ToastType type = ToastType.info,
    ToastConfig? config,
    IconData? icon,
  }) {
    _manager.show(
      ToastData(
        message: message,
        type: type,
        config: config,
        icon: icon,
        actionLabel: actionLabel,
        onAction: onAction,
      ),
    );
  }
}
 */