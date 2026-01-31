import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/ui/dashboard/providers/dashboard_providers.dart';
import 'package:testable/ui/dashboard/widgets/live_event_log.dart';
import 'package:testable/ui/dashboard/widgets/metric_card.dart';

class DashboardGrid extends ConsumerWidget {
  const DashboardGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpiAsync = ref.watch(kpiStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        // KPI Section
        kpiAsync.when(
          data: (kpi) => GridView.count(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            childAspectRatio: 1.5,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              MetricCard(
                title: "ACTIVE AGENTS",
                value: "${kpi.activeAgents}",
                unit: "NODES ONLINE",
                icon: Icons.hub,
              ),
              MetricCard(
                title: "THROUGHPUT",
                value: kpi.tokensPerSecond.toStringAsFixed(0),
                unit: "TOKENS/SEC",
                icon: Icons.bolt,
              ),
              MetricCard(
                title: "SUCCESS RATE",
                value: "${(kpi.successRate * 100).toStringAsFixed(1)}%",
                unit: "COMPLETION",
                icon: Icons.check_circle_outline,
              ),
              MetricCard(
                title: "LATENCY",
                value: "${kpi.avgLatencyMs}",
                unit: "MS AVG",
                icon: Icons.timer,
              ),
            ],
          ),
          loading: () => const LinearProgressIndicator(),
          error: (_, __) => const SizedBox(),
        ),

        const SizedBox(height: 24),

        // Event Log Section
        const Expanded(child: LiveEventLog()),
      ],
    );
  }
}
