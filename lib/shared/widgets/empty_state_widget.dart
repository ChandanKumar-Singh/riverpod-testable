import 'package:flutter/material.dart';

/// Reusable empty state widget
class EmptyStateWidget extends StatelessWidget {

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
    this.iconColor,
  });
  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color:
                  iconColor ??
                  Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[const SizedBox(height: 24), action!],
          ],
        ),
      ),
    );
  }
}

/// Empty state for lists
class EmptyListWidget extends StatelessWidget {

  const EmptyListWidget({
    super.key,
    this.message = 'No items found',
    this.action,
  });
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.inbox_outlined,
      title: 'Empty',
      message: message,
      action: action,
    );
  }
}

/// Empty state for errors
class ErrorEmptyStateWidget extends StatelessWidget {

  const ErrorEmptyStateWidget({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      icon: Icons.error_outline,
      title: 'Something went wrong',
      message: message,
      iconColor: Theme.of(context).colorScheme.error,
      action: onRetry != null
          ? ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            )
          : null,
    );
  }
}
