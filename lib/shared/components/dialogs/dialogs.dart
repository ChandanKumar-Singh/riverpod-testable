part of './index.dart';

/// Next-level dialog system with advanced animations, blur effects,
/// custom layouts, and rich interaction capabilities.
class UltraDialog {
  /// Shows a modern dialog with extensive customization options
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,

    /// Layout & Structure
    DialogType type = DialogType.centered,
    DialogSize size = DialogSize.medium,
    Alignment alignment = Alignment.center,
    EdgeInsets margin = EdgeInsets.zero,
    bool useSafeArea = true,

    /// Animation & Behavior
    Duration enterDuration = const Duration(milliseconds: 400),
    Duration exitDuration = const Duration(milliseconds: 300),
    Curve enterCurve = Curves.easeOutCubic,
    Curve exitCurve = Curves.easeInCubic,
    DialogAnimation animationType = DialogAnimation.scaleFade,
    bool barrierDismissible = true,
    Color? barrierColor,

    /// Visual Design
    double borderRadius = 20,
    Color? backgroundColor,
    Color? surfaceTintColor,
    double elevation = 8,
    bool blurBackground = true,
    double blurSigma = 3.0,
    bool showShadow = true,
    BoxConstraints? constraints,

    /// Header & Footer
    Widget? header,
    Widget? footer,
    bool showCloseButton = true,
    VoidCallback? onClosePressed,
    Widget? customCloseButton,

    /// Interaction
    bool enableSwipeToDismiss = true,
    SwipeDirection swipeDirection = SwipeDirection.down,
    double swipeThreshold = 0.3,
    bool enableHaptics = true,

    /// Content Behavior
    bool scrollable = false,
    ScrollController? scrollController,
    bool dismissOnScroll = false,
    double dismissScrollThreshold = 100,

