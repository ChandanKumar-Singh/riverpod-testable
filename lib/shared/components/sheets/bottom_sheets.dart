part of './index.dart';

/// Next-level bottom sheet with snap points, drag physics, scroll, blur,
/// dismissal gestures, and fully customizable UI.
class UltraSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,

    /// Heights from 0.0 to 1.0 (screen fraction)
    List<double> snapPoints = const [0.35, 0.65, 0.92],

    /// Default opened at
    double initialSnap = 0.65,

    /// UI options
    bool blurBackground = true,
    double blurSigma = 0.5,
    bool barrierDismissible = true,
    double radius = 24,
    Duration duration = const Duration(milliseconds: 350),
    Curve curve = Curves.easeOutCubic,
    Color? backgroundColor,
    Color? barrierColor,

    /// Header options
    Widget? titleBar,
    bool showHandle = true,
    Widget? customHandle,
    bool showCloseButton = false,
    VoidCallback? onClosePressed,
    Widget? customCloseButton,

    /// Content behavior
    bool enableDrag = true,
    bool enableScroll = true,
    bool expandContent = false,
    ScrollController? externalScrollController,

    /// Advanced features
    bool enableSpringPhysics = true,
    bool showEdgeGlow = true,
    bool autoPadBottom = true,
    bool handleKeyboard = true,
    bool enableHaptics = true,
    double pullToCloseThreshold = 0.3,
    bool showShadowOnScroll = true,
    bool enableBackgroundTap = true,

    /// Callbacks
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    ValueChanged<double>? onSnapChanged,
    ValueChanged<bool>? onDragUpdate,
    VoidCallback? onClose,

    /// Layout components
    Widget? stickyHeader,
    Widget? floatingActionButton,
    Widget? bottomBar,

    /// Animation
    bool animateEntrance = true,
    bool animateExit = true,
  }) async {
    final controller = DraggableScrollableController();
    final media = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    // Track current state
    double? lastSnapPoint;
    bool isDragging = false;

    // Setup controller listeners
    void onControllerChange() {
      final currentSize = controller.size;

      // Detect snap point changes
      final closestSnap = _findClosestSnapPoint(currentSize, snapPoints);
      if (closestSnap != lastSnapPoint) {
        lastSnapPoint = closestSnap;
        onSnapChanged?.call(closestSnap);

        // Haptic feedback on snap change
        if (enableHaptics && isDragging) {
          HapticFeedback.lightImpact();
        }
      }

      // Drag state tracking
      final nowDragging =
          controller.isAttached && (controller.pixels != 0 || isDragging);
      if (nowDragging != isDragging) {
        isDragging = nowDragging;
        onDragUpdate?.call(isDragging);
      }
    }

    controller.addListener(onControllerChange);

    // Open to initial snap location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.isAttached) {
        controller.animateTo(initialSnap, duration: duration, curve: curve);
      }
      onOpened?.call();
    });

    final result = await showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      // barrierColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: barrierDismissible,
      useSafeArea: true,
      transitionAnimationController: animateEntrance
          ? null
          : AnimationController(
              vsync: Navigator.of(context),
              duration: Duration.zero,
            ),
      builder: (context) {
        return _UltraSheetContent(
          controller: controller,
          snapPoints: snapPoints,
          blurBackground: blurBackground,
          blurSigma: blurSigma,
          barrierDismissible: barrierDismissible,
          radius: radius,
          backgroundColor: backgroundColor ?? theme.colorScheme.surface,
          barrierColor: barrierColor ?? Colors.black.withOpacity(0.0),
          titleBar: titleBar,
          showHandle: showHandle,
          customHandle: customHandle,
          showCloseButton: showCloseButton,
          onClosePressed: onClosePressed,
          customCloseButton: customCloseButton,
          enableDrag: enableDrag,
          enableScroll: enableScroll,
          expandContent: expandContent,
          externalScrollController: externalScrollController,
          enableSpringPhysics: enableSpringPhysics,
          showEdgeGlow: showEdgeGlow,
          autoPadBottom: autoPadBottom,
          handleKeyboard: handleKeyboard,
          pullToCloseThreshold: pullToCloseThreshold,
          showShadowOnScroll: showShadowOnScroll,
          enableBackgroundTap: enableBackgroundTap,
          stickyHeader: stickyHeader,
          floatingActionButton: floatingActionButton,
          bottomBar: bottomBar,
          onClosed: () {
            onClosed?.call();
            onClose?.call();
          },
          child: child,
        );
      },
    );

    // Cleanup
    controller.removeListener(onControllerChange);

    return result;
  }

  static double _findClosestSnapPoint(double value, List<double> snapPoints) {
    if (snapPoints.isEmpty) return value;

    double closest = snapPoints.first;
    for (final point in snapPoints) {
      if ((point - value).abs() < (closest - value).abs()) {
        closest = point;
      }
    }
    return closest;
  }
}

