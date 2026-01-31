import 'package:testable/ui/guardrails/models/guardrail_models.dart';

class GuardrailSimulationService {
  SimulationResult evaluate({
    required String input,
    required List<GuardrailRule> activeRules,
    required bool isEmergencyHaltActive,
  }) {
    if (isEmergencyHaltActive) {
      return SimulationResult.blocked(
        'HALT_ALL',
        'EMERGENCY OVERRIDE: ALL SYSTEMS STOPPED',
        1.0,
      );
    }

    for (final rule in activeRules) {
      if (!rule.isActive) continue;

      final result = _evaluateRule(input, rule);
      if (result.isBlocked) return result;
    }

    return SimulationResult.allowed(0.0);
  }

  SimulationResult _evaluateRule(String input, GuardrailRule rule) {
    // Deterministic evaluation based on rule ID and input content
    switch (rule.id) {
      case 'safety_toxic':
        if (input.toLowerCase().contains('attack') ||
            input.toLowerCase().contains('kill')) {
          return SimulationResult.blocked(
            rule.id,
            'Toxicity detected above threshold',
            0.95,
          );
        }
        break;
      case 'privacy_pii':
        final emailRegex = RegExp(r'[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+');
        if (emailRegex.hasMatch(input)) {
          return SimulationResult.blocked(
            rule.id,
            'Personally Identifiable Information (PII) detected',
            1.0,
          );
        }
        break;
      case 'financial_spend':
        if (input.length > rule.threshold * 100) {
          return SimulationResult.blocked(
            rule.id,
            'Transaction volume exceeds dynamic limit',
            0.88,
          );
        }
        break;
      case 'operational_latency':
        if (input.contains('slow_test')) {
          return SimulationResult.blocked(
            rule.id,
            'Predicted latency exceeds 500ms limit',
            0.75,
          );
        }
        break;
    }

    return SimulationResult.allowed(0.0);
  }
}
