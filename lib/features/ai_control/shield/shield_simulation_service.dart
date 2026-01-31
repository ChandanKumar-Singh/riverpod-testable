import 'dart:async';
import 'package:testable/features/ai_control/shield/shield_models.dart';

class ShieldSimulationService {
  List<GuardrailRule> getInitialRules() {
    return [
      const GuardrailRule(
        id: 'pii_leak',
        name: 'PII LEAK PREVENTION',
        description:
            'Blocks responses containing SSN, credit cards, or emails.',
        category: GuardrailCategory.privacy,
        severity: RuleSeverity.high,
        threshold: 0.95,
        unit: 'Confidence',
      ),
      const GuardrailRule(
        id: 'budget_limit',
        name: 'DAILY BUDGET CAP',
        description: 'Hard limit on daily inference spend per agent.',
        category: GuardrailCategory.financial,
        severity: RuleSeverity.critical,
        threshold: 500.0,
        unit: '\$',
      ),
      const GuardrailRule(
        id: 'prompt_injection',
        name: 'INJECTION SCANNER',
        description: 'Detects and blocks adversarial prompt structures.',
        category: GuardrailCategory.security,
        severity: RuleSeverity.high,
        threshold: 0.85,
        unit: 'Risk Score',
      ),
      const GuardrailRule(
        id: 'latency_guard',
        name: 'LATENCY OVERFLOW',
        description: 'Alerts when agent response time exceeds threshold.',
        category: GuardrailCategory.performance,
        severity: RuleSeverity.medium,
        threshold: 2000.0,
        unit: 'ms',
      ),
    ];
  }

  Future<SimulationResult> runSimulation(String input) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (input.contains("4242")) {
      return const SimulationResult(
        isAllowed: false,
        message: "Blocked: Potential credit card number detected in payload.",
        riskScore: 0.98,
        triggeredRuleId: 'pii_leak',
      );
    }
    return const SimulationResult(
      isAllowed: true,
      message: "Safety validation passed. No violations detected.",
      riskScore: 0.02,
    );
  }
}
