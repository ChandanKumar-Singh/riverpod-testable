import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';

class L6ProductsScreen extends StatelessWidget {
  const L6ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      layerNumber: 'L6',
      title: 'Products\n& UX',
      subtitle: 'The Interface Layer',
      icon: Icons.widgets,
      accentColor: Color(0xFF9013FE),
      modules: [
        TruthCard(
          statement: "The Illusion Layer.",
          subtext:
              "Your phone is not intelligent. It is a terminal connected to intelligence elsewhere. UX is about hiding the latency of L0-L5.",
        ),
        SpecGrid(
          title: "INTERFACE TYPES",
          specs: {
            "Chat UI": "Streaming Tokens",
            "Agents": "Background Jobs",
            "Voice Mode": "Real-time Audio",
            "IDE Plugin": "Inline Completion",
          },
        ),
      ],
    );
  }
}
