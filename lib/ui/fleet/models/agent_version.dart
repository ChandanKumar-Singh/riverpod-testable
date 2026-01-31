class AgentVersion {
  final String id;
  final String version; // e.g., "v1.2.0"
  final String commitHash;
  final DateTime createdAt;
  final String description;

  const AgentVersion({
    required this.id,
    required this.version,
    required this.commitHash,
    required this.createdAt,
    required this.description,
  });

  AgentVersion copyWith({
    String? version,
    String? commitHash,
    DateTime? createdAt,
    String? description,
  }) {
    return AgentVersion(
      id: id,
      version: version ?? this.version,
      commitHash: commitHash ?? this.commitHash,
      createdAt: createdAt ?? this.createdAt,
      description: description ?? this.description,
    );
  }

  factory AgentVersion.fromJson(Map<String, dynamic> json) {
    return AgentVersion(
      id: json['id'] as String,
      version: json['version'] as String,
      commitHash: json['commitHash'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      description: json['description'] as String,
    );
  }
}
