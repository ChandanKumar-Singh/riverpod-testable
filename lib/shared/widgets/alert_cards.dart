// lib/shared/widgets/alert_cards.dart
import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testable/shared/components/button/index.dart';

/// Base alert card with common properties
class BaseAlertCard extends StatelessWidget {
  const BaseAlertCard({
    required this.title,
    super.key,
    this.message,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = false,
    this.padding = const EdgeInsets.all(10),
  });

  final String title;
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      color: backgroundColor,
      surfaceTintColor: backgroundColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: borderColor != null
            ? BorderSide(color: borderColor!)
            : BorderSide.none,
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row with icon and title
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: iconColor?.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (message != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          message!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (dismissible) ...[
                  const SizedBox(width: 8),
                  OnTapScaler(
                    child: InkWell(
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      // padding: EdgeInsets.zero,
                      onTap: onDismiss,
                    ),
                  ),
                ],
              ],
            ),
            // Actions row
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: actions),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error alert card for showing errors
class ErrorAlertCard extends StatelessWidget {
  const ErrorAlertCard({
    required this.title,
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
  });

  final String title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: title,
      message: message,
      icon: Iconsax.warning_2,
      iconColor: colorScheme.error,
      backgroundColor: colorScheme.errorContainer,
      borderColor: colorScheme.error.withOpacity(0.3),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
    );
  }
}

/// Success alert card for positive feedback
class SuccessAlertCard extends StatelessWidget {
  const SuccessAlertCard({
    required this.title,
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
  });

  final String title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: title,
      message: message,
      icon: Iconsax.tick_circle,
      iconColor: colorScheme.primary,
      backgroundColor: colorScheme.primaryContainer,
      borderColor: colorScheme.primary.withOpacity(0.3),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
    );
  }
}

/// Info alert card for general information
class InfoAlertCard extends StatelessWidget {
  const InfoAlertCard({
    required this.title,
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
  });

  final String title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: title,
      message: message,
      icon: Iconsax.info_circle,
      iconColor: colorScheme.primary,
      backgroundColor: colorScheme.primaryContainer.withOpacity(0.2),
      borderColor: colorScheme.outline.withOpacity(0.3),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
    );
  }
}

/// Warning alert card for cautionary messages
class WarningAlertCard extends StatelessWidget {
  const WarningAlertCard({
    required this.title,
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
  });

  final String title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use tertiary color for warnings, fallback to orange
    final warningColor = colorScheme.tertiary ?? Colors.orange;

    return BaseAlertCard(
      title: title,
      message: message,
      icon: Iconsax.danger,
      iconColor: warningColor,
      backgroundColor: warningColor.withOpacity(0.1),
      borderColor: warningColor.withOpacity(0.3),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
    );
  }
}

/// Login error card specifically for login/signup screens
class LoginErrorCard extends StatelessWidget {
  const LoginErrorCard({
    required this.message,
    super.key,
    this.onRetry,
    this.onDismiss,
  });

  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ErrorAlertCard(
      title: 'Login Failed',
      message: message,
      dismissible: true,
      onDismiss: onDismiss,
      actions: [
        if (onRetry != null)
          FilledButton.tonal(
            onPressed: onRetry,
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.onErrorContainer,
              foregroundColor: colorScheme.errorContainer,
            ),
            child: const Text('Try Again'),
          ),
      ],
    );
  }
}

/// Network error card for connectivity issues
class NetworkErrorCard extends StatelessWidget {
  const NetworkErrorCard({super.key, this.onRetry, this.onDismiss});

  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    return ErrorAlertCard(
      title: 'Connection Error',
      message: 'Please check your internet connection and try again.',
      dismissible: true,
      onDismiss: onDismiss,
      actions: [
        if (onRetry != null)
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

/// Coming soon feature card
class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({super.key, this.featureName, this.onDismiss});

  final String? featureName;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: 'Coming Soon',
      message: featureName != null
          ? '$featureName is currently in development'
          : 'This feature is currently in development',
      icon: Iconsax.clock,
      iconColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.5),
      borderColor: colorScheme.outline.withOpacity(0.3),
      dismissible: true,
      onDismiss: onDismiss,
    );
  }
}

/// Maintenance alert card
class MaintenanceCard extends StatelessWidget {
  const MaintenanceCard({
    super.key,
    this.scheduledTime,
    this.estimatedDuration,
    this.onDismiss,
  });

  final String? scheduledTime;
  final String? estimatedDuration;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    String message = 'We are performing scheduled maintenance';
    if (scheduledTime != null) {
      message += ' at $scheduledTime';
    }
    if (estimatedDuration != null) {
      message += '. Estimated duration: $estimatedDuration';
    }

    return WarningAlertCard(
      title: 'Scheduled Maintenance',
      message: '$message.',
      dismissible: false,
    );
  }
}

/// Update available card
class UpdateAvailableCard extends StatelessWidget {
  const UpdateAvailableCard({
    required this.version,
    super.key,
    this.onUpdate,
    this.onDismiss,
  });

  final String version;
  final VoidCallback? onUpdate;
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: 'Update Available',
      message:
          'Version $version is available with new features and improvements.',
      icon: Iconsax.arrow_circle_up,
      iconColor: colorScheme.primary,
      backgroundColor: colorScheme.primaryContainer.withOpacity(0.2),
      borderColor: colorScheme.primary.withOpacity(0.3),
      dismissible: onUpdate == null,
      onDismiss: onDismiss,
      actions: [
        if (onUpdate != null)
          FilledButton(onPressed: onUpdate, child: const Text('Update Now')),
        if (onDismiss != null)
          TextButton(onPressed: onDismiss, child: const Text('Later')),
      ],
    );
  }
}

/// Usage examples widget to demonstrate all cards
@RoutePage()
class AlertCardsDemoScreen extends StatelessWidget {
  const AlertCardsDemoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alert Cards')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Error Cards
            _buildSectionTitle('Error Cards'),
            const ErrorAlertCard(
              title: 'Operation Failed',
              message:
                  'The requested operation could not be completed. Please try again.',
            ),
            const SizedBox(height: 12),
            const LoginErrorCard(
              message:
                  'Invalid email or password. Please check your credentials.',
            ),
            const SizedBox(height: 12),
            const NetworkErrorCard(),

            const SizedBox(height: 24),

            // Success & Info Cards
            _buildSectionTitle('Success & Info Cards'),
            const SuccessAlertCard(
              title: 'Profile Updated',
              message: 'Your profile has been successfully updated.',
            ),
            const SizedBox(height: 12),
            const InfoAlertCard(
              title: 'New Feature Available',
              message: 'Check out the new dashboard with enhanced analytics.',
            ),
            const SizedBox(height: 12),
            const ComingSoonCard(featureName: 'Advanced Analytics'),

            const SizedBox(height: 24),

            // Warning Cards
            _buildSectionTitle('Warning Cards'),
            const WarningAlertCard(
              title: 'Action Required',
              message:
                  'Your subscription will expire in 3 days. Please renew to continue.',
            ),
            const SizedBox(height: 12),
            const MaintenanceCard(
              scheduledTime: '2:00 AM - 4:00 AM',
              estimatedDuration: '2 hours',
            ),
            const SizedBox(height: 12),
            const UpdateAvailableCard(version: '2.1.0'),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