class _UltraSheetContent extends StatefulWidget {
  const _UltraSheetContent({
    required this.controller,
    required this.child,
    required this.snapPoints,
    required this.blurBackground,
    required this.blurSigma,
    required this.barrierDismissible,
    required this.radius,
    required this.backgroundColor,
    required this.barrierColor,
    required this.showHandle,
    required this.enableDrag,
    required this.enableScroll,
    required this.expandContent,
    required this.enableSpringPhysics,
    required this.showEdgeGlow,
    required this.autoPadBottom,
    required this.handleKeyboard,
    required this.pullToCloseThreshold,
    required this.showShadowOnScroll,
    required this.enableBackgroundTap,
    this.titleBar,
    this.customHandle,
    this.showCloseButton = false,
    this.onClosePressed,
    this.customCloseButton,
    this.externalScrollController,
    this.stickyHeader,
    this.floatingActionButton,
    this.bottomBar,
    this.onClosed,
  });

  final DraggableScrollableController controller;
  final Widget child;
  final List<double> snapPoints;
  final bool blurBackground;
  final double blurSigma;
  final bool barrierDismissible;
  final double radius;
  final Color backgroundColor;
  final Color barrierColor;
  final Widget? titleBar;
  final bool showHandle;
  final Widget? customHandle;
  final bool showCloseButton;
  final VoidCallback? onClosePressed;
  final Widget? customCloseButton;
  final bool enableDrag;
  final bool enableScroll;
  final bool expandContent;
  final bool enableSpringPhysics;
  final bool showEdgeGlow;
  final bool autoPadBottom;
  final bool handleKeyboard;
  final double pullToCloseThreshold;
  final bool showShadowOnScroll;
  final bool enableBackgroundTap;
  final ScrollController? externalScrollController;
  final Widget? stickyHeader;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final VoidCallback? onClosed;

  @override
  State<_UltraSheetContent> createState() => _UltraSheetContentState();
}

