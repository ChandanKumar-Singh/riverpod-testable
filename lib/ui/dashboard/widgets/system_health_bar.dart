import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/dashboard/providers/dashboard_providers.dart';

class SystemHealthBar extends ConsumerWidget {
  const SystemHealthBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final healthAsync = ref.watch(systemStatusStreamProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: healthAsync.when(
        data: (health) => Row(
          children: [
            Expanded(
              child: _ResourceBar(
                label: "CPU OPTIMIZATION",
                value: health.cpuUsage,
                color: context.appColors.accentPrimary,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _ResourceBar(
                label: "MEMORY ALLOCATION",
                value: health.memoryUsage,
                color: context.appColors.accentSecondary,
              ),
            ),
            const SizedBox(width: 24),
            Text(
              "UPTIME: ${_formatDuration(health.uptimeDuration)}",
              style: TextStyle(
                color: context.appColors.textTertiary,
                fontFamily: "Courier New", // Monospaced for tech feel
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        loading: () => const SizedBox(),
        error: (_, __) => const SizedBox(),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(d.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(d.inSeconds.remainder(60));
    return "${twoDigits(d.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class _ResourceBar extends StatelessWidget {
  final String label;
  final double value;
  final Color color;

  const _ResourceBar({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: context.appColors.textTertiary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "${(value * 100).toInt()}%",
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: LinearProgressIndicator(
            value: value,
            backgroundColor: context.appColors.bgTertiary,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
