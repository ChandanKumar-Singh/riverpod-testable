import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';
import 'package:testable/layers/l0_physical/deep_dive/thermal_simulator.dart';

class L0PhysicalScreen extends StatelessWidget {
  const L0PhysicalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      deepDiveWidget: ThermalSimulator(),
      insightTech: "Server Rack Cooling System (Liquid/Air Hybrid)",
      insightPhysics:
          "Thermodynamics: Q = m * C * ΔT. Managing heat dissipation for high-density H100 GPU clusters.",
      insightValue:
          "Effective cooling reduces PUE (Power Usage Effectiveness) from 1.5 to 1.1, saving millions in OpEx.",
      layerNumber: 'L0',
      title: 'Physical\nReality',
      subtitle: 'The Room & Infrastructure',
      icon: Icons.electrical_services,
      accentColor: Color(0xFFE0E0E0),
      modules: [
        TruthCard(
          statement: "The Room is the Chassis.",
          subtext:
              "AI is not magic. It lives in rooms filled with machines, heat, noise, and power cables.",
        ),
        SpecGrid(
          title: "HOME LAB REQUIREMENTS",
          specs: {
            "Power Supply": "850W+ (Gold/Platinum)",
            "Cooling": "High Static Pressure Fans",
            "Uptime Strategy": "UPS + Auto-Restart",
            "Ambient Temp": "< 25°C Recommended",
          },
        ),
      ],
    );
  }
}
