import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/guardrails/models/guardrail_models.dart';
import 'package:testable/ui/guardrails/providers/guardrail_providers.dart';

class GuardrailsHeader extends ConsumerWidget {
  const GuardrailsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isHalt = ref.watch(emergencyHaltProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: isHalt
            ? context.appColors.accentCritical.withValues(alpha: 0.1)
            : context.appColors.bgSecondary,
        border: Border(
          bottom: BorderSide(
            color: isHalt
                ? context.appColors.accentCritical
                : context.appColors.bgTertiary,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                isHalt ? Icons.warning_rounded : Icons.gpp_good_rounded,
                color: isHalt
                    ? context.appColors.accentCritical
                    : context.appColors.accentSuccess,
                size: 28,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SYSTEM BOUNDARIES",
                    style: TextStyle(
                      color: context.appColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Text(
                    isHalt
                        ? "GLOBAL HALT PROTOCOL ACTIVE"
                        : "Fleet Governance Active",
                    style: TextStyle(
                      color: isHalt
                          ? context.appColors.accentCritical
                          : context.appColors.textTertiary,
                      fontSize: 12,
                      fontWeight: isHalt ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Emergency Halt Toggle
          _EmergencyToggle(isHalt: isHalt),
        ],
      ),
    );
  }
}

class _EmergencyToggle extends ConsumerWidget {
  final bool isHalt;
  const _EmergencyToggle({required this.isHalt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: isHalt
            ? context.appColors.accentCritical
            : context.appColors.bgTertiary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHalt ? Colors.white : context.appColors.bgTertiary,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => ref.read(emergencyHaltProvider.notifier).state = !isHalt,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.power_settings_new,
                  color: isHalt
                      ? Colors.white
                      : context.appColors.accentCritical,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  isHalt ? "REVOKE HALT" : "EMERGENCY HALT",
                  style: TextStyle(
                    color: isHalt
                        ? Colors.white
                        : context.appColors.accentCritical,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GuardrailCategoryNav extends ConsumerWidget {
  const GuardrailCategoryNav({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCategory = ref.watch(activeGuardrailCategoryProvider);

    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary,
        border: Border(right: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          _NavTile(
            label: "Safety",
            icon: Icons.security_rounded,
            category: GuardrailCategory.safety,
            isActive: activeCategory == GuardrailCategory.safety,
          ),
          _NavTile(
            label: "Budget",
            icon: Icons.payments_rounded,
            category: GuardrailCategory.budget,
            isActive: activeCategory == GuardrailCategory.budget,
          ),
          _NavTile(
            label: "Rate Limits",
            icon: Icons.speed_rounded,
            category: GuardrailCategory.rateLimits,
            isActive: activeCategory == GuardrailCategory.rateLimits,
          ),
          _NavTile(
            label: "Behavioral",
            icon: Icons.bolt_rounded,
            category: GuardrailCategory.behavioral,
            isActive: activeCategory == GuardrailCategory.behavioral,
          ),
        ],
      ),
    );
  }
}

class _NavTile extends ConsumerWidget {
  final String label;
  final IconData icon;
  final GuardrailCategory category;
  final bool isActive;

  const _NavTile({
    required this.label,
    required this.icon,
    required this.category,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = isActive
        ? context.appColors.accentPrimary
        : context.appColors.textTertiary;

    return ListTile(
      leading: Icon(icon, color: color, size: 20),
      title: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: isActive
              ? context.appColors.textPrimary
              : context.appColors.textTertiary,
          fontSize: 11,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          letterSpacing: 1.2,
        ),
      ),
      onTap: () =>
          ref.read(activeGuardrailCategoryProvider.notifier).state = category,
      tileColor: isActive
          ? context.appColors.bgTertiary.withValues(alpha: 0.5)
          : null,
    );
  }
}
