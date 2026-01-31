enum GuardrailCategory { security, privacy, financial, performance, behavioral }

enum RuleSeverity { low, medium, high, critical }

class GuardrailRule {
  final String id;
  final String name;
  final String description;
  final GuardrailCategory category;
  final RuleSeverity severity;
  final double threshold;
  final String unit;
  final bool isActive;

  const GuardrailRule({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.severity,
    required this.threshold,
    required this.unit,
    this.isActive = true,
  });

  GuardrailRule copyWith({
    bool? isActive,
    double? threshold,
    RuleSeverity? severity,
  }) {
    return GuardrailRule(
      id: id,
      name: name,
      description: description,
      category: category,
      severity: severity ?? this.severity,
      threshold: threshold ?? this.threshold,
      unit: unit,
      isActive: isActive ?? this.isActive,
    );
  }
}

class SimulationResult {
  final bool isAllowed;
  final String message;
  final double riskScore;
  final String? triggeredRuleId;

  const SimulationResult({
    required this.isAllowed,
    required this.message,
    required this.riskScore,
    this.triggeredRuleId,
  });
}
