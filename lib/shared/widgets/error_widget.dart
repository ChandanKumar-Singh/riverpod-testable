import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget build(BuildContext context, WidgetRef ref) {
///
///   final state = ref.watch(dataProvider);
///
///   return state.when(
///
///     data: (data) => DataWidget(data),
///     loading: () => const Center(child: CircularProgressIndicator()),
///     error: (e, st) => ErrorDisplay(
///       error: e,
///       stack: st,
///       onRetry: () => ref.refresh(dataProvider),
///     ),
///   );
///
/// }

class ErrorDisplay extends StatelessWidget {

  const ErrorDisplay({
    super.key,
    required this.error,
    this.stack,
    this.title,
    this.onRetry,
    this.icon,
  });
  final Object error;
  final StackTrace? stack;
  final String? title;
  final VoidCallback? onRetry;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final isDebug = kDebugMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ??
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red.shade400,
                  ),

              const SizedBox(height: 20),

              Text(
                title ??
                    (isDebug ? "An Error Occurred" : "Something went wrong"),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Debug version — full details
              if (isDebug) _debugDetails(),

              // Release version — safe generic text
              if (!isDebug)
                Text(
                  "Please try again later.",
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 20),

              if (onRetry != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  label: const Text("Retry"),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _debugDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          "Error: $error",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        if (stack != null)
          SelectableText(
            "Stacktrace:\n$stack",
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "monospace",
              color: Colors.black87,
            ),
          ),
      ],
    );
  }
}

class ErrorScreen extends StatelessWidget {

  const ErrorScreen({
    super.key,
    this.flutterError,
    this.error,
    this.stack,
    this.onRetry,
  });
  final FlutterErrorDetails? flutterError;
  final Object? error;
  final StackTrace? stack;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final bool isDebug = kDebugMode;

    /// ✅ Debug mode → actual Flutter error widget
    if (isDebug && flutterError != null) {
      return _DebugFlutterError(flutterError: flutterError!);
    }

    /// ✅ Release mode → friendly user UI
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 100, color: Colors.red.shade400),
              const SizedBox(height: 20),
              Text(
                "Oops! Something went wrong",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Don't worry — our team has been notified.\nPlease try again.",
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              if (onRetry != null)
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text("Retry"),
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DebugFlutterError extends StatelessWidget {

  const _DebugFlutterError({required this.flutterError});
  final FlutterErrorDetails flutterError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ErrorWidget.builder(flutterError));
  }
}
