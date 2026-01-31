import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/ui/dashboard/models/dashboard_kpi.dart';
import 'package:testable/ui/dashboard/models/system_event.dart';
import 'package:testable/ui/dashboard/models/system_health.dart';
import 'package:testable/ui/dashboard/providers/dashboard_state.dart';
import 'package:testable/ui/dashboard/services/simulation_service.dart';

// Service Provider
final simulationServiceProvider = Provider<SimulationService>((ref) {
  final service = SimulationService();
  ref.onDispose(() => service.dispose());
  return service;
});

// UI State Provider
final dashboardStateProvider =
    StateNotifierProvider<DashboardStateNotifier, DashboardState>((ref) {
      return DashboardStateNotifier();
    });

class DashboardStateNotifier extends StateNotifier<DashboardState> {
  DashboardStateNotifier() : super(const DashboardState());

  void toggleFocusMode() {
    state = state.copyWith(isFocusMode: !state.isFocusMode);
  }

  void selectKpi(String? kpiId) {
    if (state.selectedKpiId == kpiId) {
      state = state.copyWith(selectedKpiId: null); // Deselect if same
    } else {
      state = state.copyWith(selectedKpiId: kpiId);
    }
  }
}

// Data Streams
final kpiStreamProvider = StreamProvider<DashboardKPI>((ref) {
  final service = ref.watch(simulationServiceProvider);
  return service.kpiStream;
});

final eventLogStreamProvider = StreamProvider<List<SystemEvent>>((ref) {
  final service = ref.watch(simulationServiceProvider);
  return service.eventStream;
});

final systemStatusStreamProvider = StreamProvider<SystemHealth>((ref) {
  final service = ref.watch(simulationServiceProvider);
  return service.healthStream;
});
