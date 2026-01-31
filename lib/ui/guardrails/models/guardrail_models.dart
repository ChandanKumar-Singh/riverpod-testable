enum RuleSeverity { info, warning, critical }

enum GuardrailCategory {
  safety,
  privacy,
  financial,
  operational,
  budget,
  rateLimits,
  behavioral,
}

class GuardrailRule {
  const GuardrailRule({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.threshold,
    this.unit = '%',
    this.severity = RuleSeverity.warning,
    this.isActive = true,
    this.isEnabled = true,
  });

  final String id;
  final GuardrailCategory category;
  final String name;
  final String description;
  final double threshold;
  final String unit;
  final RuleSeverity severity;
  final bool isActive;
  final bool isEnabled;

  GuardrailRule copyWith({
    double? threshold,
    RuleSeverity? severity,
    bool? isActive,
    bool? isEnabled,
  }) {
    return GuardrailRule(
      id: id,
      category: category,
      name: name,
      description: description,
      threshold: threshold ?? this.threshold,
      unit: unit,
      severity: severity ?? this.severity,
      isActive: isActive ?? this.isActive,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class SimulationResult {
  const SimulationResult({
    required this.isBlocked,
    this.blockedByRuleId,
    this.message,
    required this.score,
    required this.timestamp,
  });

  factory SimulationResult.allowed(double score) => SimulationResult(
    isBlocked: false,
    score: score,
    timestamp: DateTime.now(),
  );

  factory SimulationResult.blocked(
    String ruleId,
    String message,
    double score,
  ) => SimulationResult(
    isBlocked: true,
    blockedByRuleId: ruleId,
    message: message,
    score: score,
    timestamp: DateTime.now(),
  );

  final bool isBlocked;
  final String? blockedByRuleId;
  final String? message;
  final double score;
  final DateTime timestamp;

  bool get isAllowed => !isBlocked;
}
