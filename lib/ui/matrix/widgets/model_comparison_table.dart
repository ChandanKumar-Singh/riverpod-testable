import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/matrix/matrix_providers.dart';

class ModelComparisonTable extends ConsumerWidget {
  const ModelComparisonTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(filteredMetricsProvider);
    final selectedId = ref.watch(selectedModelPointProvider);

    // If a model is selected, bring it to top or highlight
    final sortedMetrics = List.of(metrics);
    if (selectedId != null && metrics.isNotEmpty) {
      sortedMetrics.sort((a, b) {
        if (a?.model?.id == selectedId) return -1;
        if (b?.model?.id == selectedId) return 1;
        return 0;
      });
    }

    return Container(
      color: context.appColors.bgPrimary,
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: context.appColors.bgTertiary),
              ),
              color: context.appColors.bgSecondary.withValues(alpha: 0.5),
            ),
            child: Row(
              children: [
                _HeaderCell("MODEL", flex: 3),
                _HeaderCell("PROVIDER", flex: 2),
                _HeaderCell("LATENCY (P95)", flex: 2, align: TextAlign.right),
                _HeaderCell("COST / 1M", flex: 2, align: TextAlign.right),
                _HeaderCell("THROUGHPUT", flex: 2, align: TextAlign.right),
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.builder(
              itemCount: sortedMetrics.length,
              itemBuilder: (context, index) {
                final m = sortedMetrics[index];
                final isSelected = m.model.id == selectedId;

                return Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? context.appColors.accentPrimary.withValues(
                            alpha: 0.05,
                          )
                        : null,
                    border: Border(
                      bottom: BorderSide(
                        color: context.appColors.bgTertiary.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          m.model.name,
                          style: TextStyle(
                            color: isSelected
                                ? context.appColors.accentPrimary
                                : context.appColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          m.model.provider,
                          style: TextStyle(
                            color: context.appColors.textSecondary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${m.avgLatencyMs.toInt()}ms",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: context.appColors.textPrimary,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "\$${m.costPerMillionTokens.toStringAsFixed(2)}",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: context.appColors.textPrimary,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "${m.throughputTokensSec.toInt()} t/s",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            color: context.appColors.textSecondary,
                            fontFamily: 'RobotoMono',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  final TextAlign align;
  const _HeaderCell(this.label, {this.flex = 1, this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: align,
        style: TextStyle(
          color: context.appColors.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}
