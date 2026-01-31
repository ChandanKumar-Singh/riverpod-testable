import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';
import 'package:testable/ui/shared/neon_text.dart';

class BandwidthVisualizer extends StatefulWidget {
  const BandwidthVisualizer({super.key});

  @override
  State<BandwidthVisualizer> createState() => _BandwidthVisualizerState();
}

class _BandwidthVisualizerState extends State<BandwidthVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Speed multipliers relative to animation duration
  final double _pcie4Speed = 1.0;
  final double _pcie5Speed = 2.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "PCIE BANDWIDTH RACE",
            style: TextStyle(color: Colors.white70, letterSpacing: 1.5),
          ),
          const SizedBox(height: 24),

          _buildLane("PCIe 4.0 (x16)", "64 GB/s", Colors.blue, _pcie4Speed),
          const SizedBox(height: 24),
          _buildLane("PCIe 5.0 (x16)", "128 GB/s", Colors.purple, _pcie5Speed),

          const SizedBox(height: 16),
          const Text(
            "Transfer 10GB Model:",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 4),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "PCIe 4.0: ~156ms",
                style: TextStyle(color: Colors.blueAccent),
              ),
              Text(
                "PCIe 5.0: ~78ms",
                style: TextStyle(color: Colors.purpleAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLane(
    String label,
    String bandwidth,
    Color color,
    double speedMultiplier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white)),
            NeonText(bandwidth, fontSize: 14, color: color, isGlowing: false),
          ],
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            return SizedBox(
              height: 4,
              child: Stack(
                children: [
                  Container(
                    height: 4,
                    width: double.infinity,
                    color: Colors.white10,
                  ),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final offset =
                          (_controller.value * speedMultiplier * width) % width;
                      return Positioned(left: offset, child: child!);
                    },
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: color,
                        boxShadow: [
                          BoxShadow(
                            color: color,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
