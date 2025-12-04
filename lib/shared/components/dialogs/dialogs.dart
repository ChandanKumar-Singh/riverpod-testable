part of './index.dart';

/// Ultra Dialog - A feature-rich, easy-to-use dialog system for Flutter
class UltraDialog {
  /// Shows a customizable dialog
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget Function(BuildContext) builder,

    // Layout
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.medium,
    Alignment alignment = Alignment.center,
    EdgeInsets margin = EdgeInsets.zero,
    bool useSafeArea = true,

    // Header & Footer
    Widget? header,
    Widget? footer,
    EdgeInsetsGeometry headerPadding = const EdgeInsets.fromLTRB(24, 24, 24, 0),
    EdgeInsetsGeometry footerPadding = const EdgeInsets.fromLTRB(24, 0, 24, 24),
    EdgeInsetsGeometry contentPadding = const EdgeInsets.all(24),

    // Animation
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    DialogAnimation animationType = DialogAnimation.scaleFade,
    bool barrierDismissible = true,
    Color? barrierColor,

    // Style
    double borderRadius = 20,
    Color? backgroundColor,
    double elevation = 8,
    bool blurBackground = false,
    double blurSigma = 3,

    // Controls
    bool showCloseButton = false,
    VoidCallback? onClose,
    Widget? closeIcon,

