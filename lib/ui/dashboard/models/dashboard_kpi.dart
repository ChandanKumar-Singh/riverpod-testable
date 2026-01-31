class DashboardKPI {
  final int activeAgents;
  final double tokensPerSecond;
  final double successRate;
  final int avgLatencyMs;
  final DateTime timestamp;

  const DashboardKPI({
    required this.activeAgents,
    required this.tokensPerSecond,
    required this.successRate,
    required this.avgLatencyMs,
    required this.timestamp,
  });

  factory DashboardKPI.initial() {
    return DashboardKPI(
      activeAgents: 0,
      tokensPerSecond: 0.0,
      successRate: 0.0,
      avgLatencyMs: 0,
      timestamp: DateTime.now(),
    );
  }
}
