import 'package:testable/ui/trace/models/trace_node.dart';

enum RunStatus { success, failed, running }

class TraceEdge {
  final String fromNodeId;
  final String toNodeId;

  const TraceEdge({required this.fromNodeId, required this.toNodeId});
}

class AgentRun {
  final String id;
  final DateTime startTime;
  final double totalCost;
  final RunStatus status;
  final List<TraceNode> nodes;
  final List<TraceEdge> edges;

  const AgentRun({
    required this.id,
    required this.startTime,
    required this.totalCost,
    required this.status,
    required this.nodes,
    required this.edges,
  });

  Map<String, TraceNode> get nodeMap => {for (var n in nodes) n.id: n};

  Duration get totalDuration {
    if (nodes.isEmpty) return Duration.zero;
    final maxEnd = nodes
        .map((n) => n.endTime.inMilliseconds)
        .reduce((a, b) => a > b ? a : b);
    return Duration(milliseconds: maxEnd);
  }

  factory AgentRun.initial() {
    return AgentRun(
      id: 'empty',
      startTime: DateTime.now(),
      totalCost: 0.0,
      status: RunStatus.running,
      nodes: [],
      edges: [],
    );
  }
}
