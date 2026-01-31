import 'dart:math';
import 'package:testable/features/ai_control/trace/trace_models.dart';

class TraceSimulationService {
  final _random = Random();

  AgentTrace generateMockTrace() {
    final startTime = DateTime.now().subtract(const Duration(seconds: 10));

    final nodes = [
      TraceNode(
        id: 'user_1',
        label: 'User Request',
        type: TraceNodeType.user,
        detail: 'What are my top 5 customers by revenue?',
        timestamp: startTime,
        latency: Duration.zero,
      ),
      TraceNode(
        id: 'router_1',
        label: 'LLM Router',
        type: TraceNodeType.router,
        detail: 'Model Selection: GPT-4o',
        timestamp: startTime.add(const Duration(milliseconds: 150)),
        latency: const Duration(milliseconds: 150),
      ),
      TraceNode(
        id: 'agent_1',
        label: 'Analytics Agent',
        type: TraceNodeType.agent,
        detail: 'Planning retrieval steps...',
        timestamp: startTime.add(const Duration(milliseconds: 400)),
        latency: const Duration(milliseconds: 250),
      ),
      TraceNode(
        id: 'tool_1',
        label: 'SQL Generator',
        type: TraceNodeType.tool,
        detail: 'Generating query for database...',
        timestamp: startTime.add(const Duration(seconds: 1)),
        latency: const Duration(milliseconds: 600),
      ),
      TraceNode(
        id: 'db_1',
        label: 'Snowflake DB',
        type: TraceNodeType.knowledgeBase,
        detail: 'Query executed successfully.',
        timestamp: startTime.add(const Duration(seconds: 2)),
        latency: const Duration(seconds: 1),
      ),
      TraceNode(
        id: 'model_1',
        label: 'Synthesizer (GPT-4o)',
        type: TraceNodeType.model,
        detail: 'Formatting results...',
        timestamp: startTime.add(const Duration(seconds: 3, milliseconds: 500)),
        latency: const Duration(milliseconds: 1500),
      ),
    ];

    final edges = [
      const TraceEdge(fromId: 'user_1', toId: 'router_1'),
      const TraceEdge(fromId: 'router_1', toId: 'agent_1'),
      const TraceEdge(fromId: 'agent_1', toId: 'tool_1'),
      const TraceEdge(fromId: 'tool_1', toId: 'db_1'),
      const TraceEdge(fromId: 'db_1', toId: 'model_1'),
    ];

    return AgentTrace(
      id: 'trace_${_random.nextInt(10000)}',
      nodes: nodes,
      edges: edges,
    );
  }
}
