import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:testable/shared/components/index.dart';

@RoutePage()
class SampleDialogScreen extends StatefulWidget {
  const SampleDialogScreen({super.key});

  @override
  State<SampleDialogScreen> createState() => _SampleDialogScreenState();
}

class _SampleDialogScreenState extends State<SampleDialogScreen> {
  String _selectedOption = 'None';
  String _inputResult = 'None';

  void _showBasicDialog() {
    UltraDialog.show(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.palette,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Basic Dialog',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This is a simple dialog using the new UltraDialog API',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  void _showStyledDialog() {
    UltraDialog.show(
      context: context,
      type: DialogType.centered,
      size: DialogSize.medium,
      animationType: DialogAnimation.slideUp,
      blurBackground: true,
      borderRadius: 24,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      showCloseButton: true,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.palette,
            color: Theme.of(context).colorScheme.primary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Styled Dialog',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'This dialog has custom background, animations, and layout.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emoji_objects,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Fully customizable dialog system',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showSuccessDialog('Action confirmed!');
                  },
                  child: const Text('Confirm'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    final confirmed = await UltraDialog.confirm(
      context: context,
      title: 'Delete Item?',
      message:
          'This action cannot be undone. All data will be permanently removed from our servers.',
      destructive: true,
    );

    if (confirmed) {
      _showSuccessDialog('Item deleted successfully!');
    } else {
      _showSuccessDialog('Deletion cancelled.');
    }
  }

  Future<void> _showInputDialog() async {
    final result = await UltraDialog.input(
      context: context,
      title: 'Enter Your Name',
      hint: 'John Doe',
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Please enter your name';
        if (value!.length < 2) return 'Name must be at least 2 characters';
        return null;
      },
    );

    setState(() {
      _inputResult = result ?? 'Cancelled';
    });
  }

  Future<void> _showSelectionDialog() async {
    final options = [
      UltraDialogOption<String>(
        label: 'Flutter Development',
        value: 'flutter',
        subtitle: 'Cross-platform mobile apps',
        icon: Icon(
          Icons.developer_mode,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      UltraDialogOption<String>(
        label: 'UI/UX Design',
        value: 'design',
        subtitle: 'Beautiful user interfaces',
        icon: Icon(
          Icons.design_services,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      UltraDialogOption<String>(
        label: 'Backend Development',
        value: 'backend',
        subtitle: 'Server-side programming',
        icon: Icon(Icons.storage, color: Theme.of(context).colorScheme.primary),
      ),
      UltraDialogOption<String>(
        label: 'DevOps',
        value: 'devops',
        subtitle: 'Infrastructure and deployment',
        icon: Icon(Icons.cloud, color: Theme.of(context).colorScheme.primary),
      ),
      UltraDialogOption<String>(
        label: 'Data Science',
        value: 'data',
        subtitle: 'Machine learning and analytics',
        icon: Icon(
          Icons.analytics,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ];

    final result = await UltraDialog.select(
      context: context,
      title: 'Choose Your Specialty',
      options: options,
      searchable: true,
    );

    setState(() {
      _selectedOption = result?.toString() ?? 'None';
    });
  }

  void _showLoadingDialog() {
    UltraDialog.loading(
      context: context,
      message: 'Processing your request...',
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessDialog(String message) {
    UltraDialog.success(context: context, title: 'Success!', message: message);
  }

  void _showErrorDialog() {
    UltraDialog.error(
      context: context,
      title: 'Connection Error',
      message:
          'Unable to connect to the server. Please check your internet connection and try again.',
      details:
          'Error Code: 503\nService Unavailable\nTimeout after 30 seconds\nEndpoint: https://api.example.com/data',
    );
  }

  void _showFullScreenDialog() {
    UltraDialog.show(
      context: context,
      type: DialogType.fullScreen,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showCloseButton: true,
      headerPadding: EdgeInsets.zero,
      header: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                'Full Screen Dialog',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      builder: (context) => Column(
        children: [
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                children: [
                  _buildFeatureItem(
                    'Advanced Settings',
                    Icons.tune,
                    'Configure all application settings',
                  ),
                  _buildFeatureItem(
                    'User Management',
                    Icons.people,
                    'Manage users and permissions',
                  ),
                  _buildFeatureItem(
                    'Data Export',
                    Icons.download,
                    'Export your data in multiple formats',
                  ),
                  _buildFeatureItem(
                    'Notifications',
                    Icons.notifications,
                    'Configure push notifications',
                  ),
                  _buildFeatureItem(
                    'Security',
                    Icons.security,
                    'Security and privacy settings',
                  ),
                  _buildFeatureItem(
                    'Backup & Restore',
                    Icons.backup,
                    'Backup and restore your data',
                  ),
                  _buildFeatureItem(
                    'Appearance',
                    Icons.palette,
                    'Customize the app look and feel',
                  ),
                  _buildFeatureItem(
                    'About',
                    Icons.info,
                    'App version and information',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Footer
      footer: Container(
        padding: const EdgeInsets.only(top: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).dividerColor),
          ),
        ),
        child: Row(
          children: [
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSuccessDialog('Changes saved successfully!');
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, IconData icon, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: () {
          Navigator.of(context).pop();
          _showSuccessDialog('$title selected');
        },
      ),
    );
  }

  void _showBottomSheetDialog() {
    UltraDialog.show(
      context: context,
      type: DialogType.bottomSheet,
      borderRadius: 24,
      swipeToDismiss: true,
      swipeDirection: SwipeDirection.down,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bottom Sheet Dialog',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'Swipe down to dismiss or use the close button',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSuccessDialog('Option 1 selected');
                },
                child: const Text('Option 1'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSuccessDialog('Option 2 selected');
                },
                child: const Text('Option 2'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showSuccessDialog('Option 3 selected');
                },
                child: const Text('Option 3'),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showComplexFormDialog() {
    String? projectName;
    String? description;
    String? projectType;

    UltraDialog.show(
      context: context,
      type: DialogType.alert,
      size: DialogSize.large,
      showCloseButton: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.create_new_folder,
                      color: Theme.of(context).colorScheme.primary,
                      size: 32,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Project',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Fill in the details for your new project',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Project Name',
                    hintText: 'Enter project name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => projectName = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Describe your project',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) => description = value,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField(
                  decoration: const InputDecoration(
                    labelText: 'Project Type',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      ['Web App', 'Mobile App', 'Desktop App', 'API', 'Library']
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) => setState(() => projectType = value),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showSuccessDialog('Project created successfully!');
                        },
                        child: const Text('Create Project'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UltraDialog Samples')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Results Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dialog Results',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selected Option:',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                              ),
                              Text(
                                _selectedOption,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Input Result:',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withOpacity(0.6),
                                    ),
                              ),
                              Text(
                                _inputResult,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Basic Dialogs Section
            _buildSectionTitle('Basic Dialogs'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: _showBasicDialog,
                  child: const Text('Basic Dialog'),
                ),
                FilledButton.tonal(
                  onPressed: _showStyledDialog,
                  child: const Text('Styled Dialog'),
                ),
                OutlinedButton(
                  onPressed: _showBottomSheetDialog,
                  child: const Text('Bottom Sheet'),
                ),
                OutlinedButton(
                  onPressed: _showFullScreenDialog,
                  child: const Text('Full Screen'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action Dialogs Section
            _buildSectionTitle('Action Dialogs'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: _showConfirmationDialog,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('Confirmation'),
                ),
                FilledButton.tonal(
                  onPressed: _showInputDialog,
                  child: const Text('Input Dialog'),
                ),
                FilledButton.tonal(
                  onPressed: _showSelectionDialog,
                  child: const Text('Selection Dialog'),
                ),
                OutlinedButton(
                  onPressed: _showComplexFormDialog,
                  child: const Text('Form Dialog'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Status Dialogs Section
            _buildSectionTitle('Status Dialogs'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                FilledButton(
                  onPressed: _showLoadingDialog,
                  child: const Text('Loading Dialog'),
                ),
                FilledButton.tonal(
                  onPressed: () =>
                      _showSuccessDialog('Operation completed successfully!'),
                  child: const Text('Success Dialog'),
                ),
                OutlinedButton(
                  onPressed: _showErrorDialog,
                  child: const Text('Error Dialog'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Features Overview
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'UltraDialog Features',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildFeatureItemEmoji('🎨', 'Fully customizable styling'),
                    _buildFeatureItemEmoji('⚡', 'Smooth animations'),
                    _buildFeatureItemEmoji('👆', 'Swipe to dismiss'),
                    _buildFeatureItemEmoji('🎯', 'Multiple dialog types'),
                    _buildFeatureItemEmoji('🔧', 'Pre-built components'),
                    _buildFeatureItemEmoji('📱', 'Responsive design'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildFeatureItemEmoji(String emoji, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
