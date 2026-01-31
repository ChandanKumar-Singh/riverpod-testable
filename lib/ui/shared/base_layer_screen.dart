import 'package:flutter/material.dart';
import 'package:testable/core/theme/app_theme.dart';
import 'package:testable/ui/shared/neon_text.dart';

class BaseLayerScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final String layerNumber;
  final IconData icon;
  final Color accentColor;
  final List<Widget> modules; // Changed from 'description' to 'modules'

  const BaseLayerScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.layerNumber,
    required this.icon,
    this.accentColor = AppTheme.accentCyan,
    this.modules = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Ambient Glow
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.2),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.4),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Layer Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NeonText(layerNumber, fontSize: 16, color: accentColor),
                      Icon(icon, color: accentColor, size: 28),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Header
                  NeonText(
                    title.toUpperCase(),
                    fontSize: 40, // Slightly smaller to fit content
                    color: Colors.white,
                    isGlowing: false,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle.toUpperCase(),
                    style: TextStyle(
                      color: accentColor,
                      letterSpacing: 2.5,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Modules List
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        bottom: 80,
                      ), // Space for arrow
                      physics: const BouncingScrollPhysics(),
                      itemCount: modules.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 24),
                      itemBuilder: (context, index) => modules[index],
                    ),
                  ),

                  // Bottom Arrow
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white.withOpacity(0.5),
                        size: 32,
                      ),
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
