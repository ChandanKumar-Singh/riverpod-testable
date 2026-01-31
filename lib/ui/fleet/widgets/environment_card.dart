import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/fleet/models/fleet_environment.dart';
import 'package:testable/ui/fleet/providers/fleet_providers.dart';
import 'package:testable/ui/fleet/services/fleet_simulation_service.dart';

class EnvironmentCard extends ConsumerWidget {
  final FleetEnvironment env;
  final VoidCallback onDeploy;

  const EnvironmentCard({super.key, required this.env, required this.onDeploy});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deploymentMap = ref.watch(deploymentControllerProvider);
    final activeStep = deploymentMap[env.id];
    final isDeploying = activeStep != null;
    final isMaintenance = env.status == EnvironmentStatus.maintenance;

    final Color statusColor;
    if (isMaintenance) {
      statusColor = context.appColors.textTertiary;
    } else if (env.status == EnvironmentStatus.healthy) {
      statusColor = context.appColors.accentSuccess;
    } else if (env.status == EnvironmentStatus.degraded) {
      statusColor = context.appColors.accentWarning;
    } else {
      statusColor = context.appColors.accentCritical;
    }

    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.appColors.bgSecondary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDeploying
                ? context.appColors.accentPrimary
                : (isMaintenance
                      ? context.appColors.accentWarning.withValues(alpha: 0.5)
                      : context.appColors.bgTertiary),
            width: isDeploying ? 2 : 1,
          ),
          boxShadow: isDeploying
              ? [
                  BoxShadow(
                    color: context.appColors.accentPrimary.withValues(
                      alpha: 0.2,
                    ),
                    blurRadius: 16,
                  ),
                ]
              : [],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          env.type == EnvironmentType.prod
                              ? Icons.cloud_done
                              : Icons.cloud_queue,
                          color: statusColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          env.name.toUpperCase(),
                          style: TextStyle(
                            color: context.appColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    // Maintenance Toggle
                    SizedBox(
                      height: 24,
                      child: Switch(
                        value: isMaintenance,
                        activeColor: context.appColors.accentWarning,
                        activeTrackColor: context.appColors.accentWarning
                            .withValues(alpha: 0.2),
                        onChanged: isDeploying
                            ? null
                            : (val) {
                                ref
                                    .read(deploymentControllerProvider.notifier)
                                    .toggleMaintenance(env.id, val);
                              },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Version Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: context.appColors.bgTertiary,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "Current: ${env.currentVersion.version}",
                    style: TextStyle(
                      color: context.appColors.textSecondary,
                      fontSize: 10,
                      fontFamily: 'RobotoMono',
                    ),
                  ),
                ),

                const Spacer(),

                // Status Visualization (Sparkline or Maintenance Strip)
                Expanded(
                  child: Center(
                    child: isMaintenance
                        ? Text(
                            "MAINTENANCE MODE",
                            style: TextStyle(
                              color: context.appColors.textTertiary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(20, (i) {
                              // Deterministic fake visualization
                              final h =
                                  10 +
                                  (20 *
                                      (0.5 +
                                          0.5 * ((i + env.activeNodes) % 3)));
                              return Expanded(
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1,
                                  ),
                                  height: h.toDouble(),
                                  color: statusColor.withValues(alpha: 0.3),
                                ),
                              );
                            }),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Footer Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stats
                    Row(
                      children: [
                        _StatSmall(
                          label: "NODES",
                          value: "${env.activeNodes}",
                          context: context,
                        ),
                        const SizedBox(width: 16),
                        _StatSmall(
                          label: "HEALTH",
                          value: "${(env.healthScore * 100).toInt()}%",
                          color: statusColor,
                          context: context,
                        ),
                      ],
                    ),

                    // Actions
                    if (isDeploying)
                      _DeploymentStatusBadge(step: activeStep!)
                    else
                      Row(
                        children: [
                          if (env.previousVersion != null && !isMaintenance)
                            TextButton(
                              onPressed: () {
                                ref
                                    .read(deploymentControllerProvider.notifier)
                                    .rollback(env.id);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    context.appColors.accentCritical,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                              ),
                              child: const Text("ROLLBACK"),
                            ),

                          const SizedBox(width: 8),

                          ElevatedButton(
                            onPressed: isMaintenance ? null : onDeploy,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.appColors.accentPrimary
                                  .withValues(alpha: 0.2),
                              foregroundColor: context.appColors.accentPrimary,
                              disabledBackgroundColor:
                                  context.appColors.bgTertiary,
                              disabledForegroundColor:
                                  context.appColors.textTertiary,
                              elevation: 0,
                              side: isMaintenance
                                  ? null
                                  : BorderSide(
                                      color: context.appColors.accentPrimary,
                                    ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12, // Taller button
                              ),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            child: const Text("DEPLOY"),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatSmall extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final BuildContext context;

  const _StatSmall({
    required this.label,
    required this.value,
    this.color,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: context.appColors.textTertiary, fontSize: 9),
        ),
        Text(
          value,
          style: TextStyle(
            color: color ?? context.appColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DeploymentStatusBadge extends StatelessWidget {
  final DeploymentStep step;
  const _DeploymentStatusBadge({required this.step});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.appColors.bgTertiary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: context.appColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            step.name.toUpperCase(),
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
