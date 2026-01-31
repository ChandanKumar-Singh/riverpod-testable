import 'package:flutter/material.dart';
import 'package:testable/ui/shared/base_layer_screen.dart';
import 'package:testable/ui/shared/modules/truth_card.dart';
import 'package:testable/ui/shared/modules/spec_grid.dart';
import 'package:testable/ui/shared/modules/bandwidth_visualizer.dart';
import 'package:testable/layers/l2_fabrics/deep_dive/spine_leaf_network.dart';

class L2FabricsScreen extends StatelessWidget {
  const L2FabricsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseLayerScreen(
      deepDiveWidget: SpineLeafNetwork(),
      insightTech: "400Gbps Spine-Leaf Data Center Fabric",
      insightPhysics:
          "Non-blocking Clos topology ensures equidistant bandwidth between any two servers. Minimizes tail latency.",
      insightValue:
          "Reduces 'Flow Completion Time' for distributed training, improving GPU utilization and ROI.",
      layerNumber: 'L2',
      title: 'Compute\nFabrics',
      subtitle: 'The Nervous System',
      icon: Icons.hub,
      accentColor: Color(0xFF4A90E2),
      modules: [
        TruthCard(
          statement: "Moving Tensors > Calculating Tensors.",
          subtext:
              "A GPU waiting for data is a waste of money. Fabrics (PCIe, NVLink, Ethernet) keep the brain fed.",
        ),
        SpecGrid(
          title: "INTERCONNECT SPEEDS",
          specs: {
            "PCIe 4.0 x16": "64 GB/s",
            "PCIe 5.0 x16": "128 GB/s",
            "NVLink (Grace)": "900 GB/s",
            "Ethernet (Std)": "1 GB/s",
          },
        ),
        BandwidthVisualizer(),
      ],
    );
  }
}
