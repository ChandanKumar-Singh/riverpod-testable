import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:intl/intl.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/guardrails/models/guardrail_models.dart';
import 'package:testable/ui/guardrails/providers/guardrail_providers.dart';

class SimulationSandboxPanel extends ConsumerWidget {
  const SimulationSandboxPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(sandboxSimulationProvider);

    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(left: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SandboxHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SectionTitle("TEST SCENARIO"),
                const SizedBox(height: 12),
                _MockPayloadView(),
                const SizedBox(height: 32),
                result.when(
                  data: (data) => data != null
                      ? _ResultView(result: data)
                      : const SizedBox.shrink(),
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (e, s) => Text(
                    "Error: $e",
                    style: TextStyle(color: context.appColors.accentCritical),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: ElevatedButton(
              onPressed: () => ref
                  .read(sandboxSimulationProvider.notifier)
                  .runSimulation("MOCK_PAYLOAD_TEST"),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.appColors.accentPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text("RUN SIMULATION TEST"),
            ),
          ),
        ],
      ),
    );
  }
}

class _SandboxHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.science_rounded,
            color: context.appColors.accentSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          const Text(
            "POLICY SANDBOX",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _MockPayloadView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.bgPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const DefaultTextStyle(
        style: TextStyle(fontFamily: 'RobotoMono'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _JsonLine(jsonKey: "request_id", value: "\"req_3829\""),
            _JsonLine(jsonKey: "agent_role", value: "\"customer_support\""),
            _JsonLine(jsonKey: "estimated_tokens", value: "450"),
            _JsonLine(jsonKey: "safety_scan", value: "true"),
          ],
        ),
      ),
    );
  }
}

class _JsonLine extends StatelessWidget {
  final String jsonKey;
  final String value;
  const _JsonLine({required this.jsonKey, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            "\"$jsonKey\": ",
            style: TextStyle(
              color: context.appColors.textTertiary,
              fontSize: 11,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: context.appColors.accentSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final SimulationResult result;
  const _ResultView({required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.isAllowed
        ? context.appColors.accentSuccess
        : context.appColors.accentCritical;
    final icon = result.isAllowed
        ? Icons.check_circle_outline
        : Icons.block_flipped;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle("SIMULATION OUTCOME"),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 16),
              Text(
                result.isAllowed ? "REQUEST ALLOWED" : "REQUEST BLOCKED",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                result.message ?? "No message provided",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: context.appColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                "Evaluated at ${DateFormat('HH:mm:ss').format(result.timestamp)}",
                style: TextStyle(
                  color: context.appColors.textTertiary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: context.appColors.textTertiary,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.5,
      ),
    );
  }
}
