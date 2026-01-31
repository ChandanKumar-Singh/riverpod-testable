import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/guardrails/models/guardrail_models.dart';
import 'package:testable/ui/guardrails/providers/guardrail_providers.dart';

class GuardrailCategoryNav extends ConsumerWidget {
  const GuardrailCategoryNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCategory = ref.watch(activeGuardrailCategoryProvider);

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(right: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: GuardrailCategory.values.map((category) {
          final isSelected = category == activeCategory;
          return ListTile(
            leading: Icon(
              _getCategoryIcon(category),
              color: isSelected
                  ? context.appColors.accentPrimary
                  : context.appColors.textTertiary,
              size: 20,
            ),
            title: Text(
              category.name.toUpperCase(),
              style: TextStyle(
                color: isSelected
                    ? context.appColors.textPrimary
                    : context.appColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
                letterSpacing: 1.0,
              ),
            ),
            selected: isSelected,
            onTap: () =>
                ref.read(activeGuardrailCategoryProvider.notifier).state =
                    category,
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(GuardrailCategory category) {
    switch (category) {
      case GuardrailCategory.safety:
        return Icons.health_and_safety_outlined;
      case GuardrailCategory.privacy:
        return Icons.privacy_tip_outlined;
      case GuardrailCategory.financial:
        return Icons.account_balance_wallet_outlined;
      case GuardrailCategory.operational:
        return Icons.settings_input_component_outlined;
      case GuardrailCategory.budget:
        return Icons.account_balance_outlined;
      case GuardrailCategory.rateLimits:
        return Icons.speed_outlined;
      case GuardrailCategory.behavioral:
        return Icons.psychology_outlined;
    }
  }
}

class GuardrailRuleCard extends ConsumerWidget {
  final GuardrailRule rule;

  const GuardrailRuleCard({super.key, required this.rule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.bgPrimary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: rule.isActive
              ? context.appColors.accentPrimary.withOpacity(0.3)
              : context.appColors.bgTertiary,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      rule.name,
                      style: TextStyle(
                        color: context.appColors.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rule.description,
                      style: TextStyle(
                        color: context.appColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: rule.isActive,
                activeColor: context.appColors.accentPrimary,
                onChanged: (_) => ref
                    .read(guardrailPolicyProvider.notifier)
                    .toggleRule(rule.id),
              ),
            ],
          ),
          if (rule.isActive) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "THRESHOLD",
                  style: TextStyle(
                    color: context.appColors.textTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  '${rule.threshold.toStringAsFixed(2)}${rule.unit}',
                  style: TextStyle(
                    color: context.appColors.accentPrimary,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoMono',
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              ),
              child: Slider(
                value: rule.threshold,
                activeColor: context.appColors.accentPrimary,
                inactiveColor: context.appColors.bgTertiary,
                onChanged: (val) => ref
                    .read(guardrailPolicyProvider.notifier)
                    .updateThreshold(rule.id, val),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
