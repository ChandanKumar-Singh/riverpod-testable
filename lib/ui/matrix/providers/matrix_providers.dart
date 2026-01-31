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
final matrixSimulationServiceProvider = Provider<MatrixSimulationService>(
  (ref) => MatrixSimulationService(),
);

// Data Provider (All Models)
final matrixMetricsProvider = FutureProvider<List<ModelProfile>>((ref) async {
  final service = ref.read(matrixSimulationServiceProvider);
  return service.getModelProfiles();
});

// UI State: Selection
final StateProvider<String?> selectedModelIdProvider = StateProvider<String?>(
  (ref) => null,
);

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
final StateProvider<bool> projectionModeProvider = StateProvider<bool>(
  (ref) => false,
);

// UI State: Filter
final StateProvider<MatrixFilter> matrixFilterProvider =
    StateProvider<MatrixFilter>((ref) => const MatrixFilter());

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
      final List<InferenceMetric> allMetrics = models
          .expand((m) => m.metrics)
          .toList();
      return allMetrics.where((InferenceMetric m) {
        return filter.selectedProviders.contains(m.model.provider);
      }).toList();
    },
    orElse: () => <InferenceMetric>[],
  );
});

// Optimization Insights Provider
final optimizationInsightsProvider = Provider<List<OptimizationInsight>>((ref) {
  final AsyncValue<List<ModelProfile>> metricsAsync = ref.watch(
    matrixMetricsProvider,
  );

  return metricsAsync.maybeWhen(
    data: (List<ModelProfile> models) {
      return models
          .where((m) => m.costPerMillionTokens > 10.0)
          .map(
            (m) => OptimizationInsight(
              modelId: m.id,
              title: 'Optimize ${m.name}',
              description:
                  'Switching to quantizing weights can reduce costs while maintaining quality.',
              recommendation: 'Use 4-bit quantization',
              potentialSavingsPerc: 0.3,
            ),
          )
          .toList();
    },
    orElse: () => <OptimizationInsight>[],
  );
});
