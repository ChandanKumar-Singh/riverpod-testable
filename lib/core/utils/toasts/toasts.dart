// FEATURE: Toast

// core/utils/app_messenger.dart
import 'package:flutter/material.dart';

import 'package:toastification/toastification.dart';

/// Simple action model for buttons inside toasts
class ToastAction {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;
  final bool closeOnTap;

  const ToastAction({
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.closeOnTap = true,
  });
}

/// Global toast manager
class AppToastification {
  /// Universal toast function
  static ToastificationItem show({
    BuildContext? context,
    String? message,
    String? title,
    ToastificationType? type,
    ToastificationStyle? style,
    Widget? icon,
    Duration? autoCloseDuration,
    Color? primaryColor,
    Color? backgroundColor,
    Color? foregroundColor,
    EdgeInsetsGeometry? margin,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    bool? showProgressBar,
    bool? applyBlurEffect,
    CloseButtonShowType? closeButtonShowType,
    bool? closeOnClick,
    bool? dragToClose,
    bool? showIcon,
    AlignmentGeometry? alignment,
    List<ToastAction>? actions,
  }) {
    final ctx = context;
    final theme = ctx != null ? Theme.of(ctx) : ThemeData.light();
    final isDark = theme.brightness == Brightness.dark;

    final effectivePrimary = primaryColor ?? theme.colorScheme.primary;
    final effectiveBackground =
        backgroundColor ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white);
    final effectiveForeground =
        foregroundColor ?? (isDark ? Colors.white : Colors.black87);

    return toastification.show(
      context: ctx,
      type: type ?? ToastificationType.info,
      style: style ?? ToastificationStyle.flat,
      alignment: alignment ?? Alignment.topCenter,
      autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 3),
      primaryColor: effectivePrimary,
      backgroundColor: effectiveBackground,
      foregroundColor: effectiveForeground,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      boxShadow:
          boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
      showProgressBar: showProgressBar ?? false,
      applyBlurEffect: applyBlurEffect ?? false,
      closeButton: ToastCloseButton(
        showType: closeButtonShowType ?? CloseButtonShowType.always,
      ),
      closeOnClick: closeOnClick ?? true,
      dragToClose: dragToClose ?? true,
      showIcon: showIcon ?? false,

