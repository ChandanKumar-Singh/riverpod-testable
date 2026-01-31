import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/features/ai_control/shared/ai_control_theme.dart';
import 'package:testable/features/ai_control/shared/ai_control_widgets.dart';
import 'package:testable/features/ai_control/shield/shield_models.dart';
import 'package:testable/features/ai_control/shield/shield_providers.dart';

class ShieldScreen extends ConsumerWidget {
  const ShieldScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rules = ref.watch(guardrailPolicyProvider);
    final isHaltActive = ref.watch(emergencyHaltProvider);

    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: Column(
        children: [
          _buildHeader(context, ref, isHaltActive),
          if (isHaltActive) _EmergencyBanner(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ACTIVE SECURITY POLICIES",
                          style: AIControlTheme.subHeadingStyle(context),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                  childAspectRatio: 2.2,
                                ),
                            itemCount: rules.length,
                            itemBuilder: (context, index) =>
                                _RuleCard(rule: rules[index]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const _SimulationSandboxPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isHaltActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: context.appColors.accentPrimary),
          const SizedBox(width: 12),
          Text(
            "SYSTEM GUARDRAILS",
            style: AIControlTheme.headingStyle(context).copyWith(fontSize: 18),
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: () =>
                ref.read(emergencyHaltProvider.notifier).state = !isHaltActive,
            icon: Icon(isHaltActive ? Icons.play_arrow : Icons.stop_circle),
            label: Text(isHaltActive ? "RESUME SYSTEMS" : "EMERGENCY HALT"),
            style: ElevatedButton.styleFrom(
              backgroundColor: isHaltActive
                  ? context.appColors.accentSuccess
                  : context.appColors.accentCritical,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: context.appColors.accentCritical,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: const Center(
        child: Text(
          "EMERGENCY HALT ACTIVE: ALL INFERENCE REQUESTS ARE BLOCKED",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 11,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}

class _RuleCard extends ConsumerWidget {
  final GuardrailRule rule;
  const _RuleCard({required this.rule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StatusBadge(
                label: rule.category.name,
                color: context.appColors.accentSecondary,
              ),
              Switch(
                value: rule.isActive,
                onChanged: (_) => ref
                    .read(guardrailPolicyProvider.notifier)
                    .toggleRule(rule.id),
                activeColor: context.appColors.accentSuccess,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            rule.name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rule.description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: context.appColors.textTertiary,
              fontSize: 11,
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "THRESHOLD: ${rule.threshold}${rule.unit}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontFamily: 'RobotoMono',
                  fontWeight: FontWeight.bold,
                ),
              ),
              StatusBadge(
                label: rule.severity.name,
                color: _getSeverityColor(context, rule.severity),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(BuildContext context, RuleSeverity severity) {
    switch (severity) {
      case RuleSeverity.low:
        return context.appColors.accentSuccess;
      case RuleSeverity.medium:
        return context.appColors.accentWarning;
      case RuleSeverity.high:
        return context.appColors.accentCritical;
      case RuleSeverity.critical:
        return Colors.redAccent;
    }
  }
}

class _SimulationSandboxPanel extends ConsumerStatefulWidget {
  const _SimulationSandboxPanel();

  @override
  ConsumerState<_SimulationSandboxPanel> createState() =>
      _SimulationSandboxPanelState();
}

class _SimulationSandboxPanelState
    extends ConsumerState<_SimulationSandboxPanel> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final resultAsync = ref.watch(sandboxSimulationProvider);

    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(left: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "POLICY SANDBOX",
              style: AIControlTheme.subHeadingStyle(context),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _controller,
              maxLines: 5,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: 'RobotoMono',
              ),
              decoration: InputDecoration(
                hintText: "Enter test payload or prompt...",
                hintStyle: TextStyle(color: context.appColors.textTertiary),
                filled: true,
                fillColor: context.appColors.bgPrimary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            CyberButton(
              label: "RUN SAFETY SCAN",
              onPressed: () => ref
                  .read(sandboxSimulationProvider.notifier)
                  .runSimulation(_controller.text),
              icon: Icons.security_outlined,
            ),
            const SizedBox(height: 48),
            Text("SCAN RESULT", style: AIControlTheme.subHeadingStyle(context)),
            const SizedBox(height: 16),
            Expanded(
              child: resultAsync.when(
                data: (res) => res == null
                    ? _EmptySandbox()
                    : _ScanResultDetail(result: res),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySandbox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Input text and scan to test policies.",
        style: TextStyle(color: context.appColors.textTertiary, fontSize: 12),
      ),
    );
  }
}

class _ScanResultDetail extends StatelessWidget {
  final SimulationResult result;
  const _ScanResultDetail({required this.result});

  @override
  Widget build(BuildContext context) {
    final color = result.isAllowed
        ? context.appColors.accentSuccess
        : context.appColors.accentCritical;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isAllowed ? Icons.check_circle : Icons.block_flipped,
                color: color,
              ),
              const SizedBox(width: 12),
              Text(
                result.isAllowed ? "PASSED" : "BLOCKED",
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            result.message,
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
          const Spacer(),
          Text("RISK SCORE", style: AIControlTheme.subHeadingStyle(context)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: result.riskScore,
            backgroundColor: context.appColors.bgTertiary,
            color: color,
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            "${(result.riskScore * 100).toInt()}% RISK",
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 14,
              fontFamily: 'RobotoMono',
            ),
          ),
        ],
      ),
    );
  }
}
