import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/ui/fleet/models/agent_fleet.dart';
import 'package:testable/ui/fleet/services/fleet_simulation_service.dart';

// Service Provider
final fleetSimulationServiceProvider = Provider(
  (ref) => FleetSimulationService(),
);

// Data Provider (Fleets) - Now streams live updates
final fleetListStreamProvider = StreamProvider<List<AgentFleet>>((ref) {
  final service = ref.watch(fleetSimulationServiceProvider);
  return service.fleetsStream;
});

// Selection State
final selectedFleetIdProvider = StateProvider<String?>((ref) => null);

final selectedFleetProvider = Provider<AsyncValue<AgentFleet?>>((ref) {
  final fleetsAsync = ref.watch(fleetListStreamProvider);
  final selectedId = ref.watch(selectedFleetIdProvider);

  return fleetsAsync.whenData((fleets) {
    if (selectedId == null && fleets.isNotEmpty) {
      // Auto-select first if none selected
      Future.microtask(
        () =>
            ref.read(selectedFleetIdProvider.notifier).state = fleets.first.id,
      );
      return fleets.first;
    }
    return fleets.firstWhere(
      (f) => f.id == selectedId,
      orElse: () => fleets.first,
    );
  });
});

// Deployment State
// Map<EnvironmentID, DeploymentStep>
class DeploymentStateNotifier
    extends StateNotifier<Map<String, DeploymentStep>> {
  final FleetSimulationService _service;

  DeploymentStateNotifier(this._service) : super({});

  Future<void> startDeployment(String envId, String versionId) async {
    // Check if already active
    if (state.containsKey(envId) &&
        state[envId] != DeploymentStep.success &&
        state[envId] != DeploymentStep.failure) {
      return;
    }

    _service
        .simulateDeployment(envId, versionId)
        .listen(
          (step) {
            state = {...state, envId: step};
            if (step == DeploymentStep.success ||
                step == DeploymentStep.failure) {
              // Clear after delay or keep for user acknowledgment?
              // For demo, keep 'success' visible until next action or timeout
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted) {
                  final newState = {...state};
                  newState.remove(envId);
                  state = newState;
                }
              });
            }
          },
          onError: (_) {
            state = {...state, envId: DeploymentStep.failure};
          },
        );
  }

  void rollback(String envId) {
    _service.rollback(envId);
  }

  void toggleMaintenance(String envId, bool isActive) {
    _service.toggleMaintenance(envId, isActive);
  }
}

final deploymentControllerProvider =
    StateNotifierProvider<DeploymentStateNotifier, Map<String, DeploymentStep>>(
      (ref) {
        final service = ref.watch(fleetSimulationServiceProvider);
        return DeploymentStateNotifier(service);
      },
    );