      // --- Layout ---
      title: title != null
          ? Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: effectiveForeground,
              ),
            )
          : null,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (message != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                message,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.3,
                  color: effectiveForeground.withOpacity(0.95),
                ),
              ),
            ),
          if (actions != null && actions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Wrap(
                spacing: 4,
                runSpacing: 0,
                children: actions.map((a) {
                  return TextButton.icon(
                    onPressed: () {
                      a.onPressed();
                      if (a.closeOnTap) toastification.dismissAll();
                    },
                    icon: a.icon != null
                        ? Icon(
                            a.icon,
                            size: 14,
                            color: a.color ?? effectivePrimary,
                          )
                        : const SizedBox.shrink(),
                    label: Text(
                      a.label,
                      style: TextStyle(
                        color: a.color ?? effectivePrimary,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      minimumSize: const Size(0, 26),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  /// Common shortcuts
  static ToastificationItem success(
    String message, {
    String? title,
    List<ToastAction>? actions,
  }) => show(
    title: title ?? 'Success',
    message: message,
    type: ToastificationType.success,
    primaryColor: Colors.green,
    actions: actions,
    showIcon: true,
  );

  static ToastificationItem error(
    String message, {
    String? title,
    List<ToastAction>? actions,
  }) => show(
    title: title ?? 'Error',
    message: message,
    type: ToastificationType.error,
    primaryColor: Colors.red,
    actions: actions,
    showIcon: true,
  );

  static ToastificationItem info(
    String message, {
    String? title,
    List<ToastAction>? actions,
  }) => show(
    title: title ?? 'Info',
    message: message,
    type: ToastificationType.info,
    primaryColor: Colors.blue,
    actions: actions,
    showIcon: true,
  );

  static ToastificationItem warning(
    String message, {
    String? title,
    List<ToastAction>? actions,
  }) => show(
    title: title ?? 'Warning',
    message: message,
    type: ToastificationType.warning,
    primaryColor: Colors.orange,
    actions: actions,
    showIcon: true,
  );
}
/* 
// =============================================================================
// 🎨 Initialization
// =============================================================================
void initializeToast(BuildContext context) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    final overlayState = Overlay.of(context);
    AppMessenger().initialize(
      overlayState: overlayState,
      defaultConfig: ToastConfig(
        duration: Duration(seconds: 3),
        position: ToastPosition.bottom,
      ),
      theme: ToastTheme(
        successColor: Colors.green,
        errorColor: Colors.red,
        infoColor: Colors.blue,
      ),
    );
  });
}

// =============================================================================
// 🎨 Toast Types & Configuration
// =============================================================================

enum ToastType { success, error, warning, info, custom }

enum ToastPosition { top, bottom, center }

enum ToastAnimation { slide, fade, scale, slideAndFade }

class ToastConfig {
  final Duration duration;
  final ToastPosition position;
  final ToastAnimation animation;
  final bool dismissible;
  final bool showProgressBar;
  final Color? progressBarColor;
  final double borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final bool queueMode;
  final int maxVisibleToasts;

  const ToastConfig({
    this.duration = const Duration(seconds: 4),
    this.position = ToastPosition.bottom,
    this.animation = ToastAnimation.slideAndFade,
    this.dismissible = true,
    this.showProgressBar = true,
    this.progressBarColor,
    this.borderRadius = 12.0,
    this.margin = const EdgeInsets.all(16.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.textAlign = TextAlign.start,
    this.queueMode = true,
    this.maxVisibleToasts = 3,
  });

  ToastConfig copyWith({
    Duration? duration,
    ToastPosition? position,
    ToastAnimation? animation,
    bool? dismissible,
    bool? showProgressBar,
    Color? progressBarColor,
    double? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
    TextAlign? textAlign,
    bool? queueMode,
    int? maxVisibleToasts,
  }) {
    return ToastConfig(
      duration: duration ?? this.duration,
      position: position ?? this.position,
      animation: animation ?? this.animation,
      dismissible: dismissible ?? this.dismissible,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      progressBarColor: progressBarColor ?? this.progressBarColor,
      borderRadius: borderRadius ?? this.borderRadius,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      textAlign: textAlign ?? this.textAlign,
      queueMode: queueMode ?? this.queueMode,
      maxVisibleToasts: maxVisibleToasts ?? this.maxVisibleToasts,
    );
  }
}

class ToastTheme {
  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color infoColor;
  final Color textColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double elevation;
  final BoxShadow shadow;

  const ToastTheme({
    this.successColor = const Color(0xFF4CAF50),
    this.errorColor = const Color(0xFFF44336),
    this.warningColor = const Color(0xFFFF9800),
    this.infoColor = const Color(0xFF2196F3),
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xFF424242),
    this.textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    this.elevation = 6.0,
    this.shadow = const BoxShadow(
      blurRadius: 12,
      color: Colors.black26,
      offset: Offset(0, 4),
    ),
  });

  ToastTheme copyWith({
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
    Color? textColor,
    Color? backgroundColor,
    TextStyle? textStyle,
    double? elevation,
    BoxShadow? shadow,
  }) {
    return ToastTheme(
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      elevation: elevation ?? this.elevation,
      shadow: shadow ?? this.shadow,
    );
  }
}

class ToastData {
  final String id;
  final String message;
  final ToastType type;
  final ToastConfig config;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  ToastData({
    required this.message,
    required this.type,
    ToastConfig? config,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString(),
       config = config ?? const ToastConfig();

  Color getColor(ToastTheme theme) {
    switch (type) {
      case ToastType.success:
        return theme.successColor;
      case ToastType.error:
        return theme.errorColor;
      case ToastType.warning:
        return theme.warningColor;
      case ToastType.info:
        return theme.infoColor;
      case ToastType.custom:
        return theme.backgroundColor;
    }
  }

  IconData getDefaultIcon() {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
      case ToastType.custom:
        return Icons.notifications;
    }
  }
}

// =============================================================================
// 🌟 Global Toast Manager (Singleton Pattern)
// =============================================================================

class AppMessenger {
  static final AppMessenger _instance = AppMessenger._internal();
  factory AppMessenger() => _instance;
  AppMessenger._internal();

  final List<ToastData> _toasts = [];
  final List<ToastData> _queue = [];

  ToastConfig _defaultConfig = const ToastConfig();
  ToastTheme _theme = const ToastTheme();

  VoidCallback? _onToastsChanged;
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  // Configuration
  void initialize({
    required OverlayState overlayState,
    ToastConfig? defaultConfig,
    ToastTheme? theme,
  }) {
    _overlayState = overlayState;
    _defaultConfig = defaultConfig ?? _defaultConfig;
    _theme = theme ?? _theme;
    _createOverlay();
  }

  void setTheme(ToastTheme theme) {
    _theme = theme;
    _refreshOverlay();
  }

  void setConfig(ToastConfig config) {
    _defaultConfig = config;
    _refreshOverlay();
  }

  // Toast Management
  void _createOverlay() {
    if (_overlayState == null) return;

    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) =>
          _ToastContainer(toasts: _toasts, theme: _theme, onDismiss: _dismiss),
    );
    _overlayState!.insert(_overlayEntry!);
  }

  void _refreshOverlay() {
    _overlayEntry?.markNeedsBuild();
  }

  void _processQueue() {
    if (_queue.isNotEmpty && _toasts.length < _defaultConfig.maxVisibleToasts) {
      final toast = _queue.removeAt(0);
      _toasts.add(toast);
      _refreshOverlay();
      _onToastsChanged?.call();
    }
  }

  void _dismiss(String id) {
    final toast = _toasts.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Toast not found'),
    );
    toast.onDismiss?.call();
    _toasts.removeWhere((t) => t.id == id);
    _refreshOverlay();
    _onToastsChanged?.call();
    _processQueue();
  }

  // Public API
  void show(ToastData toast) {
    final config = toast.config.copyWith(
      queueMode: toast.config.queueMode && _defaultConfig.queueMode,
    );

    final enhancedToast = ToastData(
      message: toast.message,
      type: toast.type,
      config: config,
      icon: toast.icon,
      actionLabel: toast.actionLabel,
      onAction: toast.onAction,
      onDismiss: toast.onDismiss,
    );

    if (config.queueMode && _toasts.length >= _defaultConfig.maxVisibleToasts) {
      _queue.add(enhancedToast);
    } else {
      _toasts.add(enhancedToast);
      _refreshOverlay();
      _onToastsChanged?.call();
    }
  }

  void dismiss(String id) => _dismiss(id);

  void dismissAll() {
    for (final toast in _toasts) {
      toast.onDismiss?.call();
    }
    _toasts.clear();
    _queue.clear();
    _refreshOverlay();
    _onToastsChanged?.call();
  }

  // Convenience Methods
  void success(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.success,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void error(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.error,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void warning(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.warning,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void info(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.info,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void custom(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.custom,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  // Advanced Methods
  void showWithAction({
    required String message,
    required String actionLabel,
    required VoidCallback onAction,
    ToastType type = ToastType.info,
    ToastConfig? config,
    IconData? icon,
  }) {
    show(
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

  // Stream for listening to toast changes (optional)
  Stream<List<ToastData>> get toastsStream {
    final controller = StreamController<List<ToastData>>();
    _onToastsChanged = () => controller.add(List.from(_toasts));
    return controller.stream;
  }
}

// =============================================================================
// 🎭 Toast Widgets
// =============================================================================

class _ToastContainer extends StatelessWidget {
  final List<ToastData> toasts;
  final ToastTheme theme;
  final Function(String) onDismiss;

  const _ToastContainer({
    required this.toasts,
    required this.theme,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Column(
          children: [
            // Top toasts
            ..._buildToastsForPosition(ToastPosition.top),
            const Spacer(),
            // Center toasts
            ..._buildToastsForPosition(ToastPosition.center),
            const Spacer(),
            // Bottom toasts
            ..._buildToastsForPosition(ToastPosition.bottom),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildToastsForPosition(ToastPosition position) {
    final positionToasts = toasts
        .where((t) => t.config.position == position)
        .toList();

    if (positionToasts.isEmpty) return [];

    return [
      for (final toast in positionToasts)
        Padding(
          padding: toast.config.margin,
          child: Align(
            alignment: _getAlignment(toast.config.position),
            child: _AnimatedToast(
              toast: toast,
              theme: theme,
              onDismiss: () => onDismiss(toast.id),
            ),
          ),
        ),
    ];
  }

  Alignment _getAlignment(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
      case ToastPosition.center:
        return Alignment.center;
    }
  }
}

class _AnimatedToast extends StatefulWidget {
  final ToastData toast;
  final ToastTheme theme;
  final VoidCallback onDismiss;

  const _AnimatedToast({
    required this.toast,
    required this.theme,
    required this.onDismiss,
  });

  @override
  State<_AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<_AnimatedToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _enterController;
  late AnimationController _exitController;
  late Animation<double> _enterAnimation;
  late Animation<double> _exitAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEnterAnimation();
    _scheduleAutoDismiss();
  }

  void _initializeAnimations() {
    final config = widget.toast.config;

    _enterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _enterAnimation = CurvedAnimation(
      parent: _enterController,
      curve: Curves.easeOutCubic,
    );

    _exitAnimation = CurvedAnimation(
      parent: _exitController,
      curve: Curves.easeInCubic,
    );
  }

  void _startEnterAnimation() {
    _enterController.forward();
  }

  void _scheduleAutoDismiss() {
    Future.delayed(widget.toast.config.duration, _dismissToast);
  }

  Future<void> _dismissToast() async {
    await _exitController.forward();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.toast.config;
    final theme = widget.theme;
    final color = widget.toast.getColor(theme);

    Widget toastContent = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(config.borderRadius),
        boxShadow: [theme.shadow],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: config.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.toast.icon ?? widget.toast.getDefaultIcon(),
                color: theme.textColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.toast.message,
                  style: theme.textStyle.copyWith(color: theme.textColor),
                  textAlign: config.textAlign,
                ),
              ),
              if (widget.toast.actionLabel != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.toast.onAction?.call();
                    _dismissToast();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: theme.textColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    widget.toast.actionLabel!,
                    style: theme.textStyle.copyWith(
                      color: theme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              if (config.dismissible) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: theme.textColor,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _dismissToast,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    // Add progress bar if enabled
    if (config.showProgressBar) {
      toastContent = Stack(
        children: [
          toastContent,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                config.progressBarColor ?? theme.textColor.withOpacity(0.3),
              ),
            ),
          ),
        ],
      );
    }

    // Apply animations
    return AnimatedBuilder(
      animation: Listenable.merge([_enterAnimation, _exitAnimation]),
      builder: (context, child) {
        final opacity = _enterAnimation.value * (1 - _exitAnimation.value);
        final scale =
            0.5 + 0.5 * _enterAnimation.value * (1 - _exitAnimation.value);

        double offsetY = 0;
        if (config.animation == ToastAnimation.slide ||
            config.animation == ToastAnimation.slideAndFade) {
          final startOffset = config.position == ToastPosition.top ? -0.5 : 0.5;
          offsetY =
              startOffset *
              (1 - _enterAnimation.value) *
              (1 - _exitAnimation.value);
        }

        return Transform.translate(
          offset: Offset(0, offsetY * 100),
          child: Transform.scale(
            scale: scale,
            child: Opacity(opacity: opacity, child: child),
          ),
        );
      },
      child: toastContent,
    );
  }

  @override
  void dispose() {
    _enterController.dispose();
    _exitController.dispose();
    super.dispose();
  }
} 

 */
/* // core/utils/toasts.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// =============================================================================
// 🎨 Toast Types & Configuration
// =============================================================================

enum ToastType { success, error, warning, info, custom }

enum ToastPosition { top, bottom, center }

enum ToastAnimation { slide, fade, scale, slideAndFade }

class ToastConfig {
  final Duration duration;
  final ToastPosition position;
  final ToastAnimation animation;
  final bool dismissible;
  final bool showProgressBar;
  final Color? progressBarColor;
  final double borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final TextAlign textAlign;
  final bool queueMode;
  final int maxVisibleToasts;

  const ToastConfig({
    this.duration = const Duration(seconds: 4),
    this.position = ToastPosition.bottom,
    this.animation = ToastAnimation.slideAndFade,
    this.dismissible = true,
    this.showProgressBar = true,
    this.progressBarColor,
    this.borderRadius = 12.0,
    this.margin = const EdgeInsets.all(16.0),
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.textAlign = TextAlign.start,
    this.queueMode = true,
    this.maxVisibleToasts = 3,
  });

  ToastConfig copyWith({
    Duration? duration,
    ToastPosition? position,
    ToastAnimation? animation,
    bool? dismissible,
    bool? showProgressBar,
    Color? progressBarColor,
    double? borderRadius,
    EdgeInsets? margin,
    EdgeInsets? padding,
    TextAlign? textAlign,
    bool? queueMode,
    int? maxVisibleToasts,
  }) {
    return ToastConfig(
      duration: duration ?? this.duration,
      position: position ?? this.position,
      animation: animation ?? this.animation,
      dismissible: dismissible ?? this.dismissible,
      showProgressBar: showProgressBar ?? this.showProgressBar,
      progressBarColor: progressBarColor ?? this.progressBarColor,
      borderRadius: borderRadius ?? this.borderRadius,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      textAlign: textAlign ?? this.textAlign,
      queueMode: queueMode ?? this.queueMode,
      maxVisibleToasts: maxVisibleToasts ?? this.maxVisibleToasts,
    );
  }
}

class ToastTheme {
  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color infoColor;
  final Color textColor;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double elevation;
  final Shadow shadow;

  const ToastTheme({
    this.successColor = const Color(0xFF4CAF50),
    this.errorColor = const Color(0xFFF44336),
    this.warningColor = const Color(0xFFFF9800),
    this.infoColor = const Color(0xFF2196F3),
    this.textColor = Colors.white,
    this.backgroundColor = const Color(0xFF424242),
    this.textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    this.elevation = 6.0,
    this.shadow = const Shadow(blurRadius: 12, color: Colors.black26),
  });

  ToastTheme copyWith({
    Color? successColor,
    Color? errorColor,
    Color? warningColor,
    Color? infoColor,
    Color? textColor,
    Color? backgroundColor,
    TextStyle? textStyle,
    double? elevation,
    Shadow? shadow,
  }) {
    return ToastTheme(
      successColor: successColor ?? this.successColor,
      errorColor: errorColor ?? this.errorColor,
      warningColor: warningColor ?? this.warningColor,
      infoColor: infoColor ?? this.infoColor,
      textColor: textColor ?? this.textColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      textStyle: textStyle ?? this.textStyle,
      elevation: elevation ?? this.elevation,
      shadow: shadow ?? this.shadow,
    );
  }
}

class ToastData {
  final String id;
  final String message;
  final ToastType type;
  final ToastConfig config;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;

  ToastData({
    required this.message,
    required this.type,
    ToastConfig? config,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.onDismiss,
  }) : id = DateTime.now().microsecondsSinceEpoch.toString(),
       config = config ?? const ToastConfig();

  Color getColor(ToastTheme theme) {
    switch (type) {
      case ToastType.success:
        return theme.successColor;
      case ToastType.error:
        return theme.errorColor;
      case ToastType.warning:
        return theme.warningColor;
      case ToastType.info:
        return theme.infoColor;
      case ToastType.custom:
        return theme.backgroundColor;
    }
  }

  IconData getDefaultIcon() {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle;
      case ToastType.error:
        return Icons.error;
      case ToastType.warning:
        return Icons.warning;
      case ToastType.info:
        return Icons.info;
      case ToastType.custom:
        return Icons.notifications;
    }
  }
}

// =============================================================================
// 🎬 Toast Animation Controllers
// =============================================================================

class ToastAnimationController {
  final AnimationController enterController;
  final AnimationController exitController;
  final Animation<double> enterAnimation;
  final Animation<double> exitAnimation;

  ToastAnimationController({
    required this.enterController,
    required this.exitController,
    required this.enterAnimation,
    required this.exitAnimation,
  });

  void dispose() {
    enterController.dispose();
    exitController.dispose();
  }
}

// =============================================================================
// 🏗️ Toast Manager (State Management)
// =============================================================================

class ToastManager extends StateNotifier<List<ToastData>> {
  final List<ToastData> _queue = [];
  final ToastConfig _defaultConfig;
  final ToastTheme _theme;

  ToastManager(this._defaultConfig, this._theme) : super([]);

  void _processQueue() {
    if (_queue.isNotEmpty && state.length < _defaultConfig.maxVisibleToasts) {
      final toast = _queue.removeAt(0);
      state = [...state, toast];
    }
  }

  void show(ToastData toast) {
    final config = toast.config.copyWith(
      queueMode: toast.config.queueMode && _defaultConfig.queueMode,
    );

    final enhancedToast = ToastData(
      message: toast.message,
      type: toast.type,
      config: config,
      icon: toast.icon,
      actionLabel: toast.actionLabel,
      onAction: toast.onAction,
      onDismiss: toast.onDismiss,
    );

    if (config.queueMode && state.length >= _defaultConfig.maxVisibleToasts) {
      _queue.add(enhancedToast);
    } else {
      state = [...state, enhancedToast];
    }
  }

  void dismiss(String id) {
    final toast = state.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Toast not found'),
    );
    toast.onDismiss?.call();
    state = state.where((t) => t.id != id).toList();
    _processQueue();
  }

  void dismissAll() {
    for (final toast in state) {
      toast.onDismiss?.call();
    }
    state = [];
    _queue.clear();
  }

  void success(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.success,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void error(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.error,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void warning(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.warning,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void info(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.info,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }

  void custom(String message, {ToastConfig? config, IconData? icon}) {
    show(
      ToastData(
        message: message,
        type: ToastType.custom,
        config: config ?? _defaultConfig,
        icon: icon,
      ),
    );
  }
}

// =============================================================================
// 🎭 Toast Widget with Advanced Animations
// =============================================================================

class AnimatedToast extends StatefulWidget {
  final ToastData toast;
  final ToastTheme theme;
  final VoidCallback onDismiss;

  const AnimatedToast({
    Key? key,
    required this.toast,
    required this.theme,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<AnimatedToast> createState() => _AnimatedToastState();
}

class _AnimatedToastState extends State<AnimatedToast>
    with SingleTickerProviderStateMixin {
  late ToastAnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEnterAnimation();
    _scheduleAutoDismiss();
  }

  void _initializeAnimations() {
    final config = widget.toast.config;

    _animationController = ToastAnimationController(
      enterController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
      exitController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
      ),
      enterAnimation: CurvedAnimation(
        parent: _animationController.enterController,
        curve: Curves.easeOutCubic,
      ),
      exitAnimation: CurvedAnimation(
        parent: _animationController.exitController,
        curve: Curves.easeInCubic,
      ),
    );

    // Setup animations based on type
    switch (config.animation) {
      case ToastAnimation.slide:
        _slideAnimation = Tween<Offset>(
          begin: config.position == ToastPosition.top
              ? const Offset(0, -1)
              : const Offset(0, 1),
          end: Offset.zero,
        ).animate(_animationController.enterAnimation);
        break;
      case ToastAnimation.fade:
        _fadeAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(_animationController.enterAnimation);
        break;
      case ToastAnimation.scale:
        _scaleAnimation = Tween<double>(
          begin: 0.5,
          end: 1,
        ).animate(_animationController.enterAnimation);
        break;
      case ToastAnimation.slideAndFade:
        _slideAnimation = Tween<Offset>(
          begin: config.position == ToastPosition.top
              ? const Offset(0, -0.5)
              : const Offset(0, 0.5),
          end: Offset.zero,
        ).animate(_animationController.enterAnimation);
        _fadeAnimation = Tween<double>(
          begin: 0,
          end: 1,
        ).animate(_animationController.enterAnimation);
        break;
    }
  }

  void _startEnterAnimation() {
    _animationController.enterController.forward();
  }

  void _scheduleAutoDismiss() {
    Future.delayed(widget.toast.config.duration, _dismissToast);
  }

  Future<void> _dismissToast() async {
    await _animationController.exitController.forward();
    widget.onDismiss();
  }

  @override
  Widget build(BuildContext context) {
    final config = widget.toast.config;
    final theme = widget.theme;
    final color = widget.toast.getColor(theme);

    Widget toastContent = Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(config.borderRadius),
        boxShadow: [
          BoxShadow(
            color: theme.shadow.color,
            blurRadius: theme.shadow.blurRadius,
            offset: theme.shadow.offset,
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: config.padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.toast.icon ?? widget.toast.getDefaultIcon(),
                color: theme.textColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.toast.message,
                  style: theme.textStyle.copyWith(color: theme.textColor),
                  textAlign: config.textAlign,
                ),
              ),
              if (widget.toast.actionLabel != null) ...[
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    widget.toast.onAction?.call();
                    _dismissToast();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: theme.textColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                  ),
                  child: Text(
                    widget.toast.actionLabel!,
                    style: theme.textStyle.copyWith(
                      color: theme.textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              if (config.dismissible) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(Icons.close, size: 16),
                  color: theme.textColor,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: _dismissToast,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    // Add progress bar if enabled
    if (config.showProgressBar) {
      toastContent = Stack(
        children: [
          toastContent,
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(
              value: 1.0,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation<Color>(
                config.progressBarColor ?? theme.textColor.withOpacity(0.3),
              ),
            ),
          ),
        ],
      );
    }

    // Apply animations
    switch (config.animation) {
      case ToastAnimation.slide:
        return SlideTransition(position: _slideAnimation, child: toastContent);
      case ToastAnimation.fade:
        return FadeTransition(opacity: _fadeAnimation, child: toastContent);
      case ToastAnimation.scale:
        return ScaleTransition(scale: _scaleAnimation, child: toastContent);
      case ToastAnimation.slideAndFade:
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(opacity: _fadeAnimation, child: toastContent),
        );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

// =============================================================================
// 🌟 Main Toast Container
// =============================================================================

class ToastContainer extends StatelessWidget {
  final List<ToastData> toasts;
  final ToastTheme theme;
  final Function(String) onDismiss;

  const ToastContainer({
    Key? key,
    required this.toasts,
    required this.theme,
    required this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: Column(
          children: [
            // Top toasts
            ..._buildToastsForPosition(ToastPosition.top),
            const Spacer(),
            // Center toasts
            ..._buildToastsForPosition(ToastPosition.center),
            const Spacer(),
            // Bottom toasts
            ..._buildToastsForPosition(ToastPosition.bottom),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildToastsForPosition(ToastPosition position) {
    final positionToasts = toasts
        .where((t) => t.config.position == position)
        .toList();

    if (positionToasts.isEmpty) return [];

    return [
      for (final toast in positionToasts)
        Padding(
          padding: toast.config.margin,
          child: Align(
            alignment: _getAlignment(toast.config.position),
            child: AnimatedToast(
              toast: toast,
              theme: theme,
              onDismiss: () => onDismiss(toast.id),
            ),
          ),
        ),
    ];
  }

  Alignment _getAlignment(ToastPosition position) {
    switch (position) {
      case ToastPosition.top:
        return Alignment.topCenter;
      case ToastPosition.bottom:
        return Alignment.bottomCenter;
      case ToastPosition.center:
        return Alignment.center;
    }
  }
}
 */