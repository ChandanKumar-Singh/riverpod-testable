import 'package:flutter/material.dart';

class DashboardKpi {
  final String id;
  final String label;
  final String value;
  final double trend;
  final IconData icon;
  final Color color;

  const DashboardKpi({
    required this.id,
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
  });
}

class SystemHealth {
  final double networkStability;
  final double agentRuntimePct;
  final int activeIncidents;
  final String statusMessage;

  const SystemHealth({
    required this.networkStability,
    required this.agentRuntimePct,
    required this.activeIncidents,
    required this.statusMessage,
  });
}
