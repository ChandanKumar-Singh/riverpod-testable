import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';
import 'package:testable/ui/shared/modules/vram_calculator.dart';

class L1ComputeScreen extends StatelessWidget {
  const L1ComputeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      layerNumber: 'L1',
      title: 'Compute\nHardware',
      subtitle: 'The Physical Brain',
      icon: Icons.memory,
      accentColor: Color(0xFF00F0FF),
      modules: [
        TruthCard(
          statement: "Memory is the Bottleneck.",
          subtext:
              "Compute is fast. Moving data to compute is slow. VRAM capacity determines how 'smart' your model can be.",
        ),
        SpecGrid(
          title: "NVIDIA RTX 4090 SPECS",
          specs: {
            "VRAM": "24 GB GDDR6X",
            "CUDA Cores": "16,384",
            "Memory Bus": "384-bit",
            "Bandwidth": "1,008 GB/s",
          },
        ),
        VramCalculator(),
      ],
    );
  }
}
