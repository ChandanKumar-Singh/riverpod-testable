import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/features/ai_control/fleet/fleet_models.dart';
import 'package:testable/features/ai_control/fleet/fleet_simulation_service.dart';

final fleetSimulationServiceProvider = Provider<FleetSimulationService>((ref) {
  return FleetSimulationService();
});

final fleetListStreamProvider = StreamProvider<List<AgentFleet>>((ref) {
  return ref.watch(fleetSimulationServiceProvider).fleetStream;
});

final selectedFleetIdProvider = StateProvider<String?>((ref) => null);

final selectedFleetProvider = Provider<AgentFleet?>((ref) {
  final fleets = ref.watch(fleetListStreamProvider).value;
  final id = ref.watch(selectedFleetIdProvider);
  if (fleets == null || id == null) return null;
  return fleets.firstWhere((f) => f.id == id);
});
