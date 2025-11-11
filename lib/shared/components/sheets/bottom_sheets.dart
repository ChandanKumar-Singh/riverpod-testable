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
    double blurSigma = 12,
    bool barrierDismissible = true,
    double radius = 20,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutCubic,
    Color? backgroundColor,
    Color? barrierColor,

    /// Title bar
    Widget? titleBar,
    bool showHandle = true,
    Widget? customHandle,

    /// Close/hide
    bool enableDrag = true,
    bool enableScroll = true,
    bool expandContent = false,

    /// Advanced features
    bool enableSpringPhysics = true,
    bool showEdgeGlow = true,
    bool autoPadBottom = true,
    bool handleKeyboard = true,
    bool enableHaptics = true,
    double pullToCloseThreshold = 0.3,
    bool showShadowOnScroll = true,

    /// Callbacks
    VoidCallback? onOpened,
    VoidCallback? onClosed,
    ValueChanged<double>? onSnapChanged,
    ValueChanged<bool>? onDragUpdate,

    /// Sticky header
    Widget? stickyHeader,

    /// Floating action button inside sheet
    Widget? floatingActionButton,
  }) async {
    final controller = DraggableScrollableController();
    final media = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Set default colors if not provided
    final sheetBackgroundColor = backgroundColor ?? colorScheme.surface;
    final barrierColorValue = barrierColor ?? Colors.black.withOpacity(0.00);

    // Track current state
    double? lastSnapPoint;
    bool isDragging = false;

    // Setup controller listeners
    controller.addListener(() {
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
          controller.isAttached &&
          (controller.pixels > 0 || controller.hasListeners);
      if (nowDragging != isDragging) {
        isDragging = nowDragging;
        onDragUpdate?.call(isDragging);
      }
    });

    // Open to initial snap location
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(initialSnap, duration: duration, curve: curve);
      onOpened?.call();
    });

    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: barrierDismissible,
      useSafeArea: true,
      builder: (context) {
        return _UltraSheetContent(
          controller: controller,
          snapPoints: snapPoints,
          blurBackground: blurBackground,
          blurSigma: blurSigma,
          barrierDismissible: barrierDismissible,
          radius: radius,
          backgroundColor: sheetBackgroundColor,
          barrierColor: barrierColorValue,
          titleBar: titleBar,
          showHandle: showHandle,
          customHandle: customHandle,
          enableDrag: enableDrag,
          enableScroll: enableScroll,
          expandContent: expandContent,
          enableSpringPhysics: enableSpringPhysics,
          showEdgeGlow: showEdgeGlow,
          autoPadBottom: autoPadBottom,
          handleKeyboard: handleKeyboard,
          pullToCloseThreshold: pullToCloseThreshold,
          showShadowOnScroll: showShadowOnScroll,
          stickyHeader: stickyHeader,
          floatingActionButton: floatingActionButton,
          onClosed: onClosed,
          child: child,
        );
      },
    );
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
    this.titleBar,
    required this.showHandle,
    this.customHandle,
    required this.enableDrag,
    required this.enableScroll,
    required this.expandContent,
    required this.enableSpringPhysics,
    required this.showEdgeGlow,
    required this.autoPadBottom,
    required this.handleKeyboard,
    required this.pullToCloseThreshold,
    required this.showShadowOnScroll,
    this.stickyHeader,
    this.floatingActionButton,
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
  final bool enableDrag;
  final bool enableScroll;
  final bool expandContent;
  final bool enableSpringPhysics;
  final bool showEdgeGlow;
  final bool autoPadBottom;
  final bool handleKeyboard;
  final double pullToCloseThreshold;
  final bool showShadowOnScroll;
  final Widget? stickyHeader;
  final Widget? floatingActionButton;
  final VoidCallback? onClosed;

  @override
  State<_UltraSheetContent> createState() => _UltraSheetContentState();
}

