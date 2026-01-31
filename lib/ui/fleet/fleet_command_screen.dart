import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:testable/core/theme/app_colors.dart';
import 'package:testable/ui/fleet/models/fleet_environment.dart';
import 'package:testable/ui/fleet/providers/fleet_providers.dart';
import 'package:testable/ui/fleet/widgets/deployment_overlay.dart';
import 'package:testable/ui/fleet/widgets/environment_card.dart';
import 'package:testable/ui/fleet/widgets/fleet_dashboard_header.dart';
import 'package:testable/ui/fleet/widgets/fleet_selection_list.dart';

class FleetCommandScreen extends ConsumerStatefulWidget {
  const FleetCommandScreen({super.key});

  @override
  ConsumerState<FleetCommandScreen> createState() => _FleetCommandScreenState();
}

class _FleetCommandScreenState extends ConsumerState<FleetCommandScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FleetEnvironment? _environmentForDeployment;

  @override
  Widget build(BuildContext context) {
    final selectedFleetAsync = ref.watch(selectedFleetProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: context.appColors.bgPrimary,
      endDrawer: _environmentForDeployment != null
          ? Drawer(
              width: 400,
              child: DeploymentOverlay(
                env: _environmentForDeployment!,
                onClose: () {
                  setState(() => _environmentForDeployment = null);
                  Navigator.of(context).pop();
                },
              ),
            )
          : null,
      onEndDrawerChanged: (isOpen) {
        if (!isOpen) {
          setState(() => _environmentForDeployment = null);
        }
      },
      body: Column(
        children: [
          const FleetDashboardHeader(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Panel: Fleet List
                const FleetSelectionList(),

                // Right Panel: Environment Grid
                Expanded(
                  child: selectedFleetAsync.when(
                    data: (fleet) {
                      if (fleet == null) {
                        return Center(
                          child: Text(
                            "No Fleets Available",
                            style: TextStyle(
                              color: context.appColors.textTertiary,
                            ),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Breadcrumb / Title
                            Text(
                              "${fleet.name} / ENVIRONMENTS",
                              style: TextStyle(
                                color: context.appColors.textTertiary,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Grid
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 24,
                                      mainAxisSpacing: 24,
                                      childAspectRatio: 1.4,
                                    ),
                                itemCount: fleet.environments.length,
                                itemBuilder: (context, index) {
                                  final env = fleet.environments[index];
                                  return EnvironmentCard(
                                    env: env,
                                    onDeploy: () {
                                      setState(
                                        () => _environmentForDeployment = env,
                                      );
                                      _scaffoldKey.currentState
                                          ?.openEndDrawer();
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (_, __) => const SizedBox(),
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
