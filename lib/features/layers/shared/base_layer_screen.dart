import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_theme.dart';
import 'package:testable/ui/shared/insight_overlay.dart';
import 'package:testable/ui/shared/neon_text.dart';

class BaseLayerScreen extends StatelessWidget {
  final int layerNumber;
  final String title;
  final Widget child;
  final bool showGrid;
  final String insightTech;
  final String insightPhysics;
  final String insightValue;

  const BaseLayerScreen({
    super.key,
    required this.layerNumber,
    required this.title,
    required this.child,
    this.showGrid = true,
    this.insightTech = "Technical details unavailable.",
    this.insightPhysics = "Physics data unavailable.",
    this.insightValue = "ROI data unavailable.",
  });

  @override
  Widget build(BuildContext context) {
    return InsightOverlay(
      title: "LAYER $layerNumber: $title",
      techDescription: insightTech,
      physicsDescription: insightPhysics,
      valueDescription: insightValue,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            if (showGrid)
              Positioned.fill(
                child: CustomPaint(painter: _GridPatternPainter()),
              ),
            SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: _buildHeaderLine()),
                  SliverFillRemaining(hasScrollBody: false, child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderLine() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.accentCyan.withOpacity(0.3)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NeonText(
            "L$layerNumber // $title",
            fontSize: 16,
            color: AppTheme.accentCyan,
          ),
          Icon(Icons.hub, color: AppTheme.accentCyan.withOpacity(0.5)),
        ],
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;
    for (double i = 0; i < size.width; i += 40)
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    for (double i = 0; i < size.height; i += 40)
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
