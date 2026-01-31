import 'package:testable/ui/fleet/models/fleet_environment.dart';

class AgentFleet {
  final String id;
  final String name;
  final String description;
  final List<String> tags;
  final List<FleetEnvironment> environments;

  const AgentFleet({
    required this.id,
    required this.name,
    required this.description,
    required this.tags,
    required this.environments,
  });

  AgentFleet copyWith({
    String? name,
    String? description,
    List<String>? tags,
    List<FleetEnvironment>? environments,
  }) {
    return AgentFleet(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      environments: environments ?? this.environments,
    );
  }
}
