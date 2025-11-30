// lib/shared/widgets/alert_cards.dart
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:testable/shared/components/button/index.dart';

/// Base alert card with common properties
class BaseAlertCard extends StatelessWidget {
  const BaseAlertCard({
    this.title,
    super.key,
    this.message,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.borderColor,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = false,
    this.glowIcon = true,
    this.showBorder = false,
    this.padding = const EdgeInsets.all(10),
    this.titleStyle,
    this.messageStyle,
    this.iconSize = 20,
    this.borderRadius = 12,
    this.elevation = 0,
    this.maxLines = 2,
    this.actionAlignment = WrapAlignment.start,
    this.showIcon = true,
    this.customIcon,
    this.animationDuration = const Duration(milliseconds: 300),
    this.animateEntrance = false,
  });

  final String? title;
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;
  final EdgeInsetsGeometry padding;
  final bool glowIcon;
  final bool showBorder;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;
  final double iconSize;
  final double borderRadius;
  final double elevation;
  final int maxLines;
  final WrapAlignment actionAlignment;
  final bool showIcon;
  final Widget? customIcon;
  final Duration animationDuration;
  final bool animateEntrance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Widget card = Card(
      color: backgroundColor,
      surfaceTintColor: backgroundColor,
      elevation: elevation,
      shadowColor: theme.colorScheme.shadow.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderColor != null && showBorder
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
              crossAxisAlignment: title != null
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                if (showIcon && (icon != null || customIcon != null)) ...[
                  _buildIcon(context),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (title != null) ...[
                        Text(
                          title!,
                          style: theme.textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              )
                              .merge(titleStyle),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                      ],
                      if (message != null) ...[
                        Text(
                          message!,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              )
                              .merge(messageStyle),
                          maxLines: maxLines,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (dismissible) ...[
                  const SizedBox(width: 8),
                  OnTapScaler(
                    scale: 0.8,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onDismiss,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 16,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            // Actions row
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: actionAlignment,
                children: actions,
              ),
            ],
          ],
        ),
      ),
    );

    if (animateEntrance) {
      return TweenAnimationBuilder(
        duration: animationDuration,
        tween: Tween<double>(begin: 0, end: 1),
        builder: (context, value, child) {
          return Transform.scale(
            scale: 0.95 + (value * 0.05),
            child: Opacity(opacity: value, child: child),
          );
        },
        child: card,
      );
    }

    return card;
  }

  Widget _buildIcon(BuildContext context) {
    if (customIcon != null) return customIcon!;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: glowIcon ? iconColor?.withOpacity(0.5) : null,
        shape: BoxShape.circle,
        gradient: glowIcon
            ? LinearGradient(
                colors: [
                  iconColor?.withOpacity(0.2) ?? Colors.transparent,
                  iconColor?.withOpacity(0.1) ?? Colors.transparent,
                ],
              )
            : null,
      ),
      child: Icon(icon, color: iconColor, size: iconSize),
    );
  }
}

/// Error alert card for showing errors
class ErrorAlertCard extends StatelessWidget {
  const ErrorAlertCard({
    this.title,
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
    this.showBorder = false,
    this.glowIcon = true,
  });

  final String? title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;
  final bool showBorder;
  final bool glowIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Builder(
      builder: (context) {
        return BaseAlertCard(
          title: title,
          message: message,
          icon: Iconsax.warning_24,
          iconColor: colorScheme.onErrorContainer,
          backgroundColor: colorScheme.errorContainer,
          borderColor: colorScheme.error.withOpacity(showBorder ? 0.4 : 0.2),
          actions: actions,
          onDismiss: onDismiss,
          dismissible: dismissible,
          glowIcon: glowIcon,
          showBorder: showBorder,
          messageStyle: TextStyle(
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        );
      },
    );
  }
}

/// Success alert card for positive feedback
class SuccessAlertCard extends StatelessWidget {
  const SuccessAlertCard({
    this.title = 'Success',
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
    this.showBorder = false,
    this.glowIcon = true,
  });

  final String? title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;
  final bool showBorder;
  final bool glowIcon;

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
      borderColor: colorScheme.primary.withOpacity(showBorder ? 0.4 : 0.2),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
      glowIcon: glowIcon,
      showBorder: showBorder,
    );
  }
}

/// Info alert card for general information
class InfoAlertCard extends StatelessWidget {
  const InfoAlertCard({
    this.title = 'Information',
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
    this.showBorder = false,
    this.glowIcon = true,
  });

  final String? title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;
  final bool showBorder;
  final bool glowIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: title,
      message: message,
      icon: Iconsax.info_circle,
      iconColor: colorScheme.primary,
      backgroundColor: colorScheme.primaryContainer.withOpacity(0.15),
      borderColor: colorScheme.outline.withOpacity(showBorder ? 0.3 : 0.1),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
      glowIcon: glowIcon,
      showBorder: showBorder,
    );
  }
}

/// Warning alert card for cautionary messages
class WarningAlertCard extends StatelessWidget {
  const WarningAlertCard({
    this.title = 'Warning',
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = true,
    this.showBorder = false,
    this.glowIcon = true,
  });

  final String? title;
  final String? message;
  final List<Widget> actions;
  final VoidCallback? onDismiss;
  final bool dismissible;
  final bool showBorder;
  final bool glowIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Use tertiary color for warnings, fallback to orange
    final warningColor = colorScheme.tertiary ?? const Color(0xFFFF9800);

    return BaseAlertCard(
      title: title,
      message: message,
      icon: Iconsax.warning_2,
      iconColor: warningColor,
      backgroundColor: warningColor.withOpacity(0.1),
      borderColor: warningColor.withOpacity(showBorder ? 0.4 : 0.2),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
      glowIcon: glowIcon,
      showBorder: showBorder,
    );
  }
}

