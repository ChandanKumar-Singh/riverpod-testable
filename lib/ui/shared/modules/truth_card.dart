import 'package:flutter/material.dart';
import 'package:testable/ui/shared/glass_container.dart';

class TruthCard extends StatelessWidget {
  final String statement;
  final String? subtext;

  const TruthCard({super.key, required this.statement, this.subtext});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      color: Colors.white.withOpacity(0.03),
      border: Border.all(color: Colors.white.withOpacity(0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Theme.of(context).primaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                "FUNDAMENTAL TRUTH",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white54,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            statement,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.3,
            ),
          ),
          if (subtext != null) ...[
            const SizedBox(height: 8),
            Text(
              subtext!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
