import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/matrix/providers/matrix_providers.dart';

class CostLatencyScatter extends ConsumerWidget {
  const CostLatencyScatter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(matrixMetricsProvider);
    final selectedId = ref.watch(selectedModelIdProvider);

    return metricsAsync.when(
      data: (models) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 24, 16),
          child: ScatterChart(
            ScatterChartData(
              scatterSpots: models.map((model) {
                final isSelected = model.id == selectedId;
                return ScatterSpot(
                  model.latencyMs.toDouble(),
                  model.costPerMillionTokens,
                  dotPainter: FlDotCirclePainter(
                    radius: isSelected ? 12 : 8,
                    color: isSelected
                        ? model.color
                        : model.color.withValues(alpha: 0.7),
                    strokeWidth: isSelected ? 2 : 0,
                    strokeColor: Colors.white,
                  ),
                );
              }).toList(),
              minX: 0,
              maxX: 1400,
              minY: 0,
              maxY: 40.0,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: context.appColors.bgTertiary.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: context.appColors.bgTertiary.withValues(alpha: 0.2),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: const Text(
                    "Cost / 1k Tokens (\$)",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toStringAsFixed(3),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: const Text(
                    "Latency (ms)",
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: context.appColors.bgTertiary),
              ),
              // touchCallback:
              //     (FlTouchEvent event, ScatterTouchResponse? touchResponse) {
              //       if (event is FlTapUpEvent &&
              //           touchResponse?.touchedSpot != null) {
              //         final spotIndex = touchResponse!.touchedSpot!.spotIndex;
              //         final model = models[spotIndex];
              //         ref.read(selectedModelIdProvider.notifier).state =
              //             model.id;
              //       }
              //     },
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text("Error loading chart")),
    );
  }
}
