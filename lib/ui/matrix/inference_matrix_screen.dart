import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/matrix/matrix_providers.dart';
import 'package:testable/features/ai_control/matrix/matrix_models.dart';
import 'package:testable/ui/matrix/widgets/cost_latency_scatter.dart';
import 'package:testable/ui/matrix/widgets/model_comparison_table.dart';

class InferenceMatrixScreen extends ConsumerWidget {
  const InferenceMatrixScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedModelIdProvider);
    final projectionMode = ref.watch(projectionModeProvider);

    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: Column(
        children: [
          // Header
          _buildHeader(context, ref, projectionMode),

          Expanded(
            child: Row(
              children: [
                // Left side: Scatter Plot
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Row(
                          children: [
                            Text(
                              "PERFORMANCE VS COST MATRIX",
                              style: TextStyle(
                                color: context.appColors.textTertiary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const Spacer(),
                            _LegendItem(
                              "Selected",
                              context.appColors.accentPrimary,
                            ),
                            const SizedBox(width: 16),
                            _LegendItem(
                              "Pareto Frontier",
                              context.appColors.accentSuccess,
                            ),
                          ],
                        ),
                      ),
                      const Expanded(child: CostLatencyScatter()),
                    ],
                  ),
                ),

                // Right side: Details & Table
                Container(width: 1, color: context.appColors.bgTertiary),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      // Selection Details Area
                      _buildSelectionDetails(context, ref, selectedId),

                      const Divider(height: 1),

                      // Table
                      const Expanded(child: ModelComparisonTable()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool projectionMode,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(bottom: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics_outlined,
            color: context.appColors.accentPrimary,
          ),
          const SizedBox(width: 12),
          Text(
            "INFERENCE INTELLIGENCE",
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Spacer(),
          Text(
            "SHOW PROJECTED SAVINGS",
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: projectionMode,
            onChanged: (val) =>
                ref.read(projectionModeProvider.notifier).state = val,
            activeColor: context.appColors.accentPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionDetails(
    BuildContext context,
    WidgetRef ref,
    String? selectedId,
  ) {
    if (selectedId == null) {
      return Container(
        height: 250,
        alignment: Alignment.center,
        child: Text(
          "Select a model on the chart to see insights",
          style: TextStyle(color: context.appColors.textTertiary),
        ),
      );
    }

    final modelProfileAsync = ref.watch(selectedModelProfileProvider);
    final insights = ref.watch(optimizationInsightsProvider);
    final insight = insights.isNotEmpty
        ? insights.firstWhere(
            (i) => i.modelId == selectedId,
            orElse: () => insights.first,
          )
        : null;

    return Container(
      padding: const EdgeInsets.all(24),
      height: 250,
      child: modelProfileAsync.when(
        data: (profile) {
          if (profile == null) return const SizedBox.shrink();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: profile.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    profile.name,
                    style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              if (insight != null && insight.modelId == profile.id)
                _InsightPanel(insight, context)
              else
                _NoInsightPanel(context),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Text("Error loading profile"),
      ),
    );
  }

  Widget _NoInsightPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.accentSuccess.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.appColors.accentSuccess.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: context.appColors.accentSuccess,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            "This model is optimal for its category.",
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _InsightPanel(OptimizationInsight insight, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.accentWarning.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.appColors.accentWarning.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: context.appColors.accentWarning,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                "OPTIMIZATION OPPORTUNITY",
                style: TextStyle(
                  color: context.appColors.accentWarning,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight.description,
            style: TextStyle(
              color: context.appColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MiniStat("RECOMMENDATION", insight.recommendation),
              const SizedBox(width: 24),
              _MiniStat(
                "EST. SAVINGS",
                "${(insight.potentialSavingsPerc * 100).toInt()}%",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _MiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 9)),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _LegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ],
    );
  }
}
