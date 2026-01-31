import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';

class L5AgentsScreen extends StatelessWidget {
  const L5AgentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      layerNumber: 'L5',
      title: 'Agents &\nTools',
      subtitle: 'The Active Wills',
      icon: Icons.smart_toy,
      accentColor: Color(0xFF00FF00),
      modules: [
        TruthCard(
          statement: "Agents Act. Models Think.",
          subtext:
              "An agent is just a loop: Observation -> Thought -> Action -> Result. Tools are the hands.",
        ),
        SpecGrid(
          title: "AGENT CAPABILITIES",
          specs: {
            "Memory": "RAG / Vector DB",
            "Planning": "ReAct / CoT",
            "Tools": "Search / Python / APIs",
            "Self-Correction": "Reflection Loops",
          },
        ),
      ],
    );
  }
}
