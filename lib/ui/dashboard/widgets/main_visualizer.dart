import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/dashboard/providers/dashboard_providers.dart';

class MainVisualizer extends ConsumerStatefulWidget {
  const MainVisualizer({super.key});

  @override
  ConsumerState<MainVisualizer> createState() => _MainVisualizerState();
}

class _MainVisualizerState extends ConsumerState<MainVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedKpi =
        ref.watch(dashboardStateProvider.select((s) => s.selectedKpiId)) ??
        "OVERVIEW";

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: context.appColors.bgSecondary.withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: context.appColors.bgTertiary),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.show_chart,
                  color: context.appColors.accentSecondary,
                ),
                const SizedBox(width: 12),
                Text(
                  "$selectedKpi REAL-TIME ANALYTICS",
                  style: TextStyle(
                    color: context.appColors.textSecondary,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _GraphPainter(
                      color: context.appColors.accentSecondary,
                      tick: _controller.value,
                    ),
                    size: Size.infinite,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GraphPainter extends CustomPainter {
  final Color color;
  final double tick;

  _GraphPainter({required this.color, required this.tick});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [color.withOpacity(0.2), color.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.5);

    final points = <Offset>[];

    // Generate a wave that moves based on 'tick'
    for (double i = 0; i <= size.width; i += 5) {
      final x = i;
      // Combine sines for organic look
      final normalizedX = x / size.width;
      final offset = tick * 2 * pi;

      final y1 = sin((normalizedX * 10) + offset) * 20;
      final y2 = sin((normalizedX * 20) - offset) * 10;
      final noise = (Random(i.toInt()).nextDouble() - 0.5) * 5;

      final y = (size.height * 0.5) + y1 + y2 + noise;
      points.add(Offset(x, y.clamp(0, size.height)));
    }

    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p2 = points[i + 1];
      // simple cubic bezier for smoothness could be better, but lineTo is faster/sufficient for "tech" look
      path.lineTo(p2.dx, p2.dy);
    }

    // Draw fill
    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);

    // Draw stroke
    canvas.drawPath(path, paint);

    // Draw grid
    final gridPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..strokeWidth = 1;

    for (double i = 0; i < size.width; i += 50) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 50) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _GraphPainter oldDelegate) {
    return oldDelegate.tick != tick;
  }
}
