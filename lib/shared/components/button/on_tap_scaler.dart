part of './index.dart';

class OnTapScaler extends StatefulWidget {
  const OnTapScaler({
    required this.child,
    super.key,
    this.scale = 0.9, // Changed from 0.5 to 0.95 for more natural scaling
    this.duration = const Duration(milliseconds: 120),
    this.enabled = true,
    this.onTap, // Added optional onTap callback
  });

  final Widget child;
  final double scale;
  final Duration duration;
  final bool enabled;
  final VoidCallback? onTap; // Added tap functionality

  @override
  State<OnTapScaler> createState() => _OnTapScalerState();
}

class _OnTapScalerState extends State<OnTapScaler>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      lowerBound: 0.0,
      upperBound: 1.0,
    );
    
    // Create a curved animation for smoother scaling
    scaleAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(OnTapScaler oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      controller.duration = widget.duration;
    }
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!widget.enabled) return;
    
    controller.forward();
    HapticFeedback.mediumImpact();
  }

  void _onPointerUp(PointerUpEvent event) async {
    if (!widget.enabled || !mounted) return;
    
    await controller.reverse();
    
    // Check if the tap is still within the widget bounds
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final localPosition = renderBox.globalToLocal(event.position);
      if (renderBox.size.contains(localPosition)) {
        widget.onTap?.call();
      }
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (!widget.enabled || !mounted) return;
    controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedBuilder(
        animation: scaleAnimation,
        builder: (BuildContext context, Widget? child) {
          final scale = widget.enabled
              ? (1 - scaleAnimation.value * (1 - widget.scale))
              : 1.0;
          
          return Transform.scale(
            scale: scale,
            child: widget.child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}