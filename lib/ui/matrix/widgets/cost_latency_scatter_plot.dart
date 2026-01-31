import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/matrix/matrix_models.dart';
import 'package:testable/features/ai_control/matrix/matrix_providers.dart';

class CostLatencyScatterPlot extends ConsumerWidget {
  const CostLatencyScatterPlot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(filteredMetricsProvider);
    final selectedId = ref.watch(selectedModelPointProvider);
    final isProjection = ref.watch(projectionModeProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ScatterChart(
        ScatterChartData(
          scatterSpots: [
            ...metrics.map(
              (InferenceMetric m) => _buildSpot(context, m, m.model.id == selectedId),
            ),
            if (isProjection)
              ...metrics
                  .where((InferenceMetric m) => m.projectedMetric != null)
                  .map(
                    (InferenceMetric m) => _buildSpot(
                      context,
                      m.projectedMetric!,
                      false,
                      isGhost: true,
                    ),
                  ),
          ],
          minX: 0,
          maxX: 1200,
          minY: 0,
          maxY: 50.0, // Cost per million tokens
          backgroundColor: Colors.transparent,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (val) => FlLine(
              color: context.appColors.bgTertiary.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
            getDrawingVerticalLine: (val) => FlLine(
              color: context.appColors.bgTertiary.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                'COST / M TOKENS (\$)',
                style: TextStyle(
                  color: context.appColors.textTertiary,
                  fontSize: 10,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (val, meta) => Text(
                  '\$${val.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: context.appColors.textTertiary,
                    fontSize: 8,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                "LATENCY (ms)",
                style: TextStyle(
                  color: context.appColors.textTertiary,
                  fontSize: 10,
                ),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (val, meta) => Text(
                  "${val.toInt()}",
                  style: TextStyle(
                    color: context.appColors.textTertiary,
                    fontSize: 8,
                  ),
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
          scatterTouchData: ScatterTouchData(
            touchCallback:
                (FlTouchEvent event, ScatterTouchResponse? response) {
                  if (response != null &&
                      response.touchedSpot != null &&
                      event is FlTapUpEvent) {
                    final int spotIndex = response.touchedSpot!.spotIndex;
                    if (spotIndex < metrics.length) {
                      ref.read(selectedModelPointProvider.notifier).state =
                          metrics[spotIndex].model.id;
                    }
                  }
                },
          ),
        ),
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  ScatterSpot _buildSpot(
    BuildContext context,
    InferenceMetric m,
    bool isSelected, {
    bool isGhost = false,
  }) {
    Color color;
    if (isGhost) {
      color = context.appColors.accentSuccess.withValues(alpha: 0.5);
    } else {
      switch (m.model.provider) {
        case 'OpenAI':
          color = Colors.green;
          break;
        case 'Anthropic':
          color = Colors.orange;
          break;
        case 'Google':
          color = Colors.blue;
          break;
        case 'Local':
          color = Colors.purple;
          break;
        default:
          color = Colors.grey;
      }
    }

    if (isSelected) {
      color = Colors.white;
    }

    return ScatterSpot(
      m.avgLatencyMs,
      m.costPerMillionTokens,
      dotPainter: FlDotCirclePainter(
        color: color,
        radius: isSelected ? 8 : (isGhost ? 4 : 6),
        strokeWidth: isGhost ? 1 : 0,
        strokeColor: isGhost
            ? context.appColors.accentSuccess
            : Colors.transparent,
      ),
    );
  }
}
