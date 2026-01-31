import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/guardrails/providers/guardrail_providers.dart';
import 'package:testable/ui/guardrails/widgets/guardrail_widgets.dart';
import 'package:testable/ui/guardrails/widgets/simulation_widgets.dart';

class SystemGuardrailsScreen extends ConsumerWidget {
  const SystemGuardrailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeCategory = ref.watch(activeGuardrailCategoryProvider);
    final policy = ref.watch(guardrailPolicyProvider);
    final categoryRules = policy
        .where((r) => r.category == activeCategory)
        .toList();
    final isHaltActive = ref.watch(emergencyHaltProvider);

    return Scaffold(
      backgroundColor: context.appColors.bgPrimary,
      body: Column(
        children: [
          // Header
          _buildHeader(context, ref, isHaltActive),

          // Emergency Banner
          const EmergencyHaltBanner(),

          Expanded(
            child: Row(
              children: [
                // sidebar nav
                const GuardrailCategoryNav(),

                // Rules Grid
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${activeCategory.name.toUpperCase()} POLICIES",
                          style: TextStyle(
                            color: context.appColors.textTertiary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 24,
                                  mainAxisSpacing: 24,
                                  childAspectRatio: 1.8,
                                ),
                            itemCount: categoryRules.length,
                            itemBuilder: (context, index) {
                              return GuardrailRuleCard(
                                rule: categoryRules[index],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Sandbox Panel
                const Expanded(flex: 2, child: SimulationSandboxPanel()),
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
        color: context.appColors.bgSecondary,
        border: Border(bottom: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_outlined, color: context.appColors.accentPrimary),
          const SizedBox(width: 12),
          Text(
            "SYSTEM GUARDRAILS",
            style: TextStyle(
              color: context.appColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              letterSpacing: 1.0,
            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
