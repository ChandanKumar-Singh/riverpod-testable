import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/matrix/matrix_models.dart';
import 'package:testable/features/ai_control/matrix/matrix_providers.dart';
import 'package:testable/features/ai_control/shared/ai_control_theme.dart';
import 'package:testable/features/ai_control/shared/ai_control_widgets.dart';
import 'package:testable/features/ai_control/matrix/widgets/model_comparison_table.dart';

class MatrixScreen extends ConsumerWidget {
  const MatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildHeader(context),
                const Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: _CostLatencyScatterPlot(),
                  ),
                ),
                const Expanded(flex: 2, child: ModelComparisonTable()),
              ],
            ),
          ),
          const _InferenceInsightsPanel(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.grid_view_outlined,
            color: context.appColors.accentPrimary,
          ),
          const SizedBox(width: 12),
          Text(
            'INFERENCE COST & PERFORMANCE MATRIX',
            style: AIControlTheme.headingStyle(context).copyWith(fontSize: 18),
          ),
          const Spacer(),
          CyberButton(
            label: 'COMPARE MODELS',
            onPressed: () {},
            icon: Icons.compare_arrows_outlined,
          ),
        ],
      ),
    );
  }
}

class _CostLatencyScatterPlot extends ConsumerWidget {
  const _CostLatencyScatterPlot();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(matrixMetricsProvider);
    final selectedId = ref.watch(selectedModelIdProvider);

    return GlassCard(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MODEL EFFICIENCY FRONTIER',
            style: AIControlTheme.subHeadingStyle(context),
          ),
          const SizedBox(height: 48),
          Expanded(
            child: metricsAsync.when(
              data: (models) => ScatterChart(
                ScatterChartData(
                  scatterSpots: models.map((m) {
                    final isSelected = m.id == selectedId;
                    return ScatterSpot(
                      m.latencyMs,
                      m.costPerMillionTokens,
                      dotPainter: FlDotCirclePainter(
                        color: isSelected
                            ? context.appColors.accentPrimary
                            : context.appColors.accentSecondary,
                        radius: 8 + (m.capabilityScore * 5),
                      ),
                    );
                  }).toList(),
                  minX: 0,
                  maxX: 1500,
                  minY: 0,
                  maxY: 20,
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      axisNameWidget: Text(
                        'COST (\$ / 1M TOKENS)',
                        style: TextStyle(
                          color: context.appColors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(
                        'LATENCY (ms)',
                        style: TextStyle(
                          color: context.appColors.textTertiary,
                          fontSize: 10,
                        ),
                      ),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                      ),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    checkToShowHorizontalLine: (value) => value % 5 == 0,
                    checkToShowVerticalLine: (value) => value % 250 == 0,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: context.appColors.bgTertiary,
                      strokeWidth: 1,
                    ),
                    getDrawingVerticalLine: (value) => FlLine(
                      color: context.appColors.bgTertiary,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  scatterTouchData: ScatterTouchData(
                    handleBuiltInTouches: true,
                    touchCallback:
                        (FlTouchEvent event, ScatterTouchResponse? response) {
                          if (response != null &&
                              response.touchedSpot != null) {
                            final index = response.touchedSpot!.spotIndex;
                            if (index < models.length) {
                              ref.read(selectedModelIdProvider.notifier).state =
                                  models[index].id;
                            }
                          }
                        },
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(
                child: Text(
                  'Error loading matrix data',
                  style: TextStyle(
                    color: context.appColors.accentPrimary,
                  ), // Changed from accentError
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InferenceInsightsPanel extends ConsumerWidget {
  const _InferenceInsightsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insights = ref.watch(optimizationInsightsProvider);
    final selectedModel = ref.watch(selectedModelProfileProvider);

    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(left: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          selectedModel.when(
            data: (model) {
              if (model == null) return const SizedBox.shrink();
              return Column(
                children: [
                  _ModelSelectionDetail(model: model),
                  const SizedBox(height: 48),
                ],
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (err, stack) => const SizedBox.shrink(),
          ),
          Text(
            "OPTIMIZATION INSIGHTS",
            style: AIControlTheme.subHeadingStyle(context),
          ),
          const SizedBox(height: 24),
          ...insights.map((insight) => _InsightCard(insight: insight)),
          const SizedBox(height: 48),
          CyberButton(
            label: "AUTO-OPTIMIZE ROUTING",
            onPressed: () {},
            icon: Icons.auto_fix_high_outlined,
          ),
        ],
      ),
    );
  }
}

class _ModelSelectionDetail extends StatelessWidget {
  final ModelProfile model;
  const _ModelSelectionDetail({required this.model});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StatusBadge(
          label: model.provider,
          color: context.appColors.accentSecondary,
        ),
        const SizedBox(height: 16),
        Text(model.name, style: AIControlTheme.headingStyle(context)),
        const SizedBox(height: 32),
        _MetricRow(
          label: "COST / 1M",
          value: "\$${model.costPerMillionTokens.toStringAsFixed(2)}",
        ),
        _MetricRow(label: "LATENCY", value: "${model.latencyMs.toInt()}ms"),
        _MetricRow(
          label: "CAPABILITY",
          value: "${(model.capabilityScore * 100).toInt()}%",
        ),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  final String label;
  final String value;
  const _MetricRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: context.appColors.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final OptimizationInsight insight;
  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: context.appColors.accentWarning,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight.title,
                    style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              insight.description,
              style: TextStyle(
                color: context.appColors.textTertiary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.appColors.bgPrimary,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "REC: ${insight.recommendation}",
                style: TextStyle(
                  color: context.appColors.accentSuccess,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
