enum TraceNodeType { thought, tool_call, llm_call, system_msg }

enum TraceNodeStatus { pending, active, completed, failed }

class TraceNode {
  final String id;
  final TraceNodeType type;
  final String label;
  final Duration startTime;
  final Duration endTime;
  final Map<String, dynamic> input;
  final Map<String, dynamic> output;
  final String? error;
  final double cost;

  const TraceNode({
    required this.id,
    required this.type,
    required this.label,
    required this.startTime,
    required this.endTime,
    required this.input,
    required this.output,
    this.error,
    required this.cost,
  });

  Duration get duration => endTime - startTime;

  // Helper to determine status based on playback time
  TraceNodeStatus getStatus(Duration currentTime) {
    if (currentTime < startTime) return TraceNodeStatus.pending;
    if (currentTime < endTime) return TraceNodeStatus.active;
    if (error != null) return TraceNodeStatus.failed;
    return TraceNodeStatus.completed;
  }

  factory TraceNode.fromJson(Map<String, dynamic> json) {
    return TraceNode(
      id: json['id'] as String,
      type: TraceNodeType.values.firstWhere((e) => e.name == json['type']),
      label: json['label'] as String,
      startTime: Duration(milliseconds: json['start_ms'] as int),
      endTime: Duration(milliseconds: json['end_ms'] as int),
      input: json['input'] as Map<String, dynamic>,
      output: json['output'] as Map<String, dynamic>,
      error: json['error'] as String?,
      cost: (json['cost'] as num).toDouble(),
    );
  }
}
