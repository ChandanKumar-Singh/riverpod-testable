// services/dialog_service.dart
part of '../permission_manager.dart';

abstract class IDialogService {
  Future<bool> showPermissionRationale({
    required String title,
    required String message,
    String? iconAsset,
    String? imageAsset,
  });

  Future<bool> showOpenSettingsDialog({
    required String title,
    required String message,
  });
}

class PermissionRequestDialog extends StatefulWidget {
  const PermissionRequestDialog({
    required this.configs,
    super.key,
    this.title = 'Permissions Required',
    this.description =
        'This app needs the following permissions to work properly:',
    this.allowButtonText = 'Allow All',
    this.cancelButtonText = 'Cancel',
    this.showEssentialBadge = true,
    this.primaryColor = const Color(0xFF4361EE),
    this.backgroundColor = Colors.white,
    this.cardColor = const Color(0xFFF8F9FA),
    this.defaultIcon = Icons.lock_outline,
    this.maxDialogHeight = 500,
    this.onResult,
  });
  final List<PermissionRequestConfig> configs;
  final String title;
  final String description;
  final String allowButtonText;
  final String cancelButtonText;
  final bool showEssentialBadge;
  final Color primaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final IconData defaultIcon;
  final double maxDialogHeight;
  final void Function(bool)? onResult;

  @override
  PermissionRequestDialogState createState() => PermissionRequestDialogState();
}

class PermissionRequestDialogState extends State<PermissionRequestDialog> {
  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final effectiveBackgroundColor = isDarkMode
        ? Colors.grey[900]!
        : widget.backgroundColor;

    final effectiveCardColor = isDarkMode
        ? Colors.grey[800]!
        : widget.cardColor;

