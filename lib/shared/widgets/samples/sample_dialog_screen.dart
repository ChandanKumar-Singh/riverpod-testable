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
  bool _formResult = false;

  void _showBasicDialog() {
    UltraDialog.show(
      context: context,
      header: DialogHeader(
        title: 'Styled Dialog',
        subtitle: 'With custom styling and animations',
        leading: Icon(
          Icons.palette,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Custom Styled Dialog',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'This dialog has custom background, animations, and layout.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
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
      header: DialogHeader(
        title: 'Styled Dialog',
        subtitle: 'With custom styling and animations',
        leading: Icon(
          Icons.palette,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      footer: DialogFooter(
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Confirm'),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Custom Styled Dialog',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
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
        ],
      ),
    );
  }

  Future<void> _showConfirmationDialog() async {
    final confirmed = await UltraDialog.confirm(
      context: context,
      title: 'Delete Item?',
      description:
          'This action cannot be undone. All data will be permanently removed from our servers.',
      destructive: true,
    );

    if (confirmed == true) {
      _showSuccessDialog('Item deleted successfully!');
    } else if (confirmed == false) {
      _showSuccessDialog('Deletion cancelled.');
    }
  }

  Future<void> _showInputDialog() async {
    final result = await UltraDialog.input(
      context: context,
      title: 'Enter Your Name',
      hintText: 'John Doe',
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
      const DialogOption<String>(
        label: 'Flutter Development',
        value: 'flutter',
        subtitle: 'Cross-platform mobile apps',
        icon: Icon(Icons.developer_mode),
      ),
      const DialogOption<String>(
        label: 'UI/UX Design',
        value: 'design',
        subtitle: 'Beautiful user interfaces',
        icon: Icon(Icons.design_services),
      ),
      const DialogOption<String>(
        label: 'Backend Development',
        value: 'backend',
        subtitle: 'Server-side programming',
        icon: Icon(Icons.storage),
      ),
      const DialogOption<String>(
        label: 'DevOps',
        value: 'devops',
        subtitle: 'Infrastructure and deployment',
        icon: Icon(Icons.cloud),
      ),
      const DialogOption<String>(
        label: 'Data Science',
        value: 'data',
        subtitle: 'Machine learning and analytics',
        icon: Icon(Icons.analytics),
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
    );

    // Auto-close after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pop();
        _showSuccessDialog('Operation completed!');
      }
    });
  }

  void _showSuccessDialog(String message) {
    UltraDialog.success(
      context: context,
      title: 'Success!',
      description: message,
    );
  }

  void _showErrorDialog() {
    UltraDialog.error(
      context: context,
      title: 'Connection Error',
      description:
          'Unable to connect to the server. Please check your internet connection and try again.',
      errorDetails:
          'Error Code: 503\nService Unavailable\nTimeout after 30 seconds\nEndpoint: https://api.example.com/data',
    );
  }

  void _showFullScreenDialog() {
    UltraDialog.show(
      context: context,
      type: DialogType.fullScreen,
      backgroundColor: Theme.of(context).colorScheme.surface,
      showCloseButton: true,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
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
                ),
                const SizedBox(width: 12),
                Text(
                  'Full Screen Dialog',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
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
          // Footer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
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
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String title, IconData icon, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
        trailing: Icon(
          Icons.chevron_right,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: () {
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
      enableSwipeToDismiss: true,
      swipeDirection: SwipeDirection.down,
      child: Column(
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
                onPressed: () => _showSuccessDialog('Option 1 selected'),
                child: const Text('Option 1'),
              ),
              FilledButton.tonal(
                onPressed: () => _showSuccessDialog('Option 2 selected'),
                child: const Text('Option 2'),
              ),
              FilledButton.tonal(
                onPressed: () => _showSuccessDialog('Option 3 selected'),
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
    UltraDialog.show(
      context: context,
      type: DialogType.alert,
      size: DialogSize.large,
      scrollable: true,
      header: DialogHeader(
        title: 'Create New Project',
        subtitle: 'Fill in the details for your new project',
        leading: Icon(
          Icons.create_new_folder,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      footer: DialogFooter(
        children: [
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSuccessDialog('Project created successfully!');
            },
            child: const Text('Create Project'),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Project Name',
              hintText: 'Enter project name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Describe your project',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField(
            decoration: const InputDecoration(
              labelText: 'Project Type',
              border: OutlineInputBorder(),
            ),
            items: ['Web App', 'Mobile App', 'Desktop App', 'API', 'Library']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    hintText: 'DD/MM/YYYY',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    hintText: 'DD/MM/YYYY',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text('Team Members'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: const Text('John Doe'), onDeleted: () {}),
              Chip(label: const Text('Jane Smith'), onDeleted: () {}),
              Chip(label: const Text('Mike Johnson'), onDeleted: () {}),
              const Chip(label: Text('+ Add Member')),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UltraDialog Samples'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
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
