enum FleetStatus { active, idle, error, deploying }

class AgentFleet {
  final String id;
  final String name;
  final String description;
  final FleetStatus status;
  final int agentCount;
  final double loadFactor;
  final String region;

  const AgentFleet({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.agentCount,
    required this.loadFactor,
    required this.region,
  });
}

class DeploymentMetrics {
  final int successfulDeployments;
  final int failedDeployments;
  final double averageStartupTime;

  const DeploymentMetrics({
    required this.successfulDeployments,
    required this.failedDeployments,
    required this.averageStartupTime,
  });
}