    return Dialog(
      backgroundColor: effectiveBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 24,
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: kToolbarHeight,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widget.maxDialogHeight,
          maxWidth: 500,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _buildHeader(theme, isDarkMode),

            // Scrollable Content
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.pixels > 0 && !_isExpanded) {
                    setState(() => _isExpanded = true);
                  } else if (notification.metrics.pixels == 0 && _isExpanded) {
                    setState(() => _isExpanded = false);
                  }
                  return false;
                },
                child: Scrollbar(
                  controller: _scrollController,
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const SizedBox(height: 8),
                            Text(
                              widget.description,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[700],
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                          ]),
                        ),
                      ),

                      // Permission List
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            return _buildPermissionCard(
                              widget.configs[index],
                              index,
                              isDarkMode,
                              effectiveCardColor,
                            );
                          }, childCount: widget.configs.length),
                        ),
                      ),

                      SliverPadding(
                        padding: const EdgeInsets.only(bottom: 24),
                        sliver: SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 24),
                              Divider(
                                height: 1,
                                color: isDarkMode
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Text(
                                  'You can change these permissions anytime in Settings.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDarkMode
                                        ? Colors.grey[500]
                                        : Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer with Buttons
            _buildFooter(theme, isDarkMode),
            // const ThemeSwitcher(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 10),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.transparent,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          bottom: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: widget.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.shield_outlined,
              color: widget.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : Colors.grey[900],
                  ),
                ),
                if (widget.configs.length > 1)
                  Text(
                    '${widget.configs.length} permissions needed',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          if (widget.configs.any((c) => c.isEssential))
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.priority_high_rounded,
                    color: Colors.orange,
                    size: 12,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Essential',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPermissionCard(
    PermissionRequestConfig config,
    int index,
    bool isDarkMode,
    Color cardColor,
  ) {
    final icon = _getPermissionIcon(config.permission);
    final color = _getPermissionColor(config.permission);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          if (!isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Optional: Show more details about this permission
            _showPermissionDetails(context, config);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon Container
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.2), width: 1),
                  ),
                  child: Center(
                    child: Icon(
                      config.iconAsset != null ? Icons.image : icon,
                      color: color,
                      size: 24,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        children: [
                          Text(
                            config.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? Colors.white
                                  : Colors.grey[900],
                            ),
                          ),
                          if (config.isEssential && widget.showEssentialBadge)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'Required',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.orange,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        config.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode
                              ? Colors.grey[400]
                              : Colors.grey[700],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (config.imageAsset != null)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: AssetImage(config.imageAsset!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Arrow indicator
                const SizedBox(width: 12),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black.withOpacity(0.2) : Colors.transparent,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
                widget.onResult?.call(false);
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                ),
              ),
              child: Text(
                widget.cancelButtonText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                widget.onResult?.call(true);
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 10),
                backgroundColor: widget.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                shadowColor: Colors.transparent,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.allowButtonText,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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

  void _showPermissionDetails(
    BuildContext context,
    PermissionRequestConfig config,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return _PermissionDetailSheet(
          config: config,
          primaryColor: widget.primaryColor,
        );
      },
    );
  }

  IconData _getPermissionIcon(Permission permission) {
    return switch (permission) {
      Permission.camera => Icons.camera_alt_outlined,
      Permission.photos => Icons.photo_library_outlined,
      Permission.location => Icons.location_on_outlined,
      Permission.notification => Icons.notifications_outlined,
      Permission.microphone => Icons.mic_outlined,
      Permission.contacts => Icons.contacts_outlined,
      Permission.storage => Icons.sd_storage_outlined,
      Permission.phone => Icons.phone_outlined,
      Permission.sms => Icons.sms_outlined,
      Permission.calendarWriteOnly => Icons.calendar_today_outlined,
      _ => widget.defaultIcon,
    };
  }

  Color _getPermissionColor(Permission permission) {
    return switch (permission) {
      Permission.camera => const Color(0xFF4361EE),
      Permission.photos => const Color(0xFF3A0CA3),
      Permission.location => const Color(0xFF4CC9F0),
      Permission.notification => const Color(0xFF7209B7),
      Permission.microphone => const Color(0xFFF72585),
      Permission.contacts => const Color(0xFF2EC4B6),
      Permission.storage => const Color(0xFFFF9F1C),
      Permission.phone => const Color(0xFF06D6A0),
      Permission.sms => const Color(0xFF118AB2),
      Permission.calendar => const Color(0xFFEF476F),
      _ => widget.primaryColor,
    };
  }
}

class _PermissionDetailSheet extends StatelessWidget {
  const _PermissionDetailSheet({
    required this.config,
    required this.primaryColor,
  });
  final PermissionRequestConfig config;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final icon = _getPermissionIcon(config.permission);
    final color = _getPermissionColor(config.permission);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: kToolbarHeight,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: color.withOpacity(0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(child: Icon(icon, color: color, size: 28)),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          config.title,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: isDarkMode ? Colors.white : Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Permission Details',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Why this permission is needed:',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      config.description,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (config.isEssential)
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.1),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.priority_high_rounded,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'This permission is essential for core app functionality.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 24),

