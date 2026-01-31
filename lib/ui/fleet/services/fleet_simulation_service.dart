import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:testable/ui/fleet/models/agent_fleet.dart';
import 'package:testable/ui/fleet/models/agent_version.dart';
import 'package:testable/ui/fleet/models/fleet_environment.dart';

enum DeploymentStep { idle, building, deploying, verifying, success, failure }

class FleetSimulationService {
  // Mock Data
  static final _v1 = AgentVersion(
    id: 'v1',
    version: 'v1.0.2',
    commitHash: 'a1b2c3d',
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
    description: 'Stable release',
  );

  static final _v2 = AgentVersion(
    id: 'v2',
    version: 'v1.1.0-rc1',
    commitHash: 'e5f6g7h',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    description: 'Performance improvements',
  );

  final List<AgentFleet> _mockFleets = [
    AgentFleet(
      id: 'f1',
      name: 'CustomerSupport-V1',
      description: 'Primary customer facing chat agents',
      tags: ['LLM', 'High-Traffic'],
      environments: [
        FleetEnvironment(
          id: 'env_dev',
          fleetId: 'f1',
          name: 'Develop-US',
          type: EnvironmentType.dev,
          currentVersion: _v2,
          previousVersion: _v1,
          healthScore: 0.98,
          activeNodes: 5,
          status: EnvironmentStatus.healthy,
        ),
        FleetEnvironment(
          id: 'env_stage',
          fleetId: 'f1',
          name: 'Staging-EU',
          type: EnvironmentType.stage,
          currentVersion: _v1,
          previousVersion: null,
          healthScore: 1.0,
          activeNodes: 2,
          status: EnvironmentStatus.healthy,
        ),
        FleetEnvironment(
          id: 'env_prod',
          fleetId: 'f1',
          name: 'Production-Global',
          type: EnvironmentType.prod,
          currentVersion: _v1,
          previousVersion: null,
          healthScore: 0.99,
          activeNodes: 150,
          status: EnvironmentStatus.healthy,
        ),
      ],
    ),
    AgentFleet(
      id: 'f2',
      name: 'DataAnalyst-Alpha',
      description: 'Internal financial reporting agents',
      tags: ['Batch', 'Secure'],
      environments: [
        FleetEnvironment(
          id: 'env_internal',
          fleetId: 'f2',
          name: 'Internal-Prod',
          type: EnvironmentType.prod,
          currentVersion: _v1,
          previousVersion: null,
          healthScore: 0.85,
          activeNodes: 12,
          status: EnvironmentStatus.degraded,
        ),
      ],
    ),
  ];

  // In-memory state for environments to support live updates
  final BehaviorSubject<List<AgentFleet>> _fleetsController =
      BehaviorSubject<List<AgentFleet>>();

  FleetSimulationService() {
    _fleetsController.add(_mockFleets);
  }

  Stream<List<AgentFleet>> get fleetsStream => _fleetsController.stream;

  /// Starts a deterministic deployment sequence
  Stream<DeploymentStep> simulateDeployment(
    String envId,
    String versionId,
  ) async* {
    _updateEnvironmentStatus(envId, EnvironmentStatus.deploying);

    yield DeploymentStep.building;
    await Future.delayed(const Duration(seconds: 2));

    yield DeploymentStep.deploying;
    await Future.delayed(const Duration(seconds: 3));

    yield DeploymentStep.verifying;
    await Future.delayed(const Duration(seconds: 2));

    yield DeploymentStep.success;

    // Update local state to reflect new version
    _finalizeDeployment(envId, versionId);
  }

  void rollback(String envId) {
    final currentFleets = _fleetsController.value;
    final fleetIndex = currentFleets.indexWhere(
      (f) => f.environments.any((e) => e.id == envId),
    );
    if (fleetIndex == -1) return;

    final fleet = currentFleets[fleetIndex];
    final envIndex = fleet.environments.indexWhere((e) => e.id == envId);
    final env = fleet.environments[envIndex];

    if (env.previousVersion != null) {
      final updatedEnv = env.copyWith(
        currentVersion: env.previousVersion,
        previousVersion: env.currentVersion, // Swap for toggle capability
        status: EnvironmentStatus.healthy,
      );

      final updatedEnvironments = List<FleetEnvironment>.from(
        fleet.environments,
      );
      updatedEnvironments[envIndex] = updatedEnv;

      final updatedFleets = List<AgentFleet>.from(currentFleets);
      updatedFleets[fleetIndex] = fleet.copyWith(
        environments: updatedEnvironments,
      );

      _fleetsController.add(updatedFleets);
    }
  }

  void toggleMaintenance(String envId, bool isMaintenance) {
    _updateEnvironmentStatus(
      envId,
      isMaintenance ? EnvironmentStatus.maintenance : EnvironmentStatus.healthy,
    );
  }

  void _updateEnvironmentStatus(String envId, EnvironmentStatus status) {
    final currentFleets = _fleetsController.value;
    final fleetIndex = currentFleets.indexWhere(
      (f) => f.environments.any((e) => e.id == envId),
    );
    if (fleetIndex == -1) return;

    final fleet = currentFleets[fleetIndex];
    final envIndex = fleet.environments.indexWhere((e) => e.id == envId);
    final env = fleet.environments[envIndex];

    final updatedEnv = env.copyWith(status: status);
    final updatedEnvironments = List<FleetEnvironment>.from(fleet.environments);
    updatedEnvironments[envIndex] = updatedEnv;

    final updatedFleets = List<AgentFleet>.from(currentFleets);
    updatedFleets[fleetIndex] = fleet.copyWith(
      environments: updatedEnvironments,
    );

    _fleetsController.add(updatedFleets);
  }

  void _finalizeDeployment(String envId, String versionId) {
    final currentFleets = _fleetsController.value;
    final fleetIndex = currentFleets.indexWhere(
      (f) => f.environments.any((e) => e.id == envId),
    );
    if (fleetIndex == -1) return;

    final fleet = currentFleets[fleetIndex];
    final envIndex = fleet.environments.indexWhere((e) => e.id == envId);
    final env = fleet.environments[envIndex];

    // Determine new version object (mock logic)
    final newVersion = versionId == _v1.id ? _v1 : _v2;

    final updatedEnv = env.copyWith(
      currentVersion: newVersion,
      previousVersion: env.currentVersion,
      status: EnvironmentStatus.healthy,
    );

    final updatedEnvironments = List<FleetEnvironment>.from(fleet.environments);
    updatedEnvironments[envIndex] = updatedEnv;

    final updatedFleets = List<AgentFleet>.from(currentFleets);
    updatedFleets[fleetIndex] = fleet.copyWith(
      environments: updatedEnvironments,
    );

    _fleetsController.add(updatedFleets);
  }
}
