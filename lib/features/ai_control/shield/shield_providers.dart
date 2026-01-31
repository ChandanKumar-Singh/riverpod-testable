import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/features/ai_control/shield/shield_models.dart';
import 'package:testable/features/ai_control/shield/shield_simulation_service.dart';

final shieldSimulationServiceProvider = Provider<ShieldSimulationService>((
  ref,
) {
  return ShieldSimulationService();
});

final guardrailPolicyProvider =
    StateNotifierProvider<GuardrailPolicyNotifier, List<GuardrailRule>>((ref) {
      return GuardrailPolicyNotifier(
        ref.watch(shieldSimulationServiceProvider).getInitialRules(),
      );
    });

class GuardrailPolicyNotifier extends StateNotifier<List<GuardrailRule>> {
  GuardrailPolicyNotifier(super.initialState);

  void toggleRule(String id) {
    state = [
      for (final rule in state)
        if (rule.id == id) rule.copyWith(isActive: !rule.isActive) else rule,
    ];
  }

  void updateThreshold(String id, double value) {
    state = [
      for (final rule in state)
        if (rule.id == id) rule.copyWith(threshold: value) else rule,
    ];
  }
}

final emergencyHaltProvider = StateProvider<bool>((ref) => false);

final sandboxSimulationProvider =
    StateNotifierProvider<
      SandboxSimulationNotifier,
      AsyncValue<SimulationResult?>
    >((ref) {
      return SandboxSimulationNotifier(ref);
    });

class SandboxSimulationNotifier
    extends StateNotifier<AsyncValue<SimulationResult?>> {
  final Ref _ref;
  SandboxSimulationNotifier(this._ref) : super(const AsyncValue.data(null));

  Future<void> runSimulation(String input) async {
    if (input.isEmpty) {
      state = const AsyncValue.data(null);
      return;
    }
    state = const AsyncValue.loading();
    try {
      final result = await _ref
          .read(shieldSimulationServiceProvider)
          .runSimulation(input);
      state = AsyncValue.data(result);
    } catch (e, s) {
      state = AsyncValue.error(e, s);
    }
  }
}
