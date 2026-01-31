import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/ui/guardrails/models/guardrail_models.dart';
import 'package:testable/ui/guardrails/services/guardrail_simulation_service.dart';

// Service Provider
final guardrailSimulationServiceProvider = Provider(
  (ref) => GuardrailSimulationService(),
);

// Emergency Halt State
final emergencyHaltProvider = StateProvider<bool>((ref) => false);

// Active Category Navigation
final activeGuardrailCategoryProvider = StateProvider<GuardrailCategory>(
  (ref) => GuardrailCategory.safety,
);

// Policy Management State
class GuardrailPolicyNotifier extends StateNotifier<List<GuardrailRule>> {
  GuardrailPolicyNotifier() : super(_initialRules);

  static final List<GuardrailRule> _initialRules = [
    const GuardrailRule(
      id: 'safety_toxic',
      category: GuardrailCategory.safety,
      name: 'Toxicity Detection',
      description: 'Intercepts harmful or violent content patterns.',
      threshold: 0.8,
      severity: RuleSeverity.critical,
    ),
    const GuardrailRule(
      id: 'privacy_pii',
      category: GuardrailCategory.privacy,
      name: 'PII Shield',
      description: 'Automatically redacts emails and personal data.',
      threshold: 1.0,
      severity: RuleSeverity.critical,
    ),
    const GuardrailRule(
      id: 'financial_spend',
      category: GuardrailCategory.financial,
      name: 'Budget CAP',
      description: 'Limits individual request cost impact.',
      threshold: 0.5,
      unit: '\$',
      severity: RuleSeverity.warning,
    ),
    const GuardrailRule(
      id: 'operational_latency',
      category: GuardrailCategory.operational,
      name: 'Latency Guard',
      description: 'Blocks prompts likely to cause timeouts.',
      threshold: 0.7,
      unit: 'ms',
      severity: RuleSeverity.info,
    ),
    const GuardrailRule(
      id: 'rate_limit_throttle',
      category: GuardrailCategory.rateLimits,
      name: 'Rate Limiter',
      description: 'Prevents overwhelming downstream services.',
      threshold: 1000,
      unit: 'req/s',
      severity: RuleSeverity.warning,
    ),
    const GuardrailRule(
      id: 'behavioral_jailbreak',
      category: GuardrailCategory.behavioral,
      name: 'Jailbreak Guard',
      description: 'Detects prompt injection attempts.',
      threshold: 0.9,
      severity: RuleSeverity.critical,
    ),
  ];

  void toggleRule(String id) {
    state = [
      for (final rule in state)
        if (rule.id == id) rule.copyWith(isActive: !rule.isActive) else rule,
    ];
  }

  void updateThreshold(String id, double threshold) {
    state = [
      for (final rule in state)
        if (rule.id == id) rule.copyWith(threshold: threshold) else rule,
    ];
  }

  void updateSeverity(String id, RuleSeverity severity) {
    state = [
      for (final rule in state)
        if (rule.id == id) rule.copyWith(severity: severity) else rule,
    ];
  }
}

final guardrailPolicyProvider =
    StateNotifierProvider<GuardrailPolicyNotifier, List<GuardrailRule>>((ref) {
      return GuardrailPolicyNotifier();
    });

// Simulation Sandbox State
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

    // Artificial delay for UX feel
    await Future.delayed(const Duration(milliseconds: 300));

    final service = _ref.read(guardrailSimulationServiceProvider);
    final rules = _ref.read(guardrailPolicyProvider);
    final halt = _ref.read(emergencyHaltProvider);

    final result = service.evaluate(
      input: input,
      activeRules: rules,
      isEmergencyHaltActive: halt,
    );

    state = AsyncValue.data(result);
  }
}

final sandboxSimulationProvider =
    StateNotifierProvider<
      SandboxSimulationNotifier,
      AsyncValue<SimulationResult?>
    >((ref) {
      return SandboxSimulationNotifier(ref);
    });
