import 'package:flutter/material.dart';

/// Error banner that can be shown at the top of a screen
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final Duration? autoHideDuration;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onDismiss,
    this.autoHideDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Theme.of(context).colorScheme.errorContainer,
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(
                Icons.close,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}

/// Success banner
class SuccessBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const SuccessBanner({super.key, required this.message, this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.green.withOpacity(0.1),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.green[700])),
          ),
          if (onDismiss != null)
            IconButton(
              icon: Icon(Icons.close, color: Colors.green[700]),
              onPressed: onDismiss,
            ),
        ],
      ),
    );
  }
}
