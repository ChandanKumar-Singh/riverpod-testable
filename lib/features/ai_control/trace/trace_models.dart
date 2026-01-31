enum TraceNodeType { user, router, agent, tool, knowledgeBase, model }

class TraceNode {
  final String id;
  final String label;
  final TraceNodeType type;
  final String? detail;
  final DateTime timestamp;
  final Duration latency;
  final bool isError;

  const TraceNode({
    required this.id,
    required this.label,
    required this.type,
    this.detail,
    required this.timestamp,
    required this.latency,
    this.isError = false,
  });
}

class TraceEdge {
  final String fromId;
  final String toId;
  final String? label;

  const TraceEdge({required this.fromId, required this.toId, this.label});
}

class AgentTrace {
  final String id;
  final List<TraceNode> nodes;
  final List<TraceEdge> edges;

  const AgentTrace({
    required this.id,
    required this.nodes,
    required this.edges,
  });
}
