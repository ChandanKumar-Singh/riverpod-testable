import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/dashboard/providers/dashboard_providers.dart';
import 'package:testable/ui/dashboard/widgets/metric_card.dart';

class KPIGridSection extends ConsumerWidget {
  const KPIGridSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(kpiStreamProvider);
    final selectedKpiId = ref.watch(
      dashboardStateProvider.select((s) => s.selectedKpiId),
    );

    return kpiAsync.when(
      data: (kpi) => Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          MetricCard(
            title: "ACTIVE AGENTS",
            value: kpi.activeAgents.toString(),
            unit: "NODES ONLINE",
            icon: Icons.smart_toy,
            accentColor: context.appColors.accentPrimary,
            isSelected: selectedKpiId == 'agents',
            onTap: () =>
                ref.read(dashboardStateProvider.notifier).selectKpi('agents'),
          ),
          MetricCard(
            title: "THROUGHPUT",
            value: kpi.tokensPerSecond.toStringAsFixed(1),
            unit: "TOKENS / SEC",
            icon: Icons.bolt,
            accentColor: context.appColors.accentSecondary,
            isSelected: selectedKpiId == 'throughput',
            onTap: () => ref
                .read(dashboardStateProvider.notifier)
                .selectKpi('throughput'),
          ),
          MetricCard(
            title: "SUCCESS RATE",
            value: "${(kpi.successRate * 100).toStringAsFixed(1)}%",
            unit: "COMPLETION",
            icon: Icons.check_circle,
            accentColor: context.appColors.accentSuccess,
            isSelected: selectedKpiId == 'success',
            onTap: () =>
                ref.read(dashboardStateProvider.notifier).selectKpi('success'),
          ),
          MetricCard(
            title: "LATENCY",
            value: "${kpi.avgLatencyMs}",
            unit: "MS AVG",
            icon: Icons.timer,
            accentColor: context.appColors.accentWarning,
            isSelected: selectedKpiId == 'latency',
            onTap: () =>
                ref.read(dashboardStateProvider.notifier).selectKpi('latency'),
          ),
        ],
      ),
      loading: () => const _LoadingKpiPlaceholder(),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _LoadingKpiPlaceholder extends StatelessWidget {
  const _LoadingKpiPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: List.generate(
        4,
        (index) => Container(
          width: 160,
          height: 120,
          decoration: BoxDecoration(
            color: context.appColors.bgTertiary.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
