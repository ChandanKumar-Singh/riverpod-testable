import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/features/ai_control/matrix/matrix_models.dart';
import 'package:testable/features/ai_control/matrix/matrix_simulation_service.dart';

class MatrixFilter {
  final Set<String> selectedProviders;
  const MatrixFilter({
    this.selectedProviders = const {'OpenAI', 'Anthropic', 'Google', 'Local'},
  });

  MatrixFilter copyWith({Set<String>? selectedProviders}) {
    return MatrixFilter(
      selectedProviders: selectedProviders ?? this.selectedProviders,
    );
  }
}

// Service Provider
final matrixSimulationServiceProvider = Provider<MatrixSimulationService>((
  ref,
) {
  return MatrixSimulationService();
});

// Data Provider (All Models)
final matrixMetricsProvider = FutureProvider<List<ModelProfile>>((ref) async {
  final service = ref.read(matrixSimulationServiceProvider);
  return service.getModelProfiles();
});

// UI State: Selection
final selectedModelIdProvider = StateProvider<String?>((ref) => null);

// Derived State: Selected Model Profile
final selectedModelProfileProvider = Provider<AsyncValue<ModelProfile?>>((ref) {
  final metricsAsync = ref.watch(matrixMetricsProvider);
  final selectedId = ref.watch(selectedModelIdProvider);

  return metricsAsync.whenData((models) {
    if (selectedId == null) return null;
    try {
      return models.firstWhere((m) => m.id == selectedId);
    } catch (_) {
      return null;
    }
  });
});

// UI State: Projection Mode
final projectionModeProvider = StateProvider<bool>((ref) => false);

// UI State: Filter
final matrixFilterProvider = StateProvider<MatrixFilter>(
  (ref) => const MatrixFilter(),
);

// UI State: Selection (Alias for chart)
final selectedModelPointProvider = selectedModelIdProvider;

// Derived State: Filtered Metrics
final filteredMetricsProvider = Provider<List<InferenceMetric>>((ref) {
  final AsyncValue<List<ModelProfile>> metricsAsync = ref.watch(
    matrixMetricsProvider,
  );
  final MatrixFilter filter = ref.watch(matrixFilterProvider);

  return metricsAsync.maybeWhen(
    data: (List<ModelProfile> models) {
      // In a real app, m.metrics would be filled. Here we might need to mock them if missing.
      final List<InferenceMetric> allMetrics = models.map((m) {
        return InferenceMetric(
          model: m,
          avgLatencyMs: m.latencyMs,
          costPerMillionTokens: m.costPerMillionTokens,
          throughputTokensSec: 45.0,
          reliability: 0.99,
          projectedMetric: InferenceMetric(
            model: m,
            avgLatencyMs: m.latencyMs * 0.7,
            costPerMillionTokens: m.costPerMillionTokens * 0.6,
            throughputTokensSec: 65.0,
            reliability: 0.98,
          ),
        );
      }).toList();

      return allMetrics.where((InferenceMetric m) {
        return filter.selectedProviders.contains(m.model.provider);
      }).toList();
    },
    orElse: () => <InferenceMetric>[],
  );
});

// Optimization Insights Provider
final optimizationInsightsProvider = Provider<List<OptimizationInsight>>((ref) {
  return ref.watch(matrixSimulationServiceProvider).getInsights();
});
