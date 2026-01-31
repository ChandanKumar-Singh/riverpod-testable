import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';
import 'package:testable/ui/shared/modules/latency_clicker.dart';

class L7HumansScreen extends StatelessWidget {
  const L7HumansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      layerNumber: 'L7',
      title: 'Humans',
      subtitle: 'The Purpose',
      icon: Icons.face,
      accentColor: Colors.white,
      modules: [
        TruthCard(
          statement: "Perception is Reality.",
          subtext:
              "We build the entire machine for this layer. If it feels slow, it is slow. 100ms is the limit of 'instant'.",
        ),
        SpecGrid(
          title: "HUMAN CONSTRAINTS",
          specs: {
            "Visual Frame": "~16ms (60fps)",
            "Reaction Time": "~250ms",
            "Instant Feel": "< 100ms",
            "Attention Span": "~8s",
          },
        ),
        LatencyClicker(),
      ],
    );
  }
}
