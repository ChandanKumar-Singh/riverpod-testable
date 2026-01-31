import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_colors.dart';

class FleetDashboardHeader extends StatelessWidget {
  const FleetDashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(bottom: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.dns, color: context.appColors.accentPrimary),
              const SizedBox(width: 12),
              Text(
                "FLEET COMMAND",
                style: TextStyle(
                  color: context.appColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _StatItem(
                label: "GLOBAL HEALTH",
                value: "98.4%",
                color: context.appColors.accentSuccess,
              ),
              const SizedBox(width: 32),
              _StatItem(
                label: "ACTIVE DEPLOYS",
                value: "1",
                color: context.appColors.accentWarning,
              ),
              const SizedBox(width: 32),
              const _StatItem(label: "TOTAL NODES", value: "482"),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatItem({required this.label, required this.value, this.color});

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
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color ?? context.appColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