class _UltraSheetContentState extends State<_UltraSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _shadowController;
  late ScrollController _internalScrollController;
  ScrollController get _effectiveScrollController =>
      widget.externalScrollController ?? _internalScrollController;

  bool _showTopShadow = false;
  bool _isScrollControllerAttached = false;

  @override
  void initState() {
    super.initState();

    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _internalScrollController = ScrollController();

    // Setup scroll controller listener
    if (widget.showShadowOnScroll) {
      _effectiveScrollController.addListener(_updateShadow);
    }

    // Check initial attachment
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkScrollControllerAttachment();
    });

    widget.controller.addListener(_handleControllerChange);
  }

  void _checkScrollControllerAttachment() {
    final hasPositions = _effectiveScrollController.hasClients;
    if (hasPositions != _isScrollControllerAttached) {
      setState(() {
        _isScrollControllerAttached = hasPositions;
      });
    }
  }

  void _handleControllerChange() {
    // Handle pull-to-close threshold
    if (widget.controller.size < widget.pullToCloseThreshold &&
        widget.controller.pixels < -50) {
      _closeSheet();
    }
  }

  void _updateShadow() {
    if (!_effectiveScrollController.hasClients) return;

    final shouldShow = _effectiveScrollController.offset > 0;
    if (shouldShow != _showTopShadow) {
      setState(() {
        _showTopShadow = shouldShow;
      });
      if (shouldShow) {
        _shadowController.forward();
      } else {
        _shadowController.reverse();
      }
    }
  }

  void _closeSheet() {
    Navigator.of(context).pop();
    widget.onClosed?.call();
  }

  void _handleClosePressed() {
    if (widget.onClosePressed != null) {
      widget.onClosePressed!();
      return;
    }
    _closeSheet();
  }

  @override
  void dispose() {
    _shadowController.dispose();
    // Only dispose internal controller, not external ones
    if (widget.externalScrollController == null) {
      _internalScrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Background barrier with blur
        if (widget.enableBackgroundTap)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.barrierDismissible ? _closeSheet : null,
            child: widget.blurBackground
                ? BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: widget.blurSigma,
                      sigmaY: widget.blurSigma,
                    ),
                    child: Container(color: widget.barrierColor),
                  )
                : Container(color: widget.barrierColor),
          ),

        // Main sheet content
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: widget.handleKeyboard ? media.viewInsets.bottom : 0,
                  ),
                  child: DraggableScrollableSheet(
                    controller: widget.controller,
                    expand: widget.expandContent,
                    minChildSize: widget.snapPoints.first,
                    maxChildSize: widget.snapPoints.last,
                    initialChildSize: widget.snapPoints.first,
                    snap: true,
                    snapSizes: widget.snapPoints,
                    builder: (context, scrollController) {
                      return AnimatedBuilder(
                        animation: _shadowController,
                        builder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: widget.backgroundColor,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(widget.radius),
                              ),
                              boxShadow: _showTopShadow
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(
                                          0.15 * _shadowController.value,
                                        ),
                                        blurRadius: 12,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 16,
                                        spreadRadius: -8,
                                        offset: const Offset(0, -4),
                                      ),
                                    ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Header section
                                _buildHeaderSection(),

                                // Sticky header
                                if (widget.stickyHeader != null)
                                  widget.stickyHeader!,

                                // Main content
                                Expanded(
                                  child: _buildContent(scrollController),
                                ),

                                // Bottom bar
                                if (widget.bottomBar != null) widget.bottomBar!,
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),

                // Close button
                if (widget.showCloseButton) ...[
                  Positioned(
                    right: 0,
                    child:
                        widget.customCloseButton ??
                        SheetCloseButton(onPressed: _handleClosePressed),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Floating Action Button inside sheet
        if (widget.floatingActionButton != null)
          Positioned(
            bottom: 24 + media.viewInsets.bottom,
            right: 24,
            child: widget.floatingActionButton!,
          ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Handle with close button
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Handle
              if (widget.showHandle) widget.customHandle ?? const SheetHandle(),
            ],
          ),
        ),

        // Title bar
        if (widget.titleBar != null) widget.titleBar!,
      ],
    );
  }

  Widget _buildContent(ScrollController draggableScrollController) {
    final physics = widget.enableSpringPhysics
        ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
        : const ClampingScrollPhysics();

    // Use the appropriate scroll controller
    final scrollController = widget.enableScroll
        ? draggableScrollController
        : _effectiveScrollController;

    Widget content = Padding(
      padding: EdgeInsets.only(
        bottom: widget.autoPadBottom ? 16 : 0,
        left: 16,
        right: 16,
      ),
      child: widget.child,
    );

    if (widget.enableScroll) {
      content = SingleChildScrollView(
        controller: scrollController,
        physics: physics,
        child: content,
      );
    }

    // Add edge glow effect and scroll notifications
    if (widget.showEdgeGlow && widget.enableScroll) {
      content = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            _checkScrollControllerAttachment();
          }
          if (notification is ScrollUpdateNotification &&
              _effectiveScrollController.hasClients) {
            _updateShadow();
          }
          return false;
        },
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(
            context,
          ).copyWith(overscroll: widget.enableSpringPhysics, physics: physics),
          child: content,
        ),
      );
    }

    return content;
  }
}

