import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_theme.dart';
import 'package:testable/ui/shared/glass_container.dart';
import 'package:testable/ui/shared/neon_text.dart';
import 'package:testable/ui/screens/root_screen.dart'; // Corrected path

class NOCScreen extends StatefulWidget {
  const NOCScreen({super.key});

  @override
  State<NOCScreen> createState() => _NOCScreenState();
}

class _NOCScreenState extends State<NOCScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Grid
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NeonText(
                            "ONE CORE",
                            fontSize: 28,
                            color: AppTheme.accentCyan,
                          ),
                          Text(
                            "NETWORK OPERATIONS CENTER",
                            style: TextStyle(
                              color: Colors.white54,
                              letterSpacing: 2,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                      _buildStatusIndicator(),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Main Dashboard Grid
                  Expanded(
                    child: Center(
                      // Hexgonal or Circular Layout - Let's go with a 2x2 High Density Grid first for clarity
                      child: SingleChildScrollView(
                        child: Wrap(
                          runSpacing: 20,
                          spacing: 20,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildKPICard(
                              "PHYSICAL",
                              "L0",
                              Icons.landscape,
                              "24°C",
                              "RACK TEMP",
                              Colors.blue,
                            ),
                            _buildKPICard(
                              "COMPUTE",
                              "L1",
                              Icons.memory,
                              "98%",
                              "TENSOR UTIL",
                              Colors.cyan,
                            ),
                            _buildKPICard(
                              "FABRICS",
                              "L2",
                              Icons.hub,
                              "400G",
                              "LINK SPEED",
                              Colors.purple,
                            ),
                            _buildKPICard(
                              "KUBERNETES",
                              "L3",
                              Icons.dns,
                              "12/12",
                              "PODS ACTIVE",
                              Colors.orange,
                            ),
                            _buildKPICard(
                              "MODELS",
                              "L4",
                              Icons.psychology,
                              "180",
                              "TOK/SEC",
                              Colors.green,
                            ),
                            _buildKPICard(
                              "AGENTS",
                              "L5",
                              Icons.smart_toy,
                              "3",
                              "ACTIVE",
                              Colors.red,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Enter System Button
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RootScreen()),
                      ),
                      child: AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 20,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.accentCyan.withOpacity(
                                0.1 + (_pulseController.value * 0.2),
                              ),
                              border: Border.all(
                                color: AppTheme.accentCyan,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.accentCyan.withValues(alpha: 0.3),
                                  blurRadius: 20 * _pulseController.value,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Text(
                              "ENTER SYSTEM ENV",
                              style: TextStyle(
                                color: AppTheme.accentCyan,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 3,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKPICard(
    String title,
    String layer,
    IconData icon,
    String value,
    String unit,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        // Future: Direct Jump
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Direct jump coming soon",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Color(0xFF333333),
            duration: Duration(milliseconds: 500),
          ),
        );
      },
      child: Container(
        width: 150,
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color, size: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    layer,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unit,
                  style: const TextStyle(
                    color: Colors.white38,
                    fontSize: 10,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
            // Sparkline placeholder
            Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: color.withValues(alpha: 0.5)),
                ),
              ),
              child: CustomPaint(painter: _SparklinePainter(color)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        border: Border.all(color: Colors.green),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, size: 8, color: Colors.green),
          SizedBox(width: 8),
          Text(
            "SYSTEM OPTIMAL",
            style: TextStyle(
              color: Colors.green,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    double gridSize = 40;
    for (double i = 0; i < size.width; i += gridSize) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += gridSize) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SparklinePainter extends CustomPainter {
  final Color color;
  _SparklinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height);
    // Fake random data line
    path.lineTo(size.width * 0.2, size.height * 0.6);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.6, size.height * 0.3);
    path.lineTo(size.width * 0.8, size.height * 0.5);
    path.lineTo(size.width, size.height * 0.1);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
