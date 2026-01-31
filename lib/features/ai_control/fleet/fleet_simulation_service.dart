import 'package:testable/features/ai_control/fleet/fleet_models.dart';

class FleetSimulationService {
  Stream<List<AgentFleet>> get fleetStream async* {
    while (true) {
      yield [
        AgentFleet(
          id: 'fleet_1',
          name: 'Customer Support Cluster',
          description: 'Llama-3-8B based support agents for EMEA.',
          status: FleetStatus.active,
          agentCount: 42,
          loadFactor: 0.76,
          region: 'eu-west-1',
        ),
        AgentFleet(
          id: 'fleet_2',
          name: 'Market Analysis Swarm',
          description: 'High-frequency analysis using Mistral-Nemo.',
          status: FleetStatus.active,
          agentCount: 128,
          loadFactor: 0.92,
          region: 'us-east-1',
        ),
        AgentFleet(
          id: 'fleet_3',
          name: 'Security Scraper',
          description: 'Vulnerability scanning and reporting.',
          status: FleetStatus.idle,
          agentCount: 15,
          loadFactor: 0.12,
          region: 'ap-southeast-1',
        ),
        AgentFleet(
          id: 'fleet_4',
          name: 'Code Reviewer Pro',
          description: 'Automated PR analysis for engineering teams.',
          status: FleetStatus.deploying,
          agentCount: 0,
          loadFactor: 0.0,
          region: 'us-west-2',
        ),
        AgentFleet(
          id: 'fleet_5',
          name: 'Legacy Parser',
          description: 'Retired fleet for archival data processing.',
          status: FleetStatus.error,
          agentCount: 4,
          loadFactor: 0.0,
          region: 'us-east-1',
        ),
      ];
      await Future.delayed(const Duration(seconds: 4));
    }
  }

  Future<DeploymentMetrics> getMetrics() async {
    return const DeploymentMetrics(
      successfulDeployments: 1242,
      failedDeployments: 8,
      averageStartupTime: 12.4,
    );
  }
}
