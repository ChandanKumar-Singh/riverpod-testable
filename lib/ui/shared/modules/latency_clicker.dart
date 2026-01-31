import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';
import 'package:testable/ui/shared/neon_text.dart';

class LatencyClicker extends StatefulWidget {
  const LatencyClicker({super.key});

  @override
  State<LatencyClicker> createState() => _LatencyClickerState();
}

class _LatencyClickerState extends State<LatencyClicker> {
  int _simulatedLatencyMs = 16; // 16ms (60fps) vs 100ms
  Color _buttonColor = Colors.white;

  void _handleTap() async {
    // Simulate latency before visual feedback
    await Future.delayed(Duration(milliseconds: _simulatedLatencyMs));
    setState(() => _buttonColor = Colors.greenAccent);

    // Reset
    await Future.delayed(const Duration(milliseconds: 150));
    setState(() => _buttonColor = Colors.white);
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
                "PERCEPTION TEST",
                style: TextStyle(color: Colors.white70, letterSpacing: 1.5),
              ),
              NeonText(
                "${_simulatedLatencyMs}ms",
                fontSize: 16,
                color: _simulatedLatencyMs < 20 ? Colors.green : Colors.orange,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Tap to feel the delay.",
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 16),

          Center(
            child: GestureDetector(
              onTapDown: (_) => _handleTap(),
              child: AnimatedContainer(
                duration: const Duration(
                  milliseconds: 50,
                ), // Intrinsic button anim speed
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: _buttonColor == Colors.white
                      ? Colors.white.withOpacity(0.1)
                      : _buttonColor,
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.white24, width: 2),
                  boxShadow: _buttonColor == Colors.greenAccent
                      ? [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.5),
                            blurRadius: 20,
                          ),
                        ]
                      : [],
                ),
                child: const Icon(
                  Icons.touch_app,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _LatencyOption(
                16,
                "16ms (Fluid)",
                _simulatedLatencyMs == 16,
                (v) => setState(() => _simulatedLatencyMs = v),
              ),
              _LatencyOption(
                100,
                "100ms (Lag)",
                _simulatedLatencyMs == 100,
                (v) => setState(() => _simulatedLatencyMs = v),
              ),
              _LatencyOption(
                300,
                "300ms (Slow)",
                _simulatedLatencyMs == 300,
                (v) => setState(() => _simulatedLatencyMs = v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LatencyOption extends StatelessWidget {
  final int val;
  final String label;
  final bool isSelected;
  final Function(int) onSelect;

  const _LatencyOption(this.val, this.label, this.isSelected, this.onSelect);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onSelect(val),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white24 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.white : Colors.white10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white54,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
