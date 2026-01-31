import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/dashboard/dashboard_models.dart';
import 'package:testable/features/ai_control/dashboard/dashboard_providers.dart';
import 'package:testable/features/ai_control/shared/ai_control_theme.dart';
import 'package:testable/features/ai_control/shared/ai_control_widgets.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: CustomScrollView(
        slivers: [
          _buildHeader(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SystemHealthOverview(),
                  const SizedBox(height: 48),
                  Text(
                    "CORE PERFORMANCE INDICATORS",
                    style: AIControlTheme.subHeadingStyle(context),
                  ),
                  const SizedBox(height: 24),
                  const _KpiGrid(),
                  const SizedBox(height: 48),
                  _ActiveAlertsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.appColors.bgSecondary.withValues(alpha: 0.8),
      floating: true,
      pinned: true,
      elevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          Icon(
            Icons.dashboard_outlined,
            color: context.appColors.accentPrimary,
          ),
          const SizedBox(width: 12),
          Text(
            "GLOBAL OVERWATCH",
            style: AIControlTheme.headingStyle(context).copyWith(fontSize: 18),
          ),
        ],
      ),
      actions: [
        CyberButton(
          label: "EXPORT REPORT",
          onPressed: () {},
          icon: Icons.ios_share,
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}

class _KpiGrid extends ConsumerWidget {
  const _KpiGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kpisAsync = ref.watch(kpiListProvider);

    return kpisAsync.when(
      data: (kpis) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 1.6,
        ),
        itemCount: kpis.length,
        itemBuilder: (context, index) {
          final kpi = kpis[index];
          return GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(kpi.icon, color: kpi.color, size: 20),
                    StatusBadge(
                      label: "${(kpi.trend * 100).toInt()}%",
                      color: kpi.trend >= 0
                          ? context.appColors.accentSuccess
                          : context.appColors.accentCritical,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kpi.value,
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kpi.label,
                      style: TextStyle(
                        color: context.appColors.textTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
    );
  }
}

class _SystemHealthOverview extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(systemHealthProvider);

    return healthAsync.when(
      data: (health) => GlassCard(
        padding: const EdgeInsets.all(32),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CURRENT STATUS",
                    style: AIControlTheme.subHeadingStyle(context),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    health.statusMessage,
                    style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            _HealthMetric(
              label: "NETWORK STABILITY",
              value: "${(health.networkStability * 100).toStringAsFixed(1)}%",
              color: context.appColors.accentSecondary,
            ),
            const SizedBox(width: 48),
            _HealthMetric(
              label: "ACTIVE INCIDENTS",
              value: "${health.activeIncidents}",
              color: health.activeIncidents == 0
                  ? context.appColors.accentSuccess
                  : context.appColors.accentWarning,
            ),
          ],
        ),
      ),
      loading: () => const SizedBox(height: 120),
      error: (e, s) => const SizedBox.shrink(),
    );
  }
}

class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _HealthMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.appColors.textTertiary,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
        ),
      ],
    );
  }
}

class _ActiveAlertsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ACTIVE SYSTEM ALERTS",
          style: AIControlTheme.subHeadingStyle(context),
        ),
        const SizedBox(height: 24),
        GlassCard(
          padding: EdgeInsets.zero,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 2,
            separatorBuilder: (context, index) =>
                Divider(color: context.appColors.bgTertiary),
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: context.appColors.accentWarning.withValues(
                    alpha: 0.1,
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: context.appColors.accentWarning,
                    size: 20,
                  ),
                ),
                title: Text(
                  index == 0
                      ? "High Latency in US-East region"
                      : "Policy bypass attempt detected",
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Severity: MEDIUM • 12 minutes ago",
                  style: TextStyle(
                    color: context.appColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
                trailing: TextButton(
                  onPressed: () {},
                  child: const Text("VIEW TRACE"),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
