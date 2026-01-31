import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';
import 'package:testable/ui/shared/neon_text.dart';

class VramCalculator extends StatefulWidget {
  const VramCalculator({super.key});

  @override
  State<VramCalculator> createState() => _VramCalculatorState();
}

class _VramCalculatorState extends State<VramCalculator> {
  double _modelSizeB = 7.0; // Billion parameters
  String _quantization = "Q4_K_M"; // 4-bit default

  // Simple heuristic: Params * Bits / 8 = VRAM in GB (roughly)
  double get _vramUsage {
    // 4-bit quantization implies approx 0.7-0.8 GB per Billion params + context overhead
    // Let's use a simpler verified approximation for LLaMA architectures
    // 7B Q4 ~ 4.5 GB
    // 7B Q8 ~ 8 GB
    // 7B F16 ~ 14 GB

    // Base multiplier per billion params
    double multiplier = 0.7;
    if (_quantization == "Q8_0") multiplier = 1.1;
    if (_quantization == "FP16") multiplier = 2.0;

    return (_modelSizeB * multiplier) + 2.0; // +2GB for Context/Overhead
  }

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "VRAM SIMULATOR",
                style: TextStyle(color: Colors.white70, letterSpacing: 1.5),
              ),
              NeonText(
                "${_vramUsage.toStringAsFixed(1)} GB",
                fontSize: 18,
                color: _vramUsage > 24 ? Colors.red : Colors.green,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Text(
            "Model Size: ${_modelSizeB.toInt()}B Params",
            style: const TextStyle(color: Colors.white),
          ),
          Slider(
            value: _modelSizeB,
            min: 1,
            max: 70,
            divisions: 69,
            activeColor: Colors.cyan,
            onChanged: (v) => setState(() => _modelSizeB = v),
          ),

          const SizedBox(height: 10),
          Text(
            "Quantization: $_quantization",
            style: const TextStyle(color: Colors.white),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ["Q4_K_M", "Q8_0", "FP16"].map((q) {
              final isSelected = _quantization == q;
              return ChoiceChip(
                label: Text(q),
                selected: isSelected,
                onSelected: (s) => setState(() => _quantization = q),
                selectedColor: Colors.cyan.withOpacity(0.3),
                backgroundColor: Colors.black,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.cyan : Colors.white54,
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          // Visualization Bar
          Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "RTX 3060 (12GB)",
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                  Text(
                    "RTX 4090 (24GB)",
                    style: TextStyle(color: Colors.white38, fontSize: 10),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Stack(
                children: [
                  Container(
                    height: 10,
                    width: double.infinity,
                    color: Colors.grey[900],
                  ),
                  // 24GB Reference Line
                  Positioned(
                    left: 0,
                    right: 0,
                    child: Container(height: 10, color: Colors.white10),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 10,
                    width:
                        MediaQuery.of(context).size.width *
                        (_vramUsage / 48.0), // Scale relative to say 48GB max
                    color: _vramUsage > 24 ? Colors.red : Colors.cyan,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
