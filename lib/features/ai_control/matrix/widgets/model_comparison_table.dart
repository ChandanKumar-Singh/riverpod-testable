import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/matrix/matrix_models.dart';
import 'package:testable/features/ai_control/matrix/matrix_providers.dart';
import 'package:testable/features/ai_control/shared/ai_control_theme.dart';
import 'package:testable/features/ai_control/shared/ai_control_widgets.dart';

class ModelComparisonTable extends ConsumerWidget {
  const ModelComparisonTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metricsAsync = ref.watch(matrixMetricsProvider);
    final selectedId = ref.watch(selectedModelIdProvider);

    return metricsAsync.when(
      data: (models) {
        final sortedModels = List<ModelProfile>.from(models);
        if (selectedId != null) {
          sortedModels.sort((a, b) {
            if (a.id == selectedId) return -1;
            if (b.id == selectedId) return 1;
            return 0;
          });
        }

        return Container(
          decoration: BoxDecoration(
            color: context.appColors.bgSecondary.withValues(alpha: 0.4),
            border: Border(
              top: BorderSide(color: context.appColors.bgTertiary),
            ),
          ),
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.builder(
                  itemCount: sortedModels.length,
                  itemBuilder: (context, index) {
                    final m = sortedModels[index];
                    final isSelected = m.id == selectedId;
                    return _buildRow(context, m, isSelected, ref);
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      color: context.appColors.bgTertiary.withValues(alpha: 0.3),
      child: const Row(
        children: [
          Expanded(flex: 3, child: _HeaderCell("MODEL")),
          Expanded(flex: 2, child: _HeaderCell("PROVIDER")),
          Expanded(
            flex: 1,
            child: _HeaderCell("LATENCY", align: TextAlign.right),
          ),
          Expanded(flex: 1, child: _HeaderCell("COST", align: TextAlign.right)),
          Expanded(
            flex: 1,
            child: _HeaderCell("CAPABILITY", align: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    ModelProfile m,
    bool isSelected,
    WidgetRef ref,
  ) {
    return InkWell(
      onTap: () => ref.read(selectedModelIdProvider.notifier).state = m.id,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.appColors.accentPrimary.withValues(alpha: 0.05)
              : null,
          border: Border(
            bottom: BorderSide(
              color: context.appColors.bgTertiary.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                m.name,
                style: TextStyle(
                  color: isSelected
                      ? context.appColors.accentPrimary
                      : context.appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: StatusBadge(
                label: m.provider,
                color: context.appColors.textTertiary,
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${m.latencyMs.toInt()}ms",
                textAlign: TextAlign.right,
                style: AIControlTheme.subHeadingStyle(
                  context,
                ).copyWith(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "\$${m.costPerMillionTokens.toStringAsFixed(2)}",
                textAlign: TextAlign.right,
                style: AIControlTheme.subHeadingStyle(
                  context,
                ).copyWith(fontSize: 12),
              ),
            ),
            Expanded(
              flex: 1,
              child: Text(
                "${(m.capabilityScore * 100).toInt()}%",
                textAlign: TextAlign.right,
                style: AIControlTheme.subHeadingStyle(context).copyWith(
                  color: context.appColors.accentSuccess,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final TextAlign align;
  const _HeaderCell(this.label, {this.align = TextAlign.left});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: align,
      style: TextStyle(
        color: context.appColors.textTertiary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.0,
      ),
    );
  }
}
