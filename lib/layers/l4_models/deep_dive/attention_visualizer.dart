import 'package:flutter/material.dart';

class AttentionHeadVisualizer extends StatefulWidget {
  const AttentionHeadVisualizer({super.key});

  @override
  State<AttentionHeadVisualizer> createState() =>
      _AttentionHeadVisualizerState();
}

class _AttentionHeadVisualizerState extends State<AttentionHeadVisualizer> {
  final String _sentence =
      "The animal didn't cross the street because it was too tired";
  late List<String> _tokens;
  int? _hoveredIndex;

  // Fake Attention Weights (Simple heuristic for demo)
  // "it" -> "animal" (high), "street" (low)
  // "tired" -> "animal" (high)
  Map<int, Map<int, double>> _attentionMap = {};

  @override
  void initState() {
    super.initState();
    _tokens = _sentence.split(' ');
    _generateFakeAttention();
  }

  void _generateFakeAttention() {
    _attentionMap = {};
    for (int i = 0; i < _tokens.length; i++) {
      _attentionMap[i] = {};
      for (int j = 0; j < _tokens.length; j++) {
        // Self attention is always strong
        double weight = (i == j) ? 0.3 : 0.05;

        // Linguistic logic (hardcoded demo)
        if (_tokens[i] == "it" && _tokens[j] == "animal") weight = 0.9;
        if (_tokens[i] == "tired" && _tokens[j] == "animal") weight = 0.8;
        if (_tokens[i] == "cross" && _tokens[j] == "street") weight = 0.7;

        _attentionMap[i]![j] = weight;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "L4: SELF-ATTENTION MAP",
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
          // The Curves Painter
          Positioned.fill(
            child: CustomPaint(
              painter: _AttentionPainter(
                tokens: _tokens,
                hoveredIndex: _hoveredIndex,
                attentionMap: _attentionMap,
              ),
            ),
          ),

          // The Token Lists (Left/Right Overlay)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTokenColumn(isSource: true),
              _buildTokenColumn(isSource: false),
            ],
          ),

          // Instructions
          const Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "HOVER OVER LEFT TOKENS TO SEE ATTENTION",
                style: TextStyle(color: Colors.white38, letterSpacing: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenColumn({required bool isSource}) {
    return Container(
      width: 100,
      margin: const EdgeInsets.symmetric(vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_tokens.length, (index) {
          bool isHovered = _hoveredIndex == index;
          return MouseRegion(
            onEnter: (_) =>
                isSource ? setState(() => _hoveredIndex = index) : null,
            onExit: (_) =>
                isSource ? setState(() => _hoveredIndex = null) : null,
            child: Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSource
                    ? (isHovered ? Colors.blue : Colors.white10)
                    : Colors.white10,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                _tokens[index],
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _AttentionPainter extends CustomPainter {
  final List<String> tokens;
  final int? hoveredIndex;
  final Map<int, Map<int, double>> attentionMap;

  _AttentionPainter({
    required this.tokens,
    required this.hoveredIndex,
    required this.attentionMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (hoveredIndex == null) return;

    // Calculate positions matched to the widgets
    // Assuming widgets are centered vertically
    final double totalHeight = tokens.length * 48.0; // 40 height + 8 margin
    final double startY =
        (size.height - totalHeight) / 2 + 20; // 20 is half box height

    final Paint paint = Paint()..style = PaintingStyle.stroke;

    final weights = attentionMap[hoveredIndex]!;

    for (int targetIdx = 0; targetIdx < tokens.length; targetIdx++) {
      double strength = weights[targetIdx] ?? 0.0;
      if (strength < 0.1) continue; // Skip weak links

      // Start Point (Left Column)
      final p1 = Offset(100, startY + (hoveredIndex! * 48.0));
      // End Point (Right Column)
      final p2 = Offset(size.width - 100, startY + (targetIdx * 48.0));

      paint.color = Colors.blue.withOpacity(strength);
      paint.strokeWidth = strength * 8.0;

      // Bezier Curve
      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      path.cubicTo(
        size.width * 0.4,
        p1.dy, // Control Point 1
        size.width * 0.6,
        p2.dy, // Control Point 2
        p2.dx,
        p2.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AttentionPainter oldDelegate) => true;
}
