import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/guardrails/models/guardrail_models.dart';
import 'package:testable/ui/guardrails/providers/guardrail_providers.dart';

class RuleCard extends ConsumerWidget {
  final GuardrailRule rule;
  const RuleCard({super.key, required this.rule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rule.isActive
              ? context.appColors.bgTertiary
              : context.appColors.bgTertiary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.name.toUpperCase(),
                    style: TextStyle(
                      color: rule.isActive
                          ? context.appColors.textPrimary
                          : context.appColors.textTertiary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    rule.description,
                    style: TextStyle(
                      color: context.appColors.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Switch(
                value: rule.isActive,
                activeColor: context.appColors.accentSuccess,
                onChanged: (val) => ref
                    .read(guardrailPolicyProvider.notifier)
                    .toggleRule(rule.id),
              ),
            ],
          ),
          if (rule.isActive) ...[
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "THRESHOLD",
                            style: TextStyle(
                              color: context.appColors.textTertiary,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${rule.threshold}${rule.unit}",
                            style: TextStyle(
                              color: context.appColors.accentPrimary,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RobotoMono',
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 6,
                          ),
                          overlayShape: const RoundSliderOverlayShape(
                            overlayRadius: 14,
                          ),
                        ),
                        child: Slider(
                          value: rule.threshold,
                          min: 0,
                          max: rule.id.contains('rate') ? 500000 : 100,
                          activeColor: context.appColors.accentPrimary,
                          inactiveColor: context.appColors.bgTertiary,
                          onChanged: (val) => ref
                              .read(guardrailPolicyProvider.notifier)
                              .updateThreshold(rule.id, val),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 48),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "SEVERITY",
                      style: TextStyle(
                        color: context.appColors.textTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _SeverityPicker(
                      current: rule.severity,
                      onChanged: (s) => ref
                          .read(guardrailPolicyProvider.notifier)
                          .updateSeverity(rule.id, s),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SeverityPicker extends StatelessWidget {
  final RuleSeverity current;
  final ValueChanged<RuleSeverity> onChanged;

  const _SeverityPicker({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: RuleSeverity.values.map((s) {
        final isSelected = s == current;
        final color = _getColor(s, context);
        return GestureDetector(
          onTap: () => onChanged(s),
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected
                  ? color.withValues(alpha: 0.15)
                  : Colors.transparent,
              border: Border.all(
                color: isSelected ? color : context.appColors.bgTertiary,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              s.name.toUpperCase(),
              style: TextStyle(
                color: isSelected ? color : context.appColors.textTertiary,
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Color _getColor(RuleSeverity s, BuildContext context) {
    switch (s) {
      case RuleSeverity.info:
        return context.appColors.accentSecondary;
      case RuleSeverity.warning:
        return context.appColors.accentWarning;
      case RuleSeverity.critical:
        return context.appColors.accentCritical;
    }
  }
}
