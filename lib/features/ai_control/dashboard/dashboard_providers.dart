import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/features/ai_control/dashboard/dashboard_models.dart';
import 'package:testable/features/ai_control/dashboard/dashboard_simulation_service.dart';

final dashboardSimulationServiceProvider = Provider<DashboardSimulationService>(
  (ref) {
    return DashboardSimulationService();
  },
);

final kpiListProvider = StreamProvider<List<DashboardKpi>>((ref) {
  return ref.watch(dashboardSimulationServiceProvider).kpiStream;
});

final systemHealthProvider = StreamProvider<SystemHealth>((ref) {
  return ref.watch(dashboardSimulationServiceProvider).healthStream;
});
