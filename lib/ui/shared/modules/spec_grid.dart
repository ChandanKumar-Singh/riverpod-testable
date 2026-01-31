import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';

class SpecGrid extends StatelessWidget {
  final Map<String, String> specs;
  final String title;

  const SpecGrid({
    super.key,
    required this.specs,
    this.title = "TECHNICAL SPECIFICATIONS",
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
          child: Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.white54),
          ),
        ),
        GlassContainer(
          padding: EdgeInsets.zero,
          child: Column(
            children: specs.entries.map((entry) {
              final isLast = entry.key == specs.keys.last;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: isLast
                      ? null
                      : Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.1),
                          ),
                        ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      entry.value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        fontFamily:
                            'RobotoMono', // Monospace for numbers if available, else standard
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
