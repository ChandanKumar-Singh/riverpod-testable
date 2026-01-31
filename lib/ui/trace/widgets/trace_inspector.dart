import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/trace/models/trace_node.dart';
import 'package:testable/ui/trace/providers/trace_providers.dart';

class TraceInspector extends ConsumerWidget {
  const TraceInspector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // UPDATED PROVIDER: selectedTraceNodeProvider
    final selectedId = ref.watch(selectedTraceNodeProvider);
    // UPDATED PROVIDER: selectedAgentRunProvider
    final runAsync = ref.watch(selectedAgentRunProvider("latest"));

    if (selectedId == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        color: context.appColors.bgSecondary,
        child: Center(
          child: Text(
            "SELECT A NODE TO INSPECT",
            style: TextStyle(
              color: context.appColors.textTertiary,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return runAsync.when(
      data: (run) {
        final node = run.nodeMap[selectedId]!;
        return Container(
          width: 350,
          decoration: BoxDecoration(
            color: context.appColors.bgSecondary,
            border: Border(
              left: BorderSide(color: context.appColors.bgTertiary),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.type.name.toUpperCase(),
                      style: TextStyle(
                        color: context.appColors.accentSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      node.label,
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _Badge(
                          label: "${node.duration.inMilliseconds}ms",
                          color: context.appColors.accentWarning,
                        ),
                        const SizedBox(width: 8),
                        _Badge(
                          label: "\$${node.cost.toStringAsFixed(4)}",
                          color: context.appColors.accentSuccess,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              // Key-Value Details
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _SectionHeader("INPUT"),
                    _JsonView(data: node.input),
                    const SizedBox(height: 24),
                    _SectionHeader("OUTPUT"),
                    _JsonView(data: node.output),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const SizedBox(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: context.appColors.textTertiary,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.0,
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _JsonView extends StatelessWidget {
  final Map<String, dynamic> data;
  const _JsonView({required this.data});

  @override
  Widget build(BuildContext context) {
    const encoder = JsonEncoder.withIndent('  ');
    final formatted = encoder.convert(data);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.bgPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        formatted,
        style: TextStyle(
          color: context.appColors.textSecondary,
          fontFamily: 'RobotoMono',
          fontSize: 11,
        ),
      ),
    );
  }
}
