import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:testable/ui/trace/models/agent_run.dart';
import 'package:testable/ui/trace/models/trace_node.dart';

class TraceSimulationService {
  // Hardcoded scenario for "Live vs Replay" demo
  Future<AgentRun> loadRun(String runId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final startTime = DateTime.now().subtract(const Duration(minutes: 5));

    final nodes = [
      // 0. User Input
      TraceNode(
        id: 'n0',
        type: TraceNodeType.system_msg,
        label: 'User Request',
        startTime: const Duration(milliseconds: 0),
        endTime: const Duration(milliseconds: 100),
        input: {
          'prompt':
              'Research "Quantum Battery" advancements in 2024 and write a summary.',
        },
        output: {'status': 'received'},
        cost: 0.0,
      ),
      // 1. Planning (LLM)
      TraceNode(
        id: 'n1',
        type: TraceNodeType.thought,
        label: 'Planner: Decomposition',
        startTime: const Duration(milliseconds: 200),
        endTime: const Duration(milliseconds: 1500),
        input: {'context': 'User wants quantum battery research summary.'},
        output: {
          'plan': [
            'Google Search: Quantum Battery 2024',
            'Read top 3 articles',
            'Summarize findings',
          ],
        },
        cost: 0.002,
      ),
      // 2. Tool Call (Search)
      TraceNode(
        id: 'n2',
        type: TraceNodeType.tool_call,
        label: 'Tool: Google Search',
        startTime: const Duration(milliseconds: 1600),
        endTime: const Duration(milliseconds: 2800),
        input: {'query': 'Quantum Battery breakthroughs 2024'},
        output: {
          'results_count': 3,
          'top_titles': ['MIT Spin-wave battery', 'IBM Quantum charging'],
        },
        cost: 0.0,
      ),
      // 3. LLM Synthesis
      TraceNode(
        id: 'n3',
        type: TraceNodeType.llm_call,
        label: 'Agent: Synthesis',
        startTime: const Duration(milliseconds: 3000),
        endTime: const Duration(milliseconds: 4500),
        input: {'search_results': '...raw html content...'},
        output: {'draft': 'In 2024, significant strides were made...'},
        cost: 0.015,
      ),
      // 4. Final Output
      TraceNode(
        id: 'n4',
        type: TraceNodeType.system_msg,
        label: 'Final Response',
        startTime: const Duration(milliseconds: 4600),
        endTime: const Duration(milliseconds: 4800),
        input: {'draft': 'In 2024...'},
        output: {'display': 'Markdown rendered summary'},
        cost: 0.0,
      ),
    ];

    final edges = [
      const TraceEdge(fromNodeId: 'n0', toNodeId: 'n1'),
      const TraceEdge(fromNodeId: 'n1', toNodeId: 'n2'),
      const TraceEdge(fromNodeId: 'n2', toNodeId: 'n3'),
      const TraceEdge(fromNodeId: 'n3', toNodeId: 'n4'),
    ];

    return AgentRun(
      id: runId,
      startTime: startTime,
      totalCost: 0.017,
      status: RunStatus.success,
      nodes: nodes,
      edges: edges,
    );
  }
}
