import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';
import 'package:testable/ui/shared/modules/token_streamer.dart';
import 'package:testable/layers/l4_models/deep_dive/attention_visualizer.dart';

class L4ModelsScreen extends StatelessWidget {
  const L4ModelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      deepDiveWidget: AttentionHeadVisualizer(),
      layerNumber: 'L4',
      title: 'Models &\nAPIs',
      subtitle: 'The Intelligence Engine',
      icon: Icons.psychology,
      accentColor: Color(0xFFFF003C),
      modules: [
        TruthCard(
          statement: "Thinking is Token Generation.",
          subtext:
              "Models don't 'know' things. They predict the next token. Inference is the process of turning electricity into probability.",
        ),
        SpecGrid(
          title: "SPEED COMPARISON",
          specs: {
            "Human Reading": "~5-10 TPS",
            "Llama 3 (8B)": "~100 TPS",
            "GPT-4": "~20-40 TPS",
            "Groq (LPU)": "~500 TPS",
          },
        ),
        TokenStreamer(),
      ],
    );
  }
}
