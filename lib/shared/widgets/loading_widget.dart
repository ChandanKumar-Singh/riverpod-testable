import 'package:flutter/material.dart';

/// Reusable loading widget with optional message
class LoadingWidget extends StatelessWidget {

  const LoadingWidget({super.key, this.message, this.color});
  final String? message;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: color != null
                ? AlwaysStoppedAnimation<Color>(color!)
                : null,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

/// Full screen loading overlay
class LoadingOverlay extends StatelessWidget {

  const LoadingOverlay({
    required this.child, required this.isLoading, super.key,
    this.message,
  });
  final Widget child;
  final bool isLoading;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: LoadingWidget(message: message),
          ),
      ],
    );
  }
}
