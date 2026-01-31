import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/dashboard/models/system_health.dart';
import 'package:testable/ui/dashboard/providers/dashboard_providers.dart';

class DashboardHeader extends ConsumerWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFocusMode = ref.watch(dashboardStateProvider).isFocusMode;
    final healthAsync = ref.watch(systemStatusStreamProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: context.appColors.bgTertiary.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Title
          Text(
            "GLOBAL OVERWATCH",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              letterSpacing: 2.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),

          // Focus Mode Toggle
          Row(
            children: [
              Text(
                "FOCUS MODE",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isFocusMode
                      ? context.appColors.accentPrimary
                      : context.appColors.textTertiary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8),
              Switch(
                value: isFocusMode,
                activeColor: context.appColors.accentPrimary,
                onChanged: (_) {
                  ref.read(dashboardStateProvider.notifier).toggleFocusMode();
                },
              ),
            ],
          ),

          const SizedBox(width: 24),

          // System Status Indicator
          healthAsync.when(
            data: (health) => _SystemStatus(health: health),
            loading: () => const _SystemStatusLoading(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class _SystemStatus extends StatelessWidget {
  final SystemHealth health;

  const _SystemStatus({required this.health});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (health.networkStatus) {
      case NetworkStatus.stable:
        statusColor = context.appColors.accentSuccess;
        statusText = "SYSTEM OPTIMAL";
        break;
      case NetworkStatus.degraded:
        statusColor = context.appColors.accentWarning;
        statusText = "DEGRADED";
        break;
      case NetworkStatus.offline:
        statusColor = context.appColors.accentCritical;
        statusText = "OFFLINE";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border.all(color: statusColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.circle, size: 8, color: statusColor),
          const SizedBox(width: 8),
          Text(
            statusText,
            style: TextStyle(
              color: statusColor,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _SystemStatusLoading extends StatelessWidget {
  const _SystemStatusLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        "CONNECTING...",
        style: TextStyle(
          color: context.appColors.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
