import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';

class SpineLeafNetwork extends StatefulWidget {
  const SpineLeafNetwork({super.key});

  @override
  State<SpineLeafNetwork> createState() => _SpineLeafNetworkState();
}

class _SpineLeafNetworkState extends State<SpineLeafNetwork>
    with TickerProviderStateMixin {
  late AnimationController _trafficController;

  // Simulation State
  bool _linkFailure = false; // Is one spine switch down?

  @override
  void initState() {
    super.initState();
    _trafficController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _trafficController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "L2: NETWORK TOPOLOGY",
          style: TextStyle(letterSpacing: 1.5, fontSize: 13),
        ),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Network Graph (Custom Painter)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _trafficController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _NetworkPainter(
                    animationValue: _trafficController.value,
                    isFailure: _linkFailure,
                  ),
                );
              },
            ),
          ),

          // Controls
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: GlassContainer(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "PROTOCOL: RDMA/RoCEv2",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "TOPOLOGY: 2-Tier Spine-Leaf",
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _linkFailure,
                        onChanged: (v) => setState(() => _linkFailure = v),
                        activeColor: Colors.red,
                        inactiveThumbColor: Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _linkFailure
                        ? "STATUS: LINK FAILURE DETECTED - REROUTING VIA ECMP"
                        : "STATUS: OPTIMAL - MULTIPATH ACTIVE",
                    style: TextStyle(
                      color: _linkFailure
                          ? Colors.redAccent
                          : Colors.greenAccent,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
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

class _NetworkPainter extends CustomPainter {
  final double animationValue;
  final bool isFailure;
  _NetworkPainter({required this.animationValue, required this.isFailure});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2.0;

    // Node Positions
    final double spinesY = size.height * 0.2;
    final double leavesY = size.height * 0.5;
    final double serversY = size.height * 0.8;

    // 2 Spine Switches
    final s1 = Offset(size.width * 0.3, spinesY);
    final s2 = Offset(size.width * 0.7, spinesY);

    // 3 Leaf Switches
    final l1 = Offset(size.width * 0.2, leavesY);
    final l2 = Offset(size.width * 0.5, leavesY);
    final l3 = Offset(size.width * 0.8, leavesY);

    // Draw Links (Leaf -> Spine)
    paint.color = Colors.white10;

    // Valid links
    _drawLink(canvas, l1, s1, paint);
    _drawLink(canvas, l1, s2, paint);
    _drawLink(canvas, l2, s1, paint);
    _drawLink(canvas, l2, s2, paint);
    _drawLink(canvas, l3, s1, paint);
    _drawLink(canvas, l3, s2, paint);

    // Draw Traffic Packets
    paint.color = isFailure ? Colors.orange : Colors.blueAccent;
    paint.style = PaintingStyle.fill;

    // Traffic Flow Logic
    // If not failed, traffic uses both spines.
    // If failed (Assume S1 is down), traffic only uses S2.

    // Packet 1: L1 -> S2 (Always works)
    _drawPacket(canvas, l1, s2, animationValue, paint);

    if (!isFailure) {
      // Packet 2: L3 -> S1 (Only if optimal)
      _drawPacket(canvas, l3, s1, (animationValue + 0.5) % 1.0, paint);
    } else {
      // Packet 2 Rerouted: L3 -> S2
      paint.color = Colors.red; // Visualizing reroute
      _drawPacket(canvas, l3, s2, (animationValue + 0.5) % 1.0, paint);
    }

    // Draw Nodes
    paint.color = isFailure ? Colors.red.withOpacity(0.5) : Colors.cyan;
    if (!isFailure) canvas.drawCircle(s1, 15, paint); // Spine 1

    paint.color = Colors.cyan;
    canvas.drawCircle(s2, 15, paint); // Spine 2

    paint.color = Colors.green;
    canvas.drawCircle(l1, 10, paint);
    canvas.drawCircle(l2, 10, paint);
    canvas.drawCircle(l3, 10, paint);

    // Labels
    _drawText(canvas, "Spine 1", s1 + const Offset(-20, -30));
    _drawText(canvas, "Spine 2", s2 + const Offset(-20, -30));
  }

  void _drawLink(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    canvas.drawLine(p1, p2, paint);
  }

  void _drawPacket(
    Canvas canvas,
    Offset start,
    Offset end,
    double t,
    Paint paint,
  ) {
    final pos = Offset.lerp(start, end, t)!;
    canvas.drawCircle(pos, 4, paint);
  }

  void _drawText(Canvas canvas, String text, Offset pos) {
    final textSpan = TextSpan(
      text: text,
      style: const TextStyle(color: Colors.white70, fontSize: 10),
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(covariant _NetworkPainter oldDelegate) => true;
}