    // Behavior
    bool swipeToDismiss = false,
    SwipeDirection swipeDirection = SwipeDirection.down,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _UltraDialogPage(
          child: builder,
          type: type,
          size: size,
          alignment: alignment,
          margin: margin,
          useSafeArea: useSafeArea,
          header: header,
          footer: footer,
          headerPadding: headerPadding,
          footerPadding: footerPadding,
          contentPadding: contentPadding,
          borderRadius: borderRadius,
          backgroundColor: backgroundColor,
          elevation: elevation,
          showCloseButton: showCloseButton,
          onClose: onClose,
          closeIcon: closeIcon,
          swipeToDismiss: swipeToDismiss,
          swipeDirection: swipeDirection,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _UltraDialogTransition(
          animation: animation,
          type: animationType,
          curve: curve,
          blurBackground: blurBackground,
          blurSigma: blurSigma,
          child: child,
        );
      },
    );
  }

  /// Quick alert dialog
  static Future<void> alert({
    required BuildContext context,
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    Color? buttonColor,
    Widget? icon,
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.small,
  }) {
    final theme = Theme.of(context);

    return show(
      context: context,
      type: type,
      size: size,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[icon, const SizedBox(height: 16)],
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context);
                onPressed?.call();
              },
              style: FilledButton.styleFrom(
                backgroundColor: buttonColor ?? theme.colorScheme.primary,
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }

  /// Confirmation dialog
  static Future<bool> confirm({
    required BuildContext context,
    required String title,
    String? message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    bool destructive = false,
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.small,
  }) async {
    final theme = Theme.of(context);

    final result = await show<bool>(
      context: context,
      type: type,
      size: size,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: FilledButton.styleFrom(
                    backgroundColor: destructive
                        ? theme.colorScheme.error
                        : confirmColor ?? theme.colorScheme.primary,
                  ),
                  child: Text(confirmText),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Input dialog
  static Future<String?> input({
    required BuildContext context,
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = 'OK',
    String cancelText = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    bool autoFocus = true,
    int? maxLines,
    int? maxLength,
    String? Function(String?)? validator,
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.small,
  }) async {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: initialValue);
    final focusNode = FocusNode();
    String? error;

    return show<String?>(
      context: context,
      type: type,
      size: size,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                focusNode: focusNode,
                autofocus: autoFocus,
                keyboardType: keyboardType,
                maxLines: maxLines,
                maxLength: maxLength,
                decoration: InputDecoration(
                  hintText: hint,
                  errorText: error,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  if (validator != null) {
                    setState(() => error = validator(value));
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(cancelText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: error == null
                          ? () => Navigator.pop(context, controller.text)
                          : null,
                      child: Text(confirmText),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// Selection dialog
  static Future<T?> select<T>({
    required BuildContext context,
    required String title,
    required List<UltraDialogOption<T>> options,
    T? selected,
    bool searchable = false,
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.medium,
  }) async {
    final theme = Theme.of(context);
    List<UltraDialogOption<T>> filtered = options;
    TextEditingController? searchController;

    if (searchable) {
      searchController = TextEditingController();
    }

    return show<T?>(
      context: context,
      type: type,
      size: size,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (searchable) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      filtered = options.where((option) {
                        return option.label.toLowerCase().contains(
                          query.toLowerCase(),
                        );
                      }).toList();
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 300),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final option = filtered[index];
                    return ListTile(
                      leading: option.icon,
                      title: Text(option.label),
                      subtitle: option.subtitle != null
                          ? Text(option.subtitle!)
                          : null,
                      trailing: option.value == selected
                          ? Icon(Icons.check, color: theme.colorScheme.primary)
                          : null,
                      onTap: () => Navigator.pop(context, option.value),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Loading dialog (auto-closing)
  static Future<void> loading({
    required BuildContext context,
    String message = 'Loading...',
    bool dismissible = false,
    Duration? duration,
    Future<dynamic>? completer,
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.small,
  }) async {
    // Handle auto-dismiss based on duration or completer
    if (duration != null) {
      // Auto-dismiss after duration
      await Future.delayed(duration);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } else if (completer != null) {
      try {
        // Wait for the completer to finish
        await completer;
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } catch (e) {
        // If completer fails, still try to dismiss after a safe timeout
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        // Re-throw the error so caller knows it failed
        rethrow;
      }
    }
    // Show the loading dialog
    if (context.mounted) {
      await show(
        context: context,
        type: type,
        size: size,
        barrierDismissible: dismissible,
        builder: (context) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }
  }

  /// Success dialog (auto-closing)
  static void success({
    required BuildContext context,
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 2),
    Widget? icon,
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.small,
  }) {
    final theme = Theme.of(context);

    show(
      context: context,
      type: type,
      size: size,
      barrierDismissible: false,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon ??
              Icon(
                Icons.check_circle,
                color: theme.colorScheme.primary,
                size: 48,
              ),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    Future.delayed(duration, () {
      if (context.mounted) Navigator.pop(context);
    });
  }

  /// Error dialog
  static void error({
    required BuildContext context,
    required String title,
    String? message,
    String? details,
    DialogType type = DialogType.alert,
    DialogSize size = DialogSize.medium,
  }) {
    final theme = Theme.of(context);
    bool expanded = false;

    show(
      context: context,
      type: type,
      size: size,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(message),
              ],
              if (details != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => setState(() => expanded = !expanded),
                  icon: Icon(
                    expanded ? Icons.expand_less : Icons.expand_more,
                    size: 16,
                  ),
                  label: Text(expanded ? 'Hide Details' : 'Show Details'),
                ),
                if (expanded) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(details, style: theme.textTheme.bodySmall),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Dialog Page Widget
class _UltraDialogPage extends StatefulWidget {
  const _UltraDialogPage({
    required this.child,
    required this.type,
    required this.size,
    required this.alignment,
    required this.margin,
    required this.useSafeArea,
    required this.header,
    required this.footer,
    required this.headerPadding,
    required this.footerPadding,
    required this.contentPadding,
    required this.borderRadius,
    required this.backgroundColor,
    required this.elevation,
    required this.showCloseButton,
    required this.onClose,
    required this.closeIcon,
    required this.swipeToDismiss,
    required this.swipeDirection,
  });

  final Widget Function(BuildContext) child;
  final DialogType type;
  final DialogSize size;
  final Alignment alignment;
  final EdgeInsets margin;
  final bool useSafeArea;
  final Widget? header;
  final Widget? footer;
  final EdgeInsetsGeometry headerPadding;
  final EdgeInsetsGeometry footerPadding;
  final EdgeInsetsGeometry contentPadding;
  final double borderRadius;
  final Color? backgroundColor;
  final double elevation;
  final bool showCloseButton;
  final VoidCallback? onClose;
  final Widget? closeIcon;
  final bool swipeToDismiss;
  final SwipeDirection swipeDirection;

  @override
  State<_UltraDialogPage> createState() => _UltraDialogPageState();
}

class _UltraDialogPageState extends State<_UltraDialogPage> {
  double _offset = 0;
  bool _swiping = false;

  void _onSwipeStart(DragStartDetails details) {
    if (!widget.swipeToDismiss) return;
    _swiping = true;
  }

  void _onSwipeUpdate(DragUpdateDetails details) {
    if (!_swiping) return;

    final delta = _getDelta(details);
    setState(() => _offset += delta);

    // Prevent dragging up for downward swipes
    if (widget.swipeDirection == SwipeDirection.down && _offset < 0) {
      _offset = 0;
    }
  }

  void _onSwipeEnd(DragEndDetails details) {
    if (!_swiping) return;

    final velocity = _getVelocity(details);
    final shouldDismiss = _offset.abs() > 100 || velocity.abs() > 500;

    if (shouldDismiss) {
      Navigator.pop(context);
      widget.onClose?.call();
    } else {
      setState(() => _offset = 0);
    }

    _swiping = false;
  }

  double _getDelta(DragUpdateDetails details) {
    switch (widget.swipeDirection) {
      case SwipeDirection.down:
        return details.delta.dy;
      case SwipeDirection.up:
        return -details.delta.dy;
      case SwipeDirection.left:
        return -details.delta.dx;
      case SwipeDirection.right:
        return details.delta.dx;
      case SwipeDirection.any:
        return details.delta.distance;
    }
  }

  double _getVelocity(DragEndDetails details) {
    switch (widget.swipeDirection) {
      case SwipeDirection.down:
        return details.velocity.pixelsPerSecond.dy;
      case SwipeDirection.up:
        return -details.velocity.pixelsPerSecond.dy;
      case SwipeDirection.left:
        return -details.velocity.pixelsPerSecond.dx;
      case SwipeDirection.right:
        return details.velocity.pixelsPerSecond.dx;
      case SwipeDirection.any:
        return details.velocity.pixelsPerSecond.distance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    double maxWidth;
    double maxHeight;

    switch (widget.size) {
      case DialogSize.small:
        maxWidth = 400;
        maxHeight = size.height * 0.6;
      case DialogSize.medium:
        maxWidth = 560;
        maxHeight = size.height * 0.7;
      case DialogSize.large:
        maxWidth = 720;
        maxHeight = size.height * 0.8;
      case DialogSize.fullWidth:
        maxWidth = size.width - 32;
        maxHeight = size.height * 0.9;
    }

    Widget content = Container(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
      margin: widget.margin,
      child: Material(
        color: widget.backgroundColor ?? theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        elevation: widget.elevation,
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                if (widget.header != null)
                  Padding(padding: widget.headerPadding, child: widget.header),

                // Content
                Flexible(
                  fit: FlexFit.loose,
                  child: Padding(
                    padding: widget.contentPadding,
                    child: widget.child(context),
                  ),
                ),

                // Footer
                if (widget.footer != null)
                  Padding(padding: widget.footerPadding, child: widget.footer),
              ],
            ),

            // Close button
            if (widget.showCloseButton)
              Positioned(
                top: 12,
                right: 12,
                child:
                    widget.closeIcon ??
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                        widget.onClose?.call();
                      },
                    ),
              ),
          ],
        ),
      ),
    );

    if (widget.swipeToDismiss) {
      content = GestureDetector(
        onPanStart: _onSwipeStart,
        onPanUpdate: _onSwipeUpdate,
        onPanEnd: _onSwipeEnd,
        child: Transform.translate(offset: Offset(0, _offset), child: content),
      );
    }

    // Adjust alignment based on dialog type
    Alignment adjustedAlignment = widget.alignment;
    if (widget.type == DialogType.bottomSheet) {
      adjustedAlignment = Alignment.bottomCenter;
    } else if (widget.type == DialogType.fullScreen) {
      return content; // Full screen doesn't need alignment or safe area
    }

    return SafeArea(
      top: widget.useSafeArea,
      bottom: widget.useSafeArea,
      left: widget.useSafeArea,
      right: widget.useSafeArea,
      child: Align(alignment: adjustedAlignment, child: content),
    );
  }
}

/// Dialog Transition
class _UltraDialogTransition extends StatelessWidget {
  const _UltraDialogTransition({
    required this.animation,
    required this.type,
    required this.curve,
    required this.blurBackground,
    required this.blurSigma,
    required this.child,
  });

  final Animation<double> animation;
  final DialogAnimation type;
  final Curve curve;
  final bool blurBackground;
  final double blurSigma;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(parent: animation, curve: curve);

    Widget animatedChild = AnimatedBuilder(
      animation: curved,
      builder: (context, child) {
        switch (type) {
          case DialogAnimation.scaleFade:
            return Transform.scale(
              scale: 0.8 + 0.2 * curved.value,
              child: Opacity(opacity: curved.value, child: child),
            );
          case DialogAnimation.slideUp:
            return Transform.translate(
              offset: Offset(0, 50 * (1 - curved.value)),
              child: Opacity(opacity: curved.value, child: child),
            );
          case DialogAnimation.slideDown:
            return Transform.translate(
              offset: Offset(0, -50 * (1 - curved.value)),
              child: Opacity(opacity: curved.value, child: child),
            );
          case DialogAnimation.fade:
            return Opacity(opacity: curved.value, child: child);
        }
      },
      child: child,
    );

    if (blurBackground) {
      animatedChild = Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurSigma * animation.value,
              sigmaY: blurSigma * animation.value,
            ),
            child: Container(color: Colors.transparent),
          ),
          animatedChild,
        ],
      );
    }

    return animatedChild;
  }
}

