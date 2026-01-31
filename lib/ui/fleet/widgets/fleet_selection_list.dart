import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/fleet/models/agent_fleet.dart';
import 'package:testable/ui/fleet/providers/fleet_providers.dart';

class FleetSelectionList extends ConsumerWidget {
  const FleetSelectionList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fleetsAsync = ref.watch(fleetListStreamProvider);
    final selectedId = ref.watch(
      selectedFleetIdProvider,
    ); // Listening strictly to ID for selection UI

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: context.appColors.bgSecondary.withValues(alpha: 0.5),
        border: Border(right: BorderSide(color: context.appColors.bgTertiary)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'AGENT FLEETS',
              style: TextStyle(
                color: context.appColors.textTertiary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          Expanded(
            child: fleetsAsync.when(
              data: (List<AgentFleet> fleets) => ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: fleets.length,
                itemBuilder: (context, index) {
                  final AgentFleet fleet = fleets[index];
                  final isSelected = fleet.id == selectedId;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: InkWell(
                      onTap: () {
                        ref.read(selectedFleetIdProvider.notifier).state =
                            fleet.id;
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? context.appColors.accentPrimary.withValues(
                                  alpha: 0.1,
                                )
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? context.appColors.accentPrimary
                                : Colors.transparent,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.layers,
                                  size: 16,
                                  color: isSelected
                                      ? context.appColors.accentPrimary
                                      : context.appColors.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    fleet.name,
                                    style: TextStyle(
                                      color: isSelected
                                          ? context.appColors.accentPrimary
                                          : context.appColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              fleet.description,
                              style: TextStyle(
                                color: context.appColors.textTertiary,
                                fontSize: 11,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, s) => Center(child: Text("Error loading fleets")),
            ),
          ),
        ],
      ),
    );
  }
}
