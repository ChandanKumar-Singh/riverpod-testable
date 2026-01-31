import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:graphview/GraphView.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/trace/models/agent_run.dart';
import 'package:testable/ui/trace/models/trace_node.dart';
import 'package:testable/ui/trace/providers/trace_providers.dart';
import 'package:testable/ui/trace/widgets/trace_node_widget.dart';

class TraceCanvas extends ConsumerStatefulWidget {
  const TraceCanvas({super.key});

  @override
  ConsumerState<TraceCanvas> createState() => _TraceCanvasState();
}

class _TraceCanvasState extends ConsumerState<TraceCanvas> {
  final Graph _graph = Graph()..isTree = true;
  late BuchheimWalkerConfiguration _builder;

  @override
  void initState() {
    super.initState();
    _builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (50)
      ..levelSeparation = (80)
      ..subtreeSeparation = (50)
      ..orientation = (1); // 1 = Top-Down
  }

  @override
  Widget build(BuildContext context) {
    // UPDATED PROVIDER: selectedAgentRunProvider
    final runAsync = ref.watch(selectedAgentRunProvider("latest"));
    // UPDATED PROVIDER: selectedTraceNodeProvider
    final selectedId = ref.watch(selectedTraceNodeProvider);

    return runAsync.when(
      data: (run) {
        // Build Graph only if empty (or rebuild on new run)
        if (_graph.nodeCount() == 0) {
          _buildGraph(run);
        }

        return InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(100),
          minScale: 0.1,
          maxScale: 2.0,
          child: GraphView(
            graph: _graph,
            algorithm: BuchheimWalkerAlgorithm(
              _builder,
              TreeEdgeRenderer(_builder),
            ),
            paint: Paint()
              ..color = context.appColors.textTertiary.withValues(alpha: 0.3)
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke,
            builder: (Node node) {
              final TraceNode traceNode = node.key!.value as TraceNode;
              return TraceNodeWidget(
                node: traceNode,
                isSelected: traceNode.id == selectedId,
                onTap: () {
                  ref.read(selectedTraceNodeProvider.notifier).state =
                      traceNode.id;
                },
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text("Error: $e")),
    );
  }

  void _buildGraph(AgentRun run) {
    final Map<String, Node> graphNodes = {};

    // Create Nodes
    for (var node in run.nodes) {
      final gNode = Node.Id(node);
      graphNodes[node.id] = gNode;
      _graph.addNode(gNode);
    }

    // Create Edges
    for (var edge in run.edges) {
      final from = graphNodes[edge.fromNodeId];
      final to = graphNodes[edge.toNodeId];
      if (from != null && to != null) {
        _graph.addEdge(from, to);
      }
    }
  }
}