/// Pre-built dialog components

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(24, 24, 24, 16),
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class DialogFooter extends StatelessWidget {
  const DialogFooter({
    required this.children,
    super.key,
    this.padding = const EdgeInsets.all(24),
    this.direction = Axis.horizontal,
    this.mainAxisAlignment = MainAxisAlignment.end,
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final Axis direction;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: direction == Axis.horizontal
          ? Row(
              mainAxisAlignment: mainAxisAlignment,
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  if (i > 0) const SizedBox(width: 12),
                  children[i],
                ],
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  if (i > 0) const SizedBox(height: 12),
                  children[i],
                ],
              ],
            ),
    );
  }
}

/// Data Classes

class UltraDialogOption<T> {
  const UltraDialogOption({
    required this.label,
    required this.value,
    this.subtitle,
    this.icon,
  });

  final String label;
  final T value;
  final String? subtitle;
  final Widget? icon;
}

/// Enums

enum DialogType { centered, alert, bottomSheet, fullScreen }

enum DialogSize { small, medium, large, fullWidth }

enum DialogAnimation { scaleFade, slideUp, slideDown, fade }

enum SwipeDirection { up, down, left, right, any }

/// Usage Examples
/*
// Basic usage with header and footer
UltraDialog.show(
  context: context,
  header: DialogHeader(
    title: 'Custom Dialog',
    subtitle: 'With header and footer',
    leading: Icon(Icons.info),
  ),
  footer: DialogFooter(
    children: [
      OutlinedButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Confirm'),
      ),
    ],
  ),
  child: Text('Your content here'),
);

// Alert
UltraDialog.alert(
  context: context,
  title: 'Alert!',
  message: 'Something happened',
);

// Confirm
final confirmed = await UltraDialog.confirm(
  context: context,
  title: 'Delete?',
  message: 'Cannot be undone',
  destructive: true,
);

// Input
final name = await UltraDialog.input(
  context: context,
  title: 'Enter Name',
  hint: 'John Doe',
);

// Select
final option = await UltraDialog.select(
  context: context,
  title: 'Choose',
  options: [
    UltraDialogOption(label: 'Option 1', value: 1),
    UltraDialogOption(label: 'Option 2', value: 2),
  ],
);

// Loading
UltraDialog.loading(context: context);

// Success (auto-closes)
UltraDialog.success(
  context: context,
  title: 'Success!',
  message: 'Action completed',
);

// Error
UltraDialog.error(
  context: context,
  title: 'Error',
  message: 'Something went wrong',
  details: 'Technical details here',
);

// Custom dialog with swipe to dismiss
UltraDialog.show(
  context: context,
  child: YourContent(),
  swipeToDismiss: true,
  showCloseButton: true,
  blurBackground: true,
);
*/
