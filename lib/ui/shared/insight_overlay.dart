import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_theme.dart';
import 'package:testable/ui/shared/glass_container.dart';

/// A wrapper that provides an "Insight Engine" overlay button.
class InsightOverlay extends StatefulWidget {
  final Widget child;
  final String title;
  final String techDescription;
  final String physicsDescription;
  final String valueDescription;

  const InsightOverlay({
    super.key,
    required this.child,
    required this.title,
    required this.techDescription,
    required this.physicsDescription,
    required this.valueDescription,
  });

  @override
  State<InsightOverlay> createState() => _InsightOverlayState();
}

class _InsightOverlayState extends State<InsightOverlay> {
  bool _showOverlay = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The main screen content
        widget.child,

        // The Overlay Drawer
        if (_showOverlay)
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: 300,
            child: Container(
              color: Colors
                  .transparent, // Background allows seeing through slightly? Or standard drawer
              child: Row(
                children: [
                  // Glass effect background
                  Expanded(
                    child: GlassContainer(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            Text(
                              "INSIGHT ENGINE",
                              style: TextStyle(
                                color: AppTheme.accentCyan,
                                fontSize: 10,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              widget.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(color: Colors.white24),

                            const SizedBox(height: 20),
                            _buildSection(
                              "THE TECH",
                              Icons.memory,
                              widget.techDescription,
                            ),
                            _buildSection(
                              "THE PHYSICS",
                              Icons.science,
                              widget.physicsDescription,
                            ),
                            _buildSection(
                              "THE VALUE",
                              Icons.monetization_on,
                              widget.valueDescription,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

        // The Insight Button (Bottom Right) - MOVED TO TOP Z-INDEX
        Positioned(
          bottom: 100, // Above typical FABs or nav bars
          right: 20,
          child: FloatingActionButton(
            backgroundColor: AppTheme.accentCyan.withOpacity(0.8),
            onPressed: () => setState(() => _showOverlay = !_showOverlay),
            child: Icon(
              _showOverlay ? Icons.close : Icons.lightbulb_outline,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(String label, IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white54, size: 14),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