                    Text(
                      'What we will do with this access:',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isDarkMode ? Colors.white : Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...(config.usases ?? _getUsageDetails(config.permission))
                        .map((detail) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  color: color,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    detail,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Close Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDarkMode ? Colors.grey[800]! : Colors.grey[200]!,
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: color,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Got it',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // const ThemeSwitcher(),
          ],
        ),
      ),
    );
  }

  List<String> _getUsageDetails(Permission permission) {
    return switch (permission) {
      Permission.camera => [
        'Take photos and videos within the app',
        'Scan QR codes and documents',
        'Use camera for augmented reality features',
        'All photos are stored locally on your device',
      ],
      Permission.photos => [
        'Allow you to select existing photos',
        'Save photos you take in the app',
        'Create albums and organize images',
        'No photos are uploaded without your consent',
      ],
      Permission.location => [
        'Show your location on maps',
        'Provide location-based recommendations',
        'Help with navigation and directions',
        'Location data is encrypted and secure',
      ],
      Permission.notification => [
        'Send you important updates and alerts',
        'Notify about new messages and activities',
        'Remind you about scheduled events',
        'You can customize notifications in settings',
      ],
      Permission.microphone => [
        'Record voice messages and notes',
        'Enable voice commands and search',
        'Support voice calls and meetings',
        'Audio is processed locally when possible',
      ],
      Permission.contacts => [
        'Help you find friends on the platform',
        'Sync contacts for easier communication',
        'Create groups from your contact list',
        'Contact data is never shared or sold',
      ],
      _ => [
        'Improve your app experience',
        'Enable specific features and functionality',
        'All data is handled with privacy in mind',
        'You can revoke access anytime in settings',
      ],
    };
  }

  IconData _getPermissionIcon(Permission permission) {
    return switch (permission) {
      Permission.camera => Icons.camera_alt_outlined,
      Permission.photos => Icons.photo_library_outlined,
      Permission.location => Icons.location_on_outlined,
      Permission.notification => Icons.notifications_outlined,
      Permission.microphone => Icons.mic_outlined,
      Permission.contacts => Icons.contacts_outlined,
      _ => Icons.lock_outline,
    };
  }

  Color _getPermissionColor(Permission permission) {
    return switch (permission) {
      Permission.camera => const Color(0xFF4361EE),
      Permission.photos => const Color(0xFF3A0CA3),
      Permission.location => const Color(0xFF4CC9F0),
      Permission.notification => const Color(0xFF7209B7),
      Permission.microphone => const Color(0xFFF72585),
      Permission.contacts => const Color(0xFF2EC4B6),
      _ => primaryColor,
    };
  }
}

/// Helper extension to show permission dialog easily
extension PermissionDialogExtension on BuildContext {
  Future<bool> showPermissionDialog({
    required List<PermissionRequestConfig> configs,
    String title = 'Permissions Required',
    String description =
        'This app needs the following permissions to work properly:',
    String allowButtonText = 'Allow All',
    String cancelButtonText = 'Cancel',
    bool showEssentialBadge = true,
    Color primaryColor = const Color(0xFF4361EE),
    Color backgroundColor = Colors.white,
    Color cardColor = const Color(0xFFF8F9FA),
    double maxDialogHeight = 500,
  }) async {
    return await showDialog<bool>(
          context: this,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) {
            return PermissionRequestDialog(
              configs: configs,
              title: title,
              description: description,
              allowButtonText: allowButtonText,
              cancelButtonText: cancelButtonText,
              showEssentialBadge: showEssentialBadge,
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
              cardColor: cardColor,
              maxDialogHeight: maxDialogHeight,
            );
          },
        ) ??
        false;
  }
}

/// Permission dialog service that can be used without BuildContext
class PermissionDialogService {
  Future<bool> show({
    required List<PermissionRequestConfig> configs,
    GlobalKey<NavigatorState>? navigatorKey,
    String title = 'Permissions Required',
    String description =
        'This app needs the following permissions to work properly:',
    String allowButtonText = 'Allow All',
    String cancelButtonText = 'Cancel',
    bool showEssentialBadge = true,
    Color primaryColor = const Color(0xFF4361EE),
    Color backgroundColor = Colors.white,
    Color cardColor = const Color(0xFFF8F9FA),
    double maxDialogHeight = 500,
  }) async {
    final context = navigatorKey?.currentContext;
    if (context == null) return false;

    return await showDialog<bool>(
          context: context,
          barrierColor: Colors.black.withOpacity(0.5),
          builder: (context) {
            return PermissionRequestDialog(
              configs: configs,
              title: title,
              description: description,
              allowButtonText: allowButtonText,
              cancelButtonText: cancelButtonText,
              showEssentialBadge: showEssentialBadge,
              primaryColor: primaryColor,
              backgroundColor: backgroundColor,
              cardColor: cardColor,
              maxDialogHeight: maxDialogHeight,
            );
          },
        ) ??
        false;
  }
}
