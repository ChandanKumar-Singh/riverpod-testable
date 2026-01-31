import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/trace/providers/trace_providers.dart';
import 'package:testable/ui/trace/widgets/trace_inspector.dart';
import 'package:testable/ui/trace/widgets/timeline_controls.dart';
import 'package:testable/ui/trace/widgets/trace_canvas.dart';

class AgentTraceScreen extends ConsumerStatefulWidget {
  const AgentTraceScreen({super.key});

  @override
  ConsumerState<AgentTraceScreen> createState() => _AgentTraceScreenState();
}

class _AgentTraceScreenState extends ConsumerState<AgentTraceScreen> {
  @override
  void initState() {
    super.initState();
    // Load simulation on init
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // UPDATED PROVIDER: selectedAgentRunProvider
      final run = await ref.read(selectedAgentRunProvider("latest").future);
      ref.read(tracePlaybackProvider.notifier).setDuration(run.totalDuration);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      appBar: AppBar(
        title: const Text("TRACE TOPOLOGY: #RUN-8821"),
        backgroundColor: context.appColors.bgSecondary,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: context.appColors.accentSuccess.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: context.appColors.accentSuccess),
            ),
            child: Text(
              "SUCCESS",
              style: TextStyle(
                color: context.appColors.accentSuccess,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                const Expanded(flex: 3, child: ClipRect(child: TraceCanvas())),
                Container(width: 1, color: context.appColors.bgTertiary),
                const Expanded(
                  flex: 1,
                  child: TraceInspector(), // Renamed Widget
                ),
              ],
            ),
          ),
          const TimelineControls(),
        ],
      ),
    );
  }
}
