import 'dart:math';
import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_theme.dart';
import 'package:testable/ui/shared/glass_container.dart';

class ThermalSimulator extends StatefulWidget {
  const ThermalSimulator({super.key});

  @override
  State<ThermalSimulator> createState() => _ThermalSimulatorState();
}

class _ThermalSimulatorState extends State<ThermalSimulator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _fanSpeed = 0.5; // 0.0 to 1.0
  bool _intakeBlocked = false;

  final Random _rnd = Random();
  final List<_AirParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Initialize particles
    for (int i = 0; i < 100; i++) {
      _particles.add(_generateParticle(initial: true));
    }
  }

  _AirParticle _generateParticle({bool initial = false}) {
    double startX = _rnd.nextDouble(); // 0.0 to 1.0 (left side intake)
    double startY = _rnd.nextDouble(); // Vertical position

    if (initial) {
      startX = _rnd.nextDouble();
    } else {
      startX = 0.0;
    }

    return _AirParticle(
      x: startX,
      y: startY,
      seed: _rnd.nextDouble(),
      speedVariation: 0.8 + _rnd.nextDouble() * 0.4,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "L0: THERMAL MIRROR",
          style: TextStyle(letterSpacing: 2.0, fontSize: 14),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // The Rack Visualization
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                // Update particles
                for (var p in _particles) {
                  double speed = 0.005 + (_fanSpeed * 0.02);
                  if (_intakeBlocked && p.x < 0.2)
                    speed *= 0.1; // Blockage effect

                  p.x += speed * p.speedVariation;

                  // Heat up as they move right
                  // If fan speed is low, they get hotter faster
                  double coolingFactor = _fanSpeed * 2.0;
                  p.temp = (p.x * 2.0) - coolingFactor;
                  if (p.temp < 0) p.temp = 0;
                  if (p.temp > 1.0) p.temp = 1.0;

                  // Recycle
                  if (p.x > 1.0) {
                    var newP = _generateParticle();
                    p.x = newP.x;
                    p.y = newP.y;
                    p.temp = 0.0;
                  }
                }

                return CustomPaint(
                  painter: _ThermalPainter(
                    _particles,
                    _fanSpeed,
                    _intakeBlocked,
                  ),
                );
              },
            ),
          ),

          // Controls Overlay
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "FAN RPM",
                        style: TextStyle(color: Colors.white70),
                      ),
                      Text(
                        "${(_fanSpeed * 5000).toInt()} RPM",
                        style: const TextStyle(
                          color: AppTheme.accentCyan,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _fanSpeed,
                    onChanged: (v) => setState(() => _fanSpeed = v),
                    activeColor: AppTheme.accentCyan,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _intakeBlocked
                                ? Colors.red
                                : Colors.white10,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              setState(() => _intakeBlocked = !_intakeBlocked),
                          icon: Icon(_intakeBlocked ? Icons.block : Icons.air),
                          label: Text(
                            _intakeBlocked ? "INTAKE BLOCKED" : "BLOCK INTAKE",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AirParticle {
  double x;
  double y;
  double temp; // 0.0 (Cold/Blue) -> 1.0 (Hot/Red)
  double seed;
  double speedVariation;

  _AirParticle({
    required this.x,
    required this.y,
    this.temp = 0.0,
    required this.seed,
    required this.speedVariation,
  });
}

class _ThermalPainter extends CustomPainter {
  final List<_AirParticle> particles;
  final double fanSpeed;
  final bool blocked;

  _ThermalPainter(this.particles, this.fanSpeed, this.blocked);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeCap = StrokeCap.round;

    // Draw Rack Outline (Wireframe)
    final rackPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 3 Server Units
    double unitHeight = size.height / 4;
    for (int i = 1; i <= 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.1,
          unitHeight * i,
          size.width * 0.8,
          unitHeight * 0.8,
        ),
        rackPaint,
      );

      // Draw Heat components (CPU/GPU) inside
      final compPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.05)
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(
          size.width * 0.4,
          unitHeight * i + unitHeight * 0.2,
          size.width * 0.2,
          unitHeight * 0.4,
        ),
        compPaint,
      );
    }

    // Draw Particles
    for (var p in particles) {
      // Color based on temp
      // Blue (Cold) -> Purple -> Red (Hot)
      Color color = Color.lerp(Colors.cyan, Colors.red, p.temp) ?? Colors.cyan;
      color = color.withValues(alpha: 0.6);

      paint.color = color;
      paint.strokeWidth = 3.0;

      // Draw trail
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        2 + (fanSpeed * 2),
        paint,
      );
    }

    // Warning overlay
    if (blocked) {
      final warnPaint = Paint()
        ..color = Colors.red.withValues(alpha: 0.1)
        ..style = PaintingStyle.fill;
      canvas.drawRect(Offset.zero & size, warnPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
