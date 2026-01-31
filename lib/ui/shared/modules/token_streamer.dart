import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';
import 'package:testable/ui/shared/neon_text.dart';

class TokenStreamer extends StatefulWidget {
  const TokenStreamer({super.key});

  @override
  State<TokenStreamer> createState() => _TokenStreamerState();
}

class _TokenStreamerState extends State<TokenStreamer> {
  final String _targetText =
      "AI is infrastructure scaled, abstracted, and delivered as experience. You are not building a demo, you are building a factory.";
  String _currentText = "";
  Timer? _timer;
  int _speedTPS = 40; // Tokens per second (approx)
  bool _isHumanSpeed = false;

  void _startStreaming() {
    _timer?.cancel();
    _currentText = "";
    setState(() {});

    final words = _targetText.split(' ');
    int index = 0;

    // Human: ~5 words/sec (200ms) | AI: ~40 tokens/sec (25ms)
    final delay = _isHumanSpeed
        ? const Duration(milliseconds: 200)
        : const Duration(milliseconds: 25);

    _timer = Timer.periodic(delay, (timer) {
      if (index < words.length) {
        setState(() {
          _currentText += "${words[index]} ";
        });
        index++;
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
                "INFERENCE SPEED TEST",
                style: TextStyle(color: Colors.white70, letterSpacing: 1.5),
              ),
              NeonText(
                _isHumanSpeed ? "~5 TPS (Human)" : "~40 TPS (AI)",
                fontSize: 14,
                color: _isHumanSpeed ? Colors.orange : Colors.pink,
              ),
            ],
          ),
          const SizedBox(height: 16),

          Container(
            height: 100, // Fixed height for text area
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white10),
            ),
            child: Text(
              _currentText + "█", // Cursor
              style: const TextStyle(
                fontFamily: 'monospace',
                fontSize: 14,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                // Play Human
                icon: const Icon(Icons.person),
                color: _isHumanSpeed ? Colors.orange : Colors.grey,
                onPressed: () {
                  setState(() => _isHumanSpeed = true);
                  _startStreaming();
                },
                tooltip: "Human Reading Speed",
              ),
              IconButton(
                // Play AI
                icon: const Icon(Icons.rocket_launch),
                color: !_isHumanSpeed ? Colors.pink : Colors.grey,
                onPressed: () {
                  setState(() => _isHumanSpeed = false);
                  _startStreaming();
                },
                tooltip: "AI Inference Speed",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
