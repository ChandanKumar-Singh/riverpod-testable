import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/fleet/models/fleet_environment.dart';
import 'package:testable/ui/fleet/providers/fleet_providers.dart';

class DeploymentOverlay extends ConsumerStatefulWidget {
  final FleetEnvironment env;
  final VoidCallback onClose;

  const DeploymentOverlay({
    super.key,
    required this.env,
    required this.onClose,
  });

  @override
  ConsumerState<DeploymentOverlay> createState() => _DeploymentOverlayState();
}

class _DeploymentOverlayState extends ConsumerState<DeploymentOverlay> {
  String selectedVersion = "v1.1.0-rc1";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      color: context.appColors.bgSecondary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "DEPLOYMENT: ${widget.env.name.toUpperCase()}",
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: context.appColors.textTertiary,
                  ),
                  onPressed: widget.onClose,
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Form
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SectionTitle("TARGET VERSION"),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.appColors.bgPrimary,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.appColors.accentPrimary),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.commit,
                        color: context.appColors.accentPrimary,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "v1.1.0-rc1",
                            style: TextStyle(
                              color: context.appColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Commit: e5f6g7h • 2h ago",
                            style: TextStyle(
                              color: context.appColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _SectionTitle("ROLLOUT STRATEGY"),
                const SizedBox(height: 12),
                _StrategyOption(
                  title: "Rolling Update",
                  description: "Update nodes in batches. Zero downtime.",
                  isSelected: true,
                  context: context,
                ),
                const SizedBox(height: 8),
                _StrategyOption(
                  title: "Recreate",
                  description: "Terminate all nodes then create new ones.",
                  isSelected: false,
                  context: context,
                ),

                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: context.appColors.accentWarning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.appColors.accentWarning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber,
                        color: context.appColors.accentWarning,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "This will deploy version v1.1.0-rc1. Ensure QA sign-off is complete.",
                          style: TextStyle(
                            color: context.appColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: context.appColors.bgTertiary),
              ),
            ),
            child: Column(
              children: [
                // Emergency Toggle Placeholder (Logic only implied for demo)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "EMERGENCY PAUSE ENABLED",
                      style: TextStyle(
                        color: context.appColors.textTertiary,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Switch(
                      value: false,
                      onChanged: (val) {},
                      activeColor: context.appColors.accentCritical,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref
                          .read(deploymentControllerProvider.notifier)
                          .startDeployment(widget.env.id, selectedVersion);
                      widget.onClose();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.appColors.accentPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("START DEPLOYMENT"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
      ),
    );
  }
}

class _StrategyOption extends StatelessWidget {
  final String title;
  final String description;
  final bool isSelected;
  final BuildContext context;

  const _StrategyOption({
    required this.title,
    required this.description,
    required this.isSelected,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.appColors.bgPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? context.appColors.accentSecondary
              : context.appColors.bgTertiary,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: isSelected
                ? context.appColors.accentSecondary
                : context.appColors.textTertiary,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: context.appColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: context.appColors.textTertiary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
