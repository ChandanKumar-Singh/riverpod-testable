import 'dart:async';
import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';
import 'package:testable/ui/shared/neon_text.dart';

class TensorCoreSimulator extends StatefulWidget {
  const TensorCoreSimulator({super.key});

  @override
  State<TensorCoreSimulator> createState() => _TensorCoreSimulatorState();
}

class _TensorCoreSimulatorState extends State<TensorCoreSimulator> {
  // 4x4 Matrices
  final List<List<int>> _matrixA = List.generate(
    4,
    (_) => List.generate(4, (_) => 1),
  );
  final List<List<int>> _matrixB = List.generate(
    4,
    (_) => List.generate(4, (_) => 1),
  );
  final List<List<int>> _matrixC = List.generate(
    4,
    (_) => List.generate(4, (_) => 0),
  );

  bool _isProcessing = false;
  int _currentStep = 0; // 0: Idle, 1: Load, 2: Multiply, 3: Accumulate

  void _startCycle() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    // Step 1: Load (Data flows in)
    setState(() => _currentStep = 1);
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 2: Multiply (The Warp execution)
    setState(() => _currentStep = 2);
    await Future.delayed(const Duration(milliseconds: 600));

    // Step 3: Accumulate (Update C)
    setState(() {
      _currentStep = 3;
      // Perform math for visualization (Simple dummy update)
      for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 4; j++) {
          _matrixC[i][j] += 1;
        }
      }
    });
    await Future.delayed(const Duration(milliseconds: 600));

    // Reset
    setState(() {
      _isProcessing = false;
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "L1: TENSOR CORE DEEP DIVE",
          style: TextStyle(letterSpacing: 1.5, fontSize: 13),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                "FP16 MMA OPERATION (D = A * B + C)",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 32),

              // Visual Pipeline
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Input Matrices
                  Column(
                    children: [
                      _buildMatrixGrid(
                        "Matrix A (FP16)",
                        Colors.cyan,
                        _matrixA,
                      ),
                      const SizedBox(height: 16),
                      _buildMatrixGrid(
                        "Matrix B (FP16)",
                        Colors.cyan,
                        _matrixB,
                      ),
                    ],
                  ),

                  // The Tensor Core Unit
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: _currentStep == 2 ? Colors.white : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _currentStep == 2 ? Colors.cyan : Colors.white24,
                        width: 2,
                      ),
                      boxShadow: _currentStep == 2
                          ? [
                              BoxShadow(
                                color: Colors.cyan.withOpacity(0.8),
                                blurRadius: 20,
                              ),
                            ]
                          : [],
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hub,
                            color: _currentStep == 2
                                ? Colors.black
                                : Colors.white,
                            size: 40,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "HMMA",
                            style: TextStyle(
                              color: _currentStep == 2
                                  ? Colors.black
                                  : Colors.white54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Output Matrix
                  _buildMatrixGrid(
                    "Accumulator (FP32)",
                    Colors.green,
                    _matrixC,
                    isAccumulator: true,
                  ),
                ],
              ),

              const SizedBox(height: 48),
              GlassContainer(
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "WARP EXECUTION STATUS",
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        ),
                        const SizedBox(height: 4),
                        NeonText(
                          _getStatusText(),
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: _currentStep / 3.0,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.cyan,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan.withOpacity(0.2),
                          foregroundColor: Colors.cyan,
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed: _startCycle,
                        child: const Text("EXECUTE TENSOR OPERATION"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (_currentStep) {
      case 1:
        return "LOADING REGISTERS...";
      case 2:
        return "MULTIPLYING (4x4x4)...";
      case 3:
        return "ACCUMULATING FP32...";
      default:
        return "IDLE";
    }
  }

  Widget _buildMatrixGrid(
    String label,
    Color color,
    List<List<int>> data, {
    bool isAccumulator = false,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            border: Border.all(
              color: _currentStep == (isAccumulator ? 3 : 1)
                  ? color
                  : Colors.white10,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            children: data
                .map(
                  (row) => Row(
                    children: row
                        .map(
                          (val) => Container(
                            margin: const EdgeInsets.all(1),
                            width: 12,
                            height: 12,
                            color: color.withOpacity(0.3),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
