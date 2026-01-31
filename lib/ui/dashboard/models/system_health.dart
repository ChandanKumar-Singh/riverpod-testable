enum NetworkStatus { stable, degraded, offline }

class SystemHealth {
  final double cpuUsage; // 0.0 to 1.0
  final double memoryUsage; // 0.0 to 1.0
  final NetworkStatus networkStatus;
  final Duration uptimeDuration;

  const SystemHealth({
    required this.cpuUsage,
    required this.memoryUsage,
    required this.networkStatus,
    required this.uptimeDuration,
  });

  factory SystemHealth.initial() {
    return const SystemHealth(
      cpuUsage: 0.0,
      memoryUsage: 0.0,
      networkStatus: NetworkStatus.stable,
      uptimeDuration: Duration.zero,
    );
  }
}
