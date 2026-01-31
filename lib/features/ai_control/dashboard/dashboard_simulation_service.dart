import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testable/features/ai_control/dashboard/dashboard_models.dart';

class DashboardSimulationService {
  final _random = Random();

  Stream<List<DashboardKpi>> get kpiStream async* {
    while (true) {
      yield [
        DashboardKpi(
          id: 'throughput',
          label: 'TOTAL THROUGHPUT',
          value: '${(_random.nextDouble() * 1000 + 5000).toInt()} tokens/s',
          trend: 0.12,
          icon: Icons.speed,
          color: const Color(0xFF00D1FF),
        ),
        DashboardKpi(
          id: 'cost',
          label: 'TOTAL COST (24H)',
          value: '\$${(_random.nextDouble() * 100 + 400).toStringAsFixed(2)}',
          trend: -0.05,
          icon: Icons.account_balance_wallet,
          color: const Color(0xFF6C5DD3),
        ),
        DashboardKpi(
          id: 'active_agents',
          label: 'ACTIVE AGENTS',
          value: '${(_random.nextInt(50) + 150)}',
          trend: 0.08,
          icon: Icons.smart_toy,
          color: const Color(0xFF3DD598),
        ),
        DashboardKpi(
          id: 'violation_rate',
          label: 'POLICY VIOLATION RATE',
          value: '${(_random.nextDouble() * 0.5).toStringAsFixed(2)}%',
          trend: 0.02,
          icon: Icons.shield,
          color: const Color(0xFFFF4C61),
        ),
      ];
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  Stream<SystemHealth> get healthStream async* {
    while (true) {
      yield SystemHealth(
        networkStability: 0.95 + (_random.nextDouble() * 0.04),
        agentRuntimePct: 0.99,
        activeIncidents: _random.nextInt(3),
        statusMessage:
            "All systems operational. No critical failures detected.",
      );
      await Future.delayed(const Duration(seconds: 5));
    }
  }
}
