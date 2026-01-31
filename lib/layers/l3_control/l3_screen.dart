import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';
import 'package:testable/layers/l3_control/deep_dive/k8s_scheduler.dart';

class L3ControlScreen extends StatelessWidget {
  const L3ControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      deepDiveWidget: K8sSchedulerSimulator(),
      layerNumber: 'L3',
      title: 'Control\nPlane',
      subtitle: 'Routing & Orchestration',
      icon: Icons.router,
      accentColor: Color(0xFFFFCC00),
      modules: [
        TruthCard(
          statement: "The Brain Needs a Manager.",
          subtext:
              "Without a control plane, requests crash, models stall, and users wait. NGINX and Docker are the traffic cops.",
        ),
        SpecGrid(
          title: "CONTROL STACK",
          specs: {
            "Reverse Proxy": "NGINX / Traefik",
            "Orchestrator": "Docker Compose",
            "Inference Backend": "Ollama / vLLM",
            "Queue System": "Redis (Optional)",
          },
        ),
      ],
    );
  }
}
