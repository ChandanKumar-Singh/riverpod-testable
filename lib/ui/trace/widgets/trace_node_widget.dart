import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/trace/models/trace_node.dart';
import 'package:testable/ui/trace/providers/trace_providers.dart';

class TraceNodeWidget extends ConsumerWidget {
  final TraceNode node;
  final bool isSelected;
  final VoidCallback onTap;

  const TraceNodeWidget({
    super.key,
    required this.node,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.watch(tracePlaybackProvider);
    final status = node.getStatus(playback.currentTimestamp);

    // Future nodes are dim
    if (status == TraceNodeStatus.pending) {
      return Opacity(
        opacity: 0.3,
        child: _buildNodeBox(context, status: status),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: _buildNodeBox(context, status: status, isSelected: isSelected),
    );
  }

  Widget _buildNodeBox(
    BuildContext context, {
    required TraceNodeStatus status,
    bool isSelected = false,
  }) {
    Color baseColor;
    IconData icon;

    switch (node.type) {
      case TraceNodeType.thought:
        baseColor = context.appColors.accentPrimary; // Purple
        icon = Icons.psychology;
        break;
      case TraceNodeType.tool_call:
        baseColor = context.appColors.accentSecondary; // Cyan
        icon = Icons.handyman;
        break;
      case TraceNodeType.llm_call:
        baseColor = context.appColors.accentWarning; // Yellow
        icon = Icons.smart_toy;
        break;
      case TraceNodeType.system_msg:
        baseColor = context.appColors.textTertiary; // Grey
        icon = Icons.info;
        break;
    }

    final isActive = status == TraceNodeStatus.active;
    final isFailed = status == TraceNodeStatus.failed;

    if (isFailed) {
      baseColor = context.appColors.accentCritical;
      icon = Icons.error_outline;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.appColors.bgPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? Colors.white
              : (isActive ? baseColor : baseColor.withOpacity(0.5)),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: baseColor.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: baseColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  node.type.name.toUpperCase(),
                  style: TextStyle(
                    color: baseColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (status != TraceNodeStatus.pending)
                _StatusIndicator(status: status, color: baseColor),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            node.label,
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (isActive) ...[
            const SizedBox(height: 8),
            const LinearProgressIndicator(minHeight: 2),
          ],
        ],
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final TraceNodeStatus status;
  final Color color;
  const _StatusIndicator({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    // Only show icon for Completed/Failed/Active is handled by glow
    if (status == TraceNodeStatus.completed) {
      return const Icon(Icons.check_circle, size: 12, color: Colors.green);
    }
    return const SizedBox();
  }
}
