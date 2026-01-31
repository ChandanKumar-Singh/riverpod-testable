import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/fleet/fleet_models.dart';
import 'package:testable/features/ai_control/fleet/fleet_providers.dart';
import 'package:testable/features/ai_control/shared/ai_control_theme.dart';
import 'package:testable/features/ai_control/shared/ai_control_widgets.dart';

class FleetScreen extends ConsumerWidget {
  const FleetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                _buildHeader(context),
                const Expanded(child: _FleetList()),
              ],
            ),
          ),
          const _FleetDetailsPanel(),
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
          Icon(Icons.hub_outlined, color: context.appColors.accentPrimary),
          const SizedBox(width: 12),
          Text(
            "FLEET COMMAND",
            style: AIControlTheme.headingStyle(context).copyWith(fontSize: 18),
          ),
          const Spacer(),
          CyberButton(
            label: "PROVISION NEW FLEET",
            onPressed: () {},
            icon: Icons.add_circle_outline,
          ),
        ],
      ),
    );
  }
}

class _FleetList extends ConsumerWidget {
  const _FleetList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fleetsAsync = ref.watch(fleetListStreamProvider);

    return fleetsAsync.when(
      data: (fleets) => ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: fleets.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final fleet = fleets[index];
          final isSelected = ref.watch(selectedFleetIdProvider) == fleet.id;

          return _FleetCard(fleet: fleet, isSelected: isSelected);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
    );
  }
}

class _FleetCard extends ConsumerWidget {
  final AgentFleet fleet;
  final bool isSelected;

  const _FleetCard({required this.fleet, required this.isSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusColor = _getStatusColor(context, fleet.status);

    return GestureDetector(
      onTap: () => ref.read(selectedFleetIdProvider.notifier).state = fleet.id,
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_getStatusIcon(fleet.status), color: statusColor),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fleet.name,
                    style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fleet.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.appColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            _FleetMetric(label: "AGENTS", value: "${fleet.agentCount}"),
            const SizedBox(width: 32),
            _FleetMetric(
              label: "LOAD",
              value: "${(fleet.loadFactor * 100).toInt()}%",
              color: fleet.loadFactor > 0.8
                  ? context.appColors.accentWarning
                  : null,
            ),
            const SizedBox(width: 24),
            Icon(Icons.chevron_right, color: context.appColors.textTertiary),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(BuildContext context, FleetStatus status) {
    switch (status) {
      case FleetStatus.active:
        return context.appColors.accentSuccess;
      case FleetStatus.idle:
        return context.appColors.textTertiary;
      case FleetStatus.error:
        return context.appColors.accentCritical;
      case FleetStatus.deploying:
        return context.appColors.accentSecondary;
    }
  }

  IconData _getStatusIcon(FleetStatus status) {
    switch (status) {
      case FleetStatus.active:
        return Icons.check_circle_outline;
      case FleetStatus.idle:
        return Icons.pause_circle_outline;
      case FleetStatus.error:
        return Icons.error_outline;
      case FleetStatus.deploying:
        return Icons.cloud_upload_outlined;
    }
  }
}

class _FleetMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _FleetMetric({required this.label, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: TextStyle(
            color: context.appColors.textTertiary,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? context.appColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoMono',
          ),
        ),
      ],
    );
  }
}

class _FleetDetailsPanel extends ConsumerWidget {
  const _FleetDetailsPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fleet = ref.watch(selectedFleetProvider);

    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(left: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: fleet == null ? _EmptyFleetDetails() : _FleetDetails(fleet: fleet),
    );
  }
}

class _EmptyFleetDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hub_outlined,
            color: context.appColors.textTertiary,
            size: 48,
          ),
          const SizedBox(height: 24),
          Text(
            "SELECT A FLEET TO MANAGE",
            style: AIControlTheme.subHeadingStyle(context),
          ),
        ],
      ),
    );
  }
}

class _FleetDetails extends StatelessWidget {
  final AgentFleet fleet;
  const _FleetDetails({required this.fleet});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Text(
          "FLEET CONFIGURATION",
          style: AIControlTheme.subHeadingStyle(context),
        ),
        const SizedBox(height: 24),
        Text(fleet.name, style: AIControlTheme.headingStyle(context)),
        const SizedBox(height: 12),
        Text(
          fleet.description,
          style: TextStyle(
            color: context.appColors.textSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 40),
        _DetailItem(label: "STATUS", value: fleet.status.name.toUpperCase()),
        _DetailItem(label: "REGION", value: fleet.region.toUpperCase()),
        _DetailItem(
          label: "LOAD FACTOR",
          value: "${(fleet.loadFactor * 100).toInt()}%",
        ),
        const SizedBox(height: 40),
        Text("ACTIVE POLICIES", style: AIControlTheme.subHeadingStyle(context)),
        const SizedBox(height: 16),
        _PolicyItem(label: "Max Latency: 500ms", isActive: true),
        _PolicyItem(label: "Token Limit: 1M/hr", isActive: true),
        _PolicyItem(label: "Regional Data PII Scrim", isActive: false),
        const SizedBox(height: 48),
        CyberButton(
          label: "UPDATE FLEET CONFIG",
          onPressed: () {},
          icon: Icons.settings_outlined,
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            foregroundColor: context.appColors.accentCritical,
            side: BorderSide(
              color: context.appColors.accentCritical.withValues(alpha: 0.5),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text("DECOMMISSION FLEET"),
        ),
      ],
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  const _DetailItem({required this.label, required this.value});

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
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyItem extends StatelessWidget {
  final String label;
  final bool isActive;
  const _PolicyItem({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isActive ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
