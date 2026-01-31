import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/features/ai_control/trace/trace_models.dart';
import 'package:testable/features/ai_control/trace/trace_simulation_service.dart';

final traceSimulationServiceProvider = Provider<TraceSimulationService>((ref) {
  return TraceSimulationService();
});

final activeTraceProvider = StateProvider<AgentTrace?>((ref) {
  final service = ref.watch(traceSimulationServiceProvider);
  return service.generateMockTrace();
});

final selectedNodeIdProvider = StateProvider<String?>((ref) => null);