/// Loading alert card for progress indications
class LoadingAlertCard extends StatelessWidget {
  const LoadingAlertCard({
    this.title = 'Loading',
    super.key,
    this.message,
    this.actions = const [],
    this.onDismiss,
    this.dismissible = false,
  });

  final String? title;
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
      customIcon: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
      borderColor: colorScheme.outline.withOpacity(0.2),
      actions: actions,
      onDismiss: onDismiss,
      dismissible: dismissible,
      glowIcon: false,
    );
  }
}

/// Premium feature card for upgrade prompts
class PremiumFeatureCard extends StatelessWidget {
  const PremiumFeatureCard({
    this.title = 'Premium Feature',
    super.key,
    this.message,
    this.onUpgrade,
    this.onDismiss,
    this.featureName,
  });

  final String? title;
  final String? message;
  final VoidCallback? onUpgrade;
  final VoidCallback? onDismiss;
  final String? featureName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: title,
      message:
          message ??
          'Upgrade to premium to access ${featureName ?? 'this feature'}',
      icon: Iconsax.crown_1,
      iconColor: const Color(0xFFFFD700),
      backgroundColor: const Color(0xFFFFF8E1),
      borderColor: const Color(0xFFFFD700).withOpacity(0.3),
      actions: [
        if (onUpgrade != null)
          FilledButton(
            onPressed: onUpgrade,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFD700),
              foregroundColor: Colors.black,
            ),
            child: const Text('Upgrade Now'),
          ),
        if (onDismiss != null)
          TextButton(onPressed: onDismiss, child: const Text('Maybe Later')),
      ],
      onDismiss: onDismiss,
      dismissible: true,
      glowIcon: true,
    );
  }
}

/// Empty state card for when no data is available
class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({
    this.title = 'No Data',
    super.key,
    this.message = 'There is nothing to display here yet.',
    this.icon = Iconsax.box_1,
    this.actionText,
    this.onAction,
  });

  final String? title;
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BaseAlertCard(
      title: title,
      message: message,
      icon: icon,
      iconColor: colorScheme.onSurfaceVariant,
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.3),
      borderColor: colorScheme.outline.withOpacity(0.2),
      actions: [
        if (onAction != null && actionText != null)
          OutlinedButton(onPressed: onAction, child: Text(actionText!)),
      ],
      dismissible: false,
      glowIcon: false,
      actionAlignment: WrapAlignment.center,
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
    this.title = 'Login Failed',
  });

  final String message;
  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final String? title;

  @override
  Widget build(BuildContext context) {
    return ErrorAlertCard(
      title: title,
      message: message,
      dismissible: true,
      onDismiss: onDismiss,
      actions: [
        if (onRetry != null)
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('Try Again'),
          ),
      ],
    );
  }
}

/// Network error card for connectivity issues
class NetworkErrorCard extends StatelessWidget {
  const NetworkErrorCard({
    super.key,
    this.onRetry,
    this.onDismiss,
    this.showBorder = true,
  });

  final VoidCallback? onRetry;
  final VoidCallback? onDismiss;
  final bool showBorder;

  @override
  Widget build(BuildContext context) {
    return ErrorAlertCard(
      title: 'Connection Error',
      message: 'Please check your internet connection and try again.',
      dismissible: true,
      onDismiss: onDismiss,
      showBorder: showBorder,
      actions: [
        if (onRetry != null)
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
      ],
    );
  }
}

/// Coming soon feature card
class ComingSoonCard extends StatelessWidget {
  const ComingSoonCard({
    super.key,
    this.featureName,
    this.onDismiss,
    this.expectedDate,
  });

  final String? featureName;
  final VoidCallback? onDismiss;
  final String? expectedDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    String message =
        '${featureName ?? 'This feature'} is currently in development';
    if (expectedDate != null) {
      message += '. Expected: $expectedDate';
    }

    return BaseAlertCard(
      title: 'Coming Soon 🚀',
      message: message,
      icon: Iconsax.clock,
      iconColor: colorScheme.primary,
      backgroundColor: colorScheme.surfaceVariant.withOpacity(0.4),
      borderColor: colorScheme.primary.withOpacity(0.3),
      dismissible: true,
      onDismiss: onDismiss,
      glowIcon: true,
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
    this.showCountdown = false,
  });

  final String? scheduledTime;
  final String? estimatedDuration;
  final VoidCallback? onDismiss;
  final bool showCountdown;

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
      message: message,
      dismissible: onDismiss != null,
      onDismiss: onDismiss,
      showBorder: true,
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
    this.releaseNotes,
  });

  final String version;
  final VoidCallback? onUpdate;
  final VoidCallback? onDismiss;
  final String? releaseNotes;

  @override
  Widget build(BuildContext context) {
    String message =
        'Version $version is available with new features and improvements.';
    if (releaseNotes != null) {
      message += '\n\n$releaseNotes';
    }

    return BaseAlertCard(
      title: 'Update Available 📱',
      message: message,
      icon: Iconsax.arrow_circle_up,
      iconColor: Colors.green,
      backgroundColor: Colors.green.withOpacity(0.1),
      borderColor: Colors.green.withOpacity(0.3),
      dismissible: onUpdate == null,
      onDismiss: onDismiss,
      maxLines: 4,
      actions: [
        if (onUpdate != null)
          FilledButton(
            onPressed: onUpdate,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Update Now'),
          ),
        if (onDismiss != null)
          TextButton(onPressed: onDismiss, child: const Text('Later')),
      ],
    );
  }
}

