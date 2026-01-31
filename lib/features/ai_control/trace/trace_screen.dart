import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:graphview/GraphView.dart';
import 'package:intl/intl.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/shared/ai_control_theme.dart';
import 'package:testable/features/ai_control/shared/ai_control_widgets.dart';
import 'package:testable/features/ai_control/trace/trace_models.dart';
import 'package:testable/features/ai_control/trace/trace_providers.dart';

class TraceScreen extends ConsumerStatefulWidget {
  const TraceScreen({super.key});

  @override
  ConsumerState<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends ConsumerState<TraceScreen> {
  final Graph _graph = Graph()..isTree = true;
  late BuchheimWalkerConfiguration _builder;

  @override
  void initState() {
    super.initState();
    _builder = BuchheimWalkerConfiguration()
      ..siblingSeparation = (100)
      ..levelSeparation = (100)
      ..subtreeSeparation = (100)
      ..orientation = BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM;
  }

  void _buildGraph(AgentTrace trace) {
    _graph.nodes.clear();
    _graph.edges.clear();

    final nodeMap = <String, Node>{};

    for (final node in trace.nodes) {
      final graphNode = Node.Id(node);
      nodeMap[node.id] = graphNode;
      _graph.addNode(graphNode);
    }

    for (final edge in trace.edges) {
      final from = nodeMap[edge.fromId];
      final to = nodeMap[edge.toId];
      if (from != null && to != null) {
        _graph.addEdge(from, to);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final trace = ref.watch(activeTraceProvider);

    if (trace == null) {
      return const Center(child: CircularProgressIndicator());
    }

    _buildGraph(trace);

    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: Row(
        children: [
          Expanded(flex: 3, child: _buildCanvas(context, trace)),
          _DetailsPanel(),
        ],
      ),
    );
  }

  Widget _buildCanvas(BuildContext context, AgentTrace trace) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: InteractiveViewer(
            constrained: false,
            boundaryMargin: const EdgeInsets.all(500),
            minScale: 0.1,
            maxScale: 2.0,
            child: GraphView(
              graph: _graph,
              algorithm: BuchheimWalkerAlgorithm(
                _builder,
                TreeEdgeRenderer(_builder),
              ),
              paint: Paint()
                ..color = context.appColors.accentPrimary.withValues(alpha: 0.2)
                ..strokeWidth = 2
                ..style = PaintingStyle.stroke,
              builder: (Node node) {
                final traceNode = node.key!.value as TraceNode;
                return _NodeWidget(node: traceNode);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_tree_outlined,
            color: context.appColors.accentPrimary,
          ),
          const SizedBox(width: 12),
          Text(
            "AGENT TRACE TOPOLOGY",
            style: AIControlTheme.headingStyle(context).copyWith(fontSize: 18),
          ),
          const Spacer(),
          CyberButton(
            label: "LIVE REPLAY",
            onPressed: () {},
            icon: Icons.play_circle_outline,
          ),
        ],
      ),
    );
  }
}

class _NodeWidget extends ConsumerWidget {
  final TraceNode node;
  const _NodeWidget({required this.node});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(selectedNodeIdProvider) == node.id;
    final color = _getNodeColor(context, node.type);

    return GestureDetector(
      onTap: () => ref.read(selectedNodeIdProvider.notifier).state = node.id,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.15)
              : context.appColors.bgSecondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : context.appColors.bgTertiary,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10)]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_getNodeIcon(node.type), color: color, size: 16),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  node.label,
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${node.latency.inMilliseconds}ms",
                  style: TextStyle(
                    color: context.appColors.textTertiary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getNodeColor(BuildContext context, TraceNodeType type) {
    switch (type) {
      case TraceNodeType.user:
        return Colors.white;
      case TraceNodeType.router:
        return context.appColors.accentSecondary;
      case TraceNodeType.agent:
        return context.appColors.accentPrimary;
      case TraceNodeType.tool:
        return context.appColors.accentWarning;
      case TraceNodeType.knowledgeBase:
        return context.appColors.accentSuccess;
      case TraceNodeType.model:
        return context.appColors.accentPrimary;
    }
  }

  IconData _getNodeIcon(TraceNodeType type) {
    switch (type) {
      case TraceNodeType.user:
        return Icons.person_outline;
      case TraceNodeType.router:
        return Icons.alt_route_rounded;
      case TraceNodeType.agent:
        return Icons.smart_toy_outlined;
      case TraceNodeType.tool:
        return Icons.build_outlined;
      case TraceNodeType.knowledgeBase:
        return Icons.storage_outlined;
      case TraceNodeType.model:
        return Icons.psychology_outlined;
    }
  }
}

class _DetailsPanel extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedId = ref.watch(selectedNodeIdProvider);
    final AgentTrace? trace = ref.watch(activeTraceProvider);
    final TraceNode? node = (selectedId != null && trace != null)
        ? trace.nodes.firstWhere((n) => n.id == selectedId)
        : null;

    return Container(
      width: 320,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(left: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: node == null ? _EmptyDetails() : _NodeDetails(node: node),
    );
  }
}

class _EmptyDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            color: context.appColors.textTertiary,
            size: 32,
          ),
          const SizedBox(height: 16),
          Text(
            "SELECT A NODE TO VIEW DETAILS",
            textAlign: TextAlign.center,
            style: AIControlTheme.subHeadingStyle(context),
          ),
        ],
      ),
    );
  }
}

class _NodeDetails extends StatelessWidget {
  final TraceNode node;
  const _NodeDetails({required this.node});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusBadge(
            label: node.type.name,
            color: context.appColors.accentSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            node.label,
            style: AIControlTheme.headingStyle(context).copyWith(fontSize: 20),
          ),
          const SizedBox(height: 32),
          _DetailItem(
            label: "TIMESTAMP",
            value: DateFormat('HH:mm:ss.SSS').format(node.timestamp),
          ),
          _DetailItem(
            label: "LATENCY",
            value: "${node.latency.inMilliseconds} ms",
          ),
          const SizedBox(height: 32),
          Text(
            "PAYLOAD / CONTEXT",
            style: AIControlTheme.subHeadingStyle(context),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.appColors.bgPrimary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              node.detail ?? "No additional metadata available.",
              style: TextStyle(
                color: context.appColors.textSecondary,
                fontSize: 12,
                fontFamily: 'RobotoMono',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  const _DetailItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AIControlTheme.subHeadingStyle(context)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