    /// Callbacks
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    VoidCallback? onSwipeStart,
    VoidCallback? onSwipeCancel,
    ValueChanged<double>? onSwipeUpdate,
  }) async {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor:
          barrierColor ??
          (blurBackground
              ? Colors.black.withOpacity(0.6)
              : Colors.black.withOpacity(0.5)),
      transitionDuration: enterDuration,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return _UltraDialogTransition(
          animation: animation,
          type: animationType,
          blurBackground: blurBackground,
          blurSigma: blurSigma,
          child: child,
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return WillPopScope(
          onWillPop: () async {
            if (barrierDismissible) {
              onClosed?.call();
            }
            return barrierDismissible;
          },
          child: SafeArea(
            top: useSafeArea,
            bottom: useSafeArea,
            left: useSafeArea,
            right: useSafeArea,
            child: _UltraDialogContent(
              type: type,
              size: size,
              alignment: alignment,
              margin: margin,
              borderRadius: borderRadius,
              backgroundColor: backgroundColor ?? theme.colorScheme.surface,
              surfaceTintColor: surfaceTintColor,
              elevation: elevation,
              showShadow: showShadow,
              constraints: constraints,
              header: header,
              footer: footer,
              showCloseButton: showCloseButton,
              onClosePressed: onClosePressed,
              customCloseButton: customCloseButton,
              enableSwipeToDismiss: enableSwipeToDismiss,
              swipeDirection: swipeDirection,
              swipeThreshold: swipeThreshold,
              enableHaptics: enableHaptics,
              scrollable: scrollable,
              scrollController: scrollController,
              dismissOnScroll: dismissOnScroll,
              dismissScrollThreshold: dismissScrollThreshold,
              onOpened: onOpened,
              onClosed: onClosed,
              onSwipeStart: onSwipeStart,
              onSwipeCancel: onSwipeCancel,
              onSwipeUpdate: onSwipeUpdate,
              child: child,
            ),
          ),
        );
      },
    ).then((value) {
      onClosed?.call();
      return value;
    });
  }

  /// Quick confirmation dialog
  static Future<bool?> confirm({
    required BuildContext context,
    required String title,
    String? description,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    Color? cancelColor,
    DialogType type = DialogType.alert,
    bool destructive = false,
  }) async {
    final theme = Theme.of(context);

    return show<bool>(
      context: context,
      type: type,
      size: DialogSize.small,
      showCloseButton: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description,
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
                  onPressed: () => Navigator.of(context).pop(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cancelColor ?? theme.colorScheme.onSurface,
                  ),
                  child: Text(cancelText),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(true),
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
  }

  /// Input dialog for text input
  static Future<String?> input({
    required BuildContext context,
    required String title,
    String? hintText,
    String? initialValue,
    String confirmText = 'Done',
    String cancelText = 'Cancel',
    TextInputType keyboardType = TextInputType.text,
    bool autoFocus = true,
    int? maxLines = 1,
    int? maxLength,
    String? Function(String?)? validator,
  }) async {
    final theme = Theme.of(context);
    final controller = TextEditingController(text: initialValue);
    final focusNode = FocusNode();
    String? errorText;

    return show<String>(
      context: context,
      type: DialogType.alert,
      size: DialogSize.small,
      showCloseButton: false,
      child: StatefulBuilder(
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
                  hintText: hintText,
                  errorText: errorText,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  if (validator != null) {
                    setState(() {
                      errorText = validator(value);
                    });
                  }
                },
                onSubmitted: (value) {
                  if (errorText == null) {
                    Navigator.of(context).pop(value);
                  }
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(cancelText),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: errorText == null
                          ? () => Navigator.of(context).pop(controller.text)
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

  /// Selection dialog for choosing from options
  static Future<T?> select<T>({
    required BuildContext context,
    required String title,
    required List<DialogOption<T>> options,
    T? initialValue,
    bool searchable = false,
  }) async {
    final theme = Theme.of(context);
    List<DialogOption<T>> filteredOptions = options;
    TextEditingController? searchController;

    if (searchable) {
      searchController = TextEditingController();
    }

    return show<T>(
      context: context,
      type: DialogType.alert,
      size: DialogSize.medium,
      showCloseButton: true,
      child: StatefulBuilder(
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
                      filteredOptions = options.where((option) {
                        return option.label.toLowerCase().contains(
                          query.toLowerCase(),
                        );
                      }).toList();
                    });
                  },
                ),
              ],
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredOptions.length,
                  itemBuilder: (context, index) {
                    final option = filteredOptions[index];
                    final isSelected = option.value == initialValue;

                    return ListTile(
                      leading: option.icon,
                      title: Text(option.label),
                      subtitle: option.subtitle != null
                          ? Text(option.subtitle!)
                          : null,
                      trailing: isSelected
                          ? Icon(Icons.check, color: theme.colorScheme.primary)
                          : null,
                      onTap: () => Navigator.of(context).pop(option.value),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
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

  /// Loading dialog
  static Future<void> loading({
    required BuildContext context,
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    return show(
      context: context,
      type: DialogType.centered,
      size: DialogSize.small,
      barrierDismissible: barrierDismissible,
      showCloseButton: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }

  /// Success dialog
  static Future<void> success({
    required BuildContext context,
    required String title,
    String? description,
    Duration autoCloseDuration = const Duration(seconds: 2),
  }) async {
    final theme = Theme.of(context);

    await show(
      context: context,
      type: DialogType.centered,
      size: DialogSize.small,
      showCloseButton: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 48),
          const SizedBox(height: 16),
          Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (description != null) ...[
            const SizedBox(height: 8),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );

    if (autoCloseDuration != Duration.zero) {
      await Future.delayed(autoCloseDuration);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  /// Error dialog
  static Future<void> error({
    required BuildContext context,
    required String title,
    String? description,
    String? errorDetails,
  }) {
    final theme = Theme.of(context);
    bool showDetails = false;

    return show(
      context: context,
      type: DialogType.alert,
      size: DialogSize.medium,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.error,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              if (description != null) ...[
                const SizedBox(height: 12),
                Text(description),
              ],
              if (errorDetails != null) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () {
                    setState(() {
                      showDetails = !showDetails;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(showDetails ? 'Hide Details' : 'Show Details'),
                      const SizedBox(width: 8),
                      Icon(
                        showDetails ? Icons.expand_less : Icons.expand_more,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                if (showDetails) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(errorDetails, style: theme.textTheme.bodySmall),
                  ),
                ],
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  const Spacer(),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Dialog content widget
class _UltraDialogContent extends StatefulWidget {
  const _UltraDialogContent({
    required this.child,
    required this.type,
    required this.size,
    required this.alignment,
    required this.margin,
    required this.borderRadius,
    required this.backgroundColor,
    required this.surfaceTintColor,
    required this.elevation,
    required this.showShadow,
    required this.constraints,
    required this.header,
    required this.footer,
    required this.showCloseButton,
    required this.onClosePressed,
    required this.customCloseButton,
    required this.enableSwipeToDismiss,
    required this.swipeDirection,
    required this.swipeThreshold,
    required this.enableHaptics,
    required this.scrollable,
    required this.scrollController,
    required this.dismissOnScroll,
    required this.dismissScrollThreshold,
    required this.onOpened,
    required this.onClosed,
    required this.onSwipeStart,
    required this.onSwipeCancel,
    required this.onSwipeUpdate,
  });

  final Widget child;
  final DialogType type;
  final DialogSize size;
  final Alignment alignment;
  final EdgeInsets margin;
  final double borderRadius;
  final Color backgroundColor;
  final Color? surfaceTintColor;
  final double elevation;
  final bool showShadow;
  final BoxConstraints? constraints;
  final Widget? header;
  final Widget? footer;
  final bool showCloseButton;
  final VoidCallback? onClosePressed;
  final Widget? customCloseButton;
  final bool enableSwipeToDismiss;
  final SwipeDirection swipeDirection;
  final double swipeThreshold;
  final bool enableHaptics;
  final bool scrollable;
  final ScrollController? scrollController;
  final bool dismissOnScroll;
  final double dismissScrollThreshold;
  final VoidCallback? onOpened;
  final VoidCallback? onClosed;
  final VoidCallback? onSwipeStart;
  final VoidCallback? onSwipeCancel;
  final ValueChanged<double>? onSwipeUpdate;

  @override
  State<_UltraDialogContent> createState() => _UltraDialogContentState();
}

class _UltraDialogContentState extends State<_UltraDialogContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _swipeController;
  double _swipeOffset = 0.0;
  bool _isSwiping = false;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onOpened?.call();
    });
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _handleClose() {
    if (widget.onClosePressed != null) {
      widget.onClosePressed!();
      return;
    }
    Navigator.of(context).pop();
    widget.onClosed?.call();
  }

  void _onSwipeStart(DragStartDetails details) {
    if (!widget.enableSwipeToDismiss) return;

    _isSwiping = true;
    widget.onSwipeStart?.call();

    if (widget.enableHaptics) {
      HapticFeedback.lightImpact();
    }
  }

  void _onSwipeUpdate(DragUpdateDetails details) {
    if (!_isSwiping) return;

    final delta = _getSwipeDelta(details);
    _swipeOffset += delta;

    widget.onSwipeUpdate?.call(_swipeOffset.abs());

    // Calculate opacity and scale based on swipe progress
    final progress = (_swipeOffset.abs() / 100).clamp(0.0, 1.0);
    _swipeController.value = progress;
  }

  void _onSwipeEnd(DragEndDetails details) {
    if (!_isSwiping) return;

    final velocity = _getSwipeVelocity(details);
    final shouldDismiss =
        _swipeOffset.abs() > widget.swipeThreshold * 100 || velocity > 1.0;

    if (shouldDismiss) {
      Navigator.of(context).pop();
      widget.onClosed?.call();
    } else {
      _swipeController.reverse();
      widget.onSwipeCancel?.call();
    }

    _swipeOffset = 0.0;
    _isSwiping = false;
  }

  double _getSwipeDelta(DragUpdateDetails details) {
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

  double _getSwipeVelocity(DragEndDetails details) {
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
    final media = MediaQuery.of(context);
    final maxWidth = _getMaxWidth(media.size.width);
    final maxHeight = media.size.height * 0.9;

    Widget content = Container(
      constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
      margin: widget.margin,
      child: Material(
        color: widget.backgroundColor,
        surfaceTintColor: widget.surfaceTintColor,
        elevation: widget.elevation,
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: AnimatedBuilder(
          animation: _swipeController,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _swipeOffset),
              child: Transform.scale(
                scale: 1.0 - _swipeController.value * 0.1,
                child: Opacity(
                  opacity: 1.0 - _swipeController.value * 0.3,
                  child: child,
                ),
              ),
            );
          },
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                if (widget.header != null || widget.showCloseButton) ...[
                  Stack(
                    children: [
                      if (widget.header != null) widget.header!,
                      if (widget.showCloseButton) ...[
                        Positioned(
                          top: 12,
                          right: 12,
                          child:
                              widget.customCloseButton ??
                              DialogCloseButton(onPressed: _handleClose),
                        ),
                      ],
                    ],
                  ),
                ],

                // Content section - FIXED: No Flexible/Expanded
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: widget.scrollable
                      ? SingleChildScrollView(
                          controller: widget.scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: widget.child,
                        )
                      : widget.child,
                ),

                // Footer
                if (widget.footer != null) widget.footer!,
              ],
            ),
          ),
        ),
      ),
    );

    // Add swipe gesture detection
    if (widget.enableSwipeToDismiss) {
      content = GestureDetector(
        onPanStart: _onSwipeStart,
        onPanUpdate: _onSwipeUpdate,
        onPanEnd: _onSwipeEnd,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return Align(alignment: widget.alignment, child: content);
  }

  double _getMaxWidth(double screenWidth) {
    switch (widget.size) {
      case DialogSize.small:
        return 400;
      case DialogSize.medium:
        return 560;
      case DialogSize.large:
        return 720;
      case DialogSize.fullWidth:
        return screenWidth - 32;
    }
  }
}

/// Dialog transition animations
class _UltraDialogTransition extends StatelessWidget {
  const _UltraDialogTransition({
    required this.animation,
    required this.type,
    required this.child,
    required this.blurBackground,
    required this.blurSigma,
  });

  final Animation<double> animation;
  final DialogAnimation type;
  final Widget child;
  final bool blurBackground;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
    );

    Widget animatedChild = AnimatedBuilder(
      animation: curvedAnimation,
      builder: (context, child) {
        switch (type) {
          case DialogAnimation.scaleFade:
            return Transform.scale(
              scale: 0.8 + 0.2 * curvedAnimation.value,
              child: Opacity(opacity: curvedAnimation.value, child: child),
            );
          case DialogAnimation.slideUp:
            return Transform.translate(
              offset: Offset(0, 50 * (1 - curvedAnimation.value)),
              child: Opacity(opacity: curvedAnimation.value, child: child),
            );
          case DialogAnimation.slideDown:
            return Transform.translate(
              offset: Offset(0, -50 * (1 - curvedAnimation.value)),
              child: Opacity(opacity: curvedAnimation.value, child: child),
            );
          case DialogAnimation.fade:
            return Opacity(opacity: curvedAnimation.value, child: child);
        }
      },
      child: child,
    );

    if (blurBackground) {
      animatedChild = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma * animation.value,
          sigmaY: blurSigma * animation.value,
        ),
        child: animatedChild,
      );
    }

    return animatedChild;
  }
}

/// Pre-built dialog components

class DialogCloseButton extends StatelessWidget {
  const DialogCloseButton({
    required this.onPressed,
    super.key,
    this.icon = Icons.close,
    this.size = 24,
    this.padding = const EdgeInsets.all(8),
    this.color,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final EdgeInsetsGeometry padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return IconButton(
      icon: Icon(icon, size: size),
      color: color ?? theme.colorScheme.onSurface.withOpacity(0.7),
      padding: padding,
      constraints: BoxConstraints(minWidth: size + 16, minHeight: size + 16),
      onPressed: onPressed,
    );
  }
}

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.fromLTRB(24, 20, 24, 16),
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
                  Expanded(child: children[i]),
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

/// Enums and data classes

enum DialogType { centered, alert, bottomSheet, fullScreen }

enum DialogSize { small, medium, large, fullWidth }

enum DialogAnimation { scaleFade, slideUp, slideDown, fade }

enum SwipeDirection { up, down, left, right, any }

class DialogOption<T> {
  const DialogOption({
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

/// Usage examples:
/*
// Basic dialog
UltraDialog.show(
  context: context,
  child: Text('Hello World'),
);

// Confirmation dialog
final confirmed = await UltraDialog.confirm(
  context: context,
  title: 'Delete Item?',
  description: 'This action cannot be undone.',
  destructive: true,
);

// Input dialog
final result = await UltraDialog.input(
  context: context,
  title: 'Enter Name',
  hintText: 'John Doe',
  validator: (value) {
    if (value?.isEmpty ?? true) return 'Please enter a name';
    return null;
  },
);

// Selection dialog
final choice = await UltraDialog.select(
  context: context,
  title: 'Choose Option',
  options: [
    DialogOption(label: 'Option 1', value: 1),
    DialogOption(label: 'Option 2', value: 2),
    DialogOption(label: 'Option 3', value: 3),
  ],
  searchable: true,
);

// Loading dialog
UltraDialog.loading(context: context, message: 'Processing...');

// Success dialog
UltraDialog.success(
  context: context,
  title: 'Success!',
  description: 'Your changes have been saved.',
);

// Error dialog
UltraDialog.error(
  context: context,
  title: 'Error',
  description: 'Something went wrong.',
  errorDetails: 'Detailed error message here...',
);

// Advanced custom dialog
UltraDialog.show(
  context: context,
  type: DialogType.centered,
  size: DialogSize.medium,
  animation: DialogAnimation.slideUp,
  blurBackground: true,
  enableSwipeToDismiss: true,
  header: DialogHeader(
    title: 'Custom Dialog',
    subtitle: 'With advanced features',
    trailing: Icon(Icons.info),
  ),
  footer: DialogFooter(
    children: [
      OutlinedButton(
        onPressed: () => Navigator.pop(context),
        child: Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text('Confirm'),
      ),
    ],
  ),
  child: YourCustomContent(),
);
*/
