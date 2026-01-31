import 'package:testable/ui/fleet/models/agent_version.dart';

enum EnvironmentType { dev, stage, prod }

enum EnvironmentStatus { healthy, degraded, maintenance, deploying }

class FleetEnvironment {
  final String id;
  final String fleetId;
  final String name;
  final EnvironmentType type;
  final AgentVersion currentVersion;
  final AgentVersion? previousVersion; // For rollback
  final double healthScore; // 0.0 to 1.0
  final int activeNodes;
  final EnvironmentStatus status;

  const FleetEnvironment({
    required this.id,
    required this.fleetId,
    required this.name,
    required this.type,
    required this.currentVersion,
    this.previousVersion,
    required this.healthScore,
    required this.activeNodes,
    required this.status,
  });

  FleetEnvironment copyWith({
    String? name,
    EnvironmentType? type,
    AgentVersion? currentVersion,
    AgentVersion? previousVersion,
    double? healthScore,
    int? activeNodes,
    EnvironmentStatus? status,
  }) {
    return FleetEnvironment(
      id: id,
      fleetId: fleetId,
      name: name ?? this.name,
      type: type ?? this.type,
      currentVersion: currentVersion ?? this.currentVersion,
      previousVersion: previousVersion ?? this.previousVersion,
      healthScore: healthScore ?? this.healthScore,
      activeNodes: activeNodes ?? this.activeNodes,
      status: status ?? this.status,
    );
  }
}
