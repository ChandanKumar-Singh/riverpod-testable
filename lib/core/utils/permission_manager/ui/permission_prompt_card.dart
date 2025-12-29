// ui/permission_prompt_card.dart
part of '../permission_manager.dart';

class PermissionPromptCard extends StatelessWidget {
  const PermissionPromptCard({
    required this.title,
    required this.description,
    required this.onAllow,
    required this.onDeny,
    super.key,
    this.icon,
    this.isLoading = false,
  });

  final String title;
  final String description;
  final VoidCallback onAllow;
  final VoidCallback onDeny;
  final Widget? icon;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) icon!,
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(description, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            if (isLoading)
              const CircularProgressIndicator()
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: onDeny, child: const Text('Deny')),
                  ElevatedButton(
                    onPressed: onAllow,
                    child: const Text('Allow'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