class _UltraSheetContentState extends State<_UltraSheetContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _shadowController;
  final ScrollController _scrollController = ScrollController();
  bool _showTopShadow = false;

  @override
  void initState() {
    super.initState();

    _shadowController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Listen to scroll for shadow effect
    if (widget.showShadowOnScroll) {
      _scrollController.addListener(_updateShadow);
    }

    widget.controller.addListener(_handleControllerChange);
  }

  void _handleControllerChange() {
    // Handle pull-to-close threshold
    if (widget.controller.size < widget.pullToCloseThreshold &&
        widget.controller.pixels < -50) {
      Navigator.of(context).pop();
      widget.onClosed?.call();
    }
  }

  void _updateShadow() {
    final shouldShow = _scrollController.offset > 0;
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

  @override
  void dispose() {
    _shadowController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Background barrier
        if (widget.barrierDismissible)
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.of(context).pop();
              widget.onClosed?.call();
            },
            child: Container(color: Colors.transparent),
          ),

        // Blur background
        if (widget.blurBackground)
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: widget.blurSigma,
              sigmaY: widget.blurSigma,
            ),
            child: Container(color: widget.barrierColor),
          ),

        // Main sheet content
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
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
                                      0.1 * _shadowController.value,
                                    ),
                                    blurRadius: 8,
                                    spreadRadius: 0.5,
                                  ),
                                ]
                              : null,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Handle
                            if (widget.showHandle) _buildHandle(),

                            // Sticky header
                            if (widget.stickyHeader != null)
                              widget.stickyHeader!,

                            // Title bar
                            if (widget.titleBar != null) widget.titleBar!,

                            // Main content
                            Expanded(child: _buildContent(scrollController)),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),

        // Floating Action Button inside sheet
        if (widget.floatingActionButton != null)
          Positioned(
            bottom: 20 + media.viewInsets.bottom,
            right: 20,
            child: widget.floatingActionButton!,
          ),
      ],
    );
  }

  Widget _buildHandle() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child:
            widget.customHandle ??
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
      ),
    );
  }

  Widget _buildContent(ScrollController scrollController) {
    final effectiveScrollController = widget.enableScroll
        ? scrollController
        : _scrollController;

    final physics = widget.enableSpringPhysics
        ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
        : const ClampingScrollPhysics();

    Widget content = Padding(
      padding: EdgeInsets.only(bottom: widget.autoPadBottom ? 16 : 0),
      child: widget.child,
    );

    if (widget.enableScroll) {
      content = SingleChildScrollView(
        controller: effectiveScrollController,
        physics: physics,
        child: content,
      );
    }

    // Add edge glow effect
    if (widget.showEdgeGlow && widget.enableScroll) {
      content = NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollUpdateNotification) {
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
  const SheetHandle({super.key, this.color, this.width = 40, this.height = 5});

  final Color? color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? theme.colorScheme.onSurface.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
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
    this.elevation = 1,
  });

  final Widget child;
  final Color? backgroundColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: elevation,
      color: backgroundColor ?? theme.colorScheme.surface,
      child: child,
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
  }) {
    return UltraSheet.show<T>(
      context: context,
      snapPoints: const [0.3, 0.5],
      initialSnap: 0.3,
      titleBar: title != null
          ? SheetStickyHeader(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
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
// Basic usage
UltraSheet.show(
  context: context,
  child: const YourContent(),
);

// Advanced usage with all features
UltraSheet.show(
  context: context,
  child: const YourContent(),
  snapPoints: const [0.4, 0.7, 0.9],
  initialSnap: 0.4,
  blurBackground: true,
  showHandle: true,
  enableSpringPhysics: true,
  stickyHeader: SheetStickyHeader(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text(
        'Settings',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  onSnapChanged: (snap) {
    print('Sheet snapped to: $snap');
  },
);

// Quick action sheet
QuickActionSheet.show(
  context: context,
  title: 'Choose Option',
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
