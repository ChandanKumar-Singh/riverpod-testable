import 'package:flutter/material.dart';
import 'package:testable/features/layers/shared/base_layer_screen.dart';
import 'package:testable/layers/l0_physical/deep_dive/thermal_simulator.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';

class L0PhysicalScreen extends StatelessWidget {
  const L0PhysicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      layerNumber: 0,
      title: "PHYSICAL INFRASTRUCTURE",
      insightTech: "H100 NVL72 Racks + Liquid Cooling.",
      insightPhysics: "Thermodynamics: Heat dissipation = Flow Rate * Delta T.",
      insightValue:
          "Effective cooling reduces PUE from 1.5 to 1.1, saving \$MM.",
      child: Column(
        children: [
          Expanded(child: ThermalSimulator()),
          SizedBox(height: 10),
          TruthCard(statement: "100 MW", subtext: "TOTAL ENERGY DRAW"),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
