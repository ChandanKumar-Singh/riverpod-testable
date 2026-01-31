import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/guardrails/models/guardrail_models.dart';
import 'package:testable/ui/guardrails/providers/guardrail_providers.dart';

class EmergencyHaltBanner extends ConsumerWidget {
  const EmergencyHaltBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHaltActive = ref.watch(emergencyHaltProvider);
    if (!isHaltActive) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: context.appColors.accentCritical,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
          SizedBox(width: 12),
          Text(
            "EMERGENCY HALT ACTIVE: ALL INFERENCE REQUESTS ARE BLOCKED",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class SimulationSandboxPanel extends ConsumerStatefulWidget {
  const SimulationSandboxPanel({super.key});

  @override
  ConsumerState<SimulationSandboxPanel> createState() =>
      _SimulationSandboxPanelState();
}

class _SimulationSandboxPanelState
    extends ConsumerState<SimulationSandboxPanel> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultAsync = ref.watch(sandboxSimulationProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(left: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "SIMULATION SANDBOX",
            style: TextStyle(
              color: context.appColors.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            maxLines: 4,
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontSize: 13,
            ),
            decoration: InputDecoration(
              hintText: "Enter test prompt here...",
              hintStyle: TextStyle(color: context.appColors.textTertiary),
              filled: true,
              fillColor: context.appColors.bgPrimary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.appColors.bgTertiary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: context.appColors.bgTertiary),
              ),
            ),
            onChanged: (val) =>
                ref.read(sandboxSimulationProvider.notifier).runSimulation(val),
          ),
          const SizedBox(height: 32),
          Text(
            "EVALUATION RESULT",
            style: TextStyle(
              color: context.appColors.textTertiary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: resultAsync.when(
              data: (result) {
                if (result == null) {
                  return Center(
                    child: Text(
                      "Waiting for input...",
                      style: TextStyle(color: context.appColors.textTertiary),
                    ),
                  );
                }
                return _ResultDisplay(result: result);
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, __) => Text("Error: $err"),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _controller.clear();
                ref.read(sandboxSimulationProvider.notifier).runSimulation("");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.bgTertiary,
                foregroundColor: context.appColors.textPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text("CLEAR BOX"),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultDisplay extends StatelessWidget {
  final SimulationResult result;

  const _ResultDisplay({required this.result});

  @override
  Widget build(BuildContext context) {
    final isBlocked = !result.isAllowed;
    final color = isBlocked
        ? context.appColors.accentCritical
        : context.appColors.accentSuccess;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isBlocked ? Icons.block_flipped : Icons.check_circle_outline,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                isBlocked ? "BLOCKED" : "ALLOWED",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (isBlocked) ...[
            const SizedBox(height: 12),
            Text(
              "TRIGGERED BY: ${result.blockedByRuleId}",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'RobotoMono',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              result.message ?? "",
              style: TextStyle(
                color: context.appColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "RISK SCORE",
                style: TextStyle(
                  color: context.appColors.textTertiary,
                  fontSize: 10,
                ),
              ),
              Text(
                "${(result.score * 100).toInt()}%",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