/// Pre-built sheet components for easy implementation

/// Standard handle widget
class SheetHandle extends StatelessWidget {
  const SheetHandle({
    super.key,
    this.color,
    this.width = 40,
    this.height = 5,
    this.margin = const EdgeInsets.symmetric(vertical: 8),
  });

  final Color? color;
  final double width;
  final double height;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: margin,
      child: Center(
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color ?? theme.colorScheme.onSurface.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

/// Close button for sheets
class SheetCloseButton extends StatelessWidget {
  const SheetCloseButton({
    required this.onPressed,
    super.key,
    this.icon = Iconsax.close_circle5,
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
    return OnTapScaler(
      child: IconButton(
        icon: Icon(icon, size: size),
        color: color ?? theme.colorScheme.onSurface.withOpacity(0.7),
        padding: padding,
        constraints: BoxConstraints(minWidth: size + 16, minHeight: size + 16),
        onPressed: onPressed,
      ),
    );
  }
}

/// Sticky header for sheets
class SheetStickyHeader extends StatelessWidget {
  const SheetStickyHeader({
    required this.child,
    super.key,
    this.backgroundColor,
    this.elevation = 0.6,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  });

  final Widget child;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: elevation,
      color: backgroundColor ?? theme.colorScheme.surface,
      child: Padding(padding: padding, child: child),
    );
  }
}

/// Bottom bar for sheets
class SheetBottomBar extends StatelessWidget {
  const SheetBottomBar({
    required this.child,
    super.key,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
    this.safeArea = true,
  });

  final Widget child;
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;
  final bool safeArea;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: backgroundColor ?? theme.colorScheme.surface,
      padding: padding,
      child: SafeArea(top: false, child: child),
    );
  }
}

/// Quick action sheet with common patterns
class QuickActionSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required List<SheetAction> actions,
    String? title,
    Widget? icon,
    bool showCloseButton = true,
  }) {
    return UltraSheet.show<T>(
      context: context,
      snapPoints: const [0.3, 0.5],
      initialSnap: 0.3,
      showCloseButton: showCloseButton,
      titleBar: title != null
          ? SheetStickyHeader(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (icon != null) ...[icon, const SizedBox(width: 12)],
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final action in actions)
            ListTile(
              leading: action.icon,
              title: Text(action.title),
              trailing: action.trailing,
              onTap: () {
                action.onTap?.call();
                if (action.popOnTap) Navigator.of(context).pop();
              },
            ),
        ],
      ),
    );
  }
}

class SheetAction {
  const SheetAction({
    required this.title,
    this.icon,
    this.trailing,
    this.onTap,
    this.popOnTap = true,
  });

  final String title;
  final Widget? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool popOnTap;
}

/// Usage examples:
/*
// Basic usage with close button
UltraSheet.show(
  context: context,
  child: const YourContent(),
  showCloseButton: true,
);

// Advanced usage with all features
UltraSheet.show(
  context: context,
  child: const YourContent(),
  snapPoints: const [0.4, 0.7, 0.9],
  initialSnap: 0.4,
  blurBackground: true,
  showHandle: true,
  showCloseButton: true,
  enableSpringPhysics: true,
  stickyHeader: SheetStickyHeader(
    child: Text(
      'Settings',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  bottomBar: SheetBottomBar(
    child: Row(
      children: [
        Expanded(
          child: FilledButton(
            onPressed: () {},
            child: Text('Save'),
          ),
        ),
      ],
    ),
  ),
  onSnapChanged: (snap) {
    print('Sheet snapped to: $snap');
  },
  onClosePressed: () {
    print('Custom close action');
  },
);

// Quick action sheet
QuickActionSheet.show(
  context: context,
  title: 'Choose Option',
  showCloseButton: true,
  actions: [
    SheetAction(
      title: 'Edit',
      icon: Icon(Icons.edit),
      onTap: () => editItem(),
    ),
    SheetAction(
      title: 'Delete',
      icon: Icon(Icons.delete, color: Colors.red),
      onTap: () => deleteItem(),
    ),
  ],
);
*/
