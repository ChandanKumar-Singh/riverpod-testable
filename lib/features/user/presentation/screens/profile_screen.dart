import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/shared/components/index.dart';
import 'package:testable/shared/widgets/loading_widget.dart';
import 'package:testable/shared/widgets/empty_state_widget.dart';
import 'package:testable/shared/widgets/retry_widget.dart';
import 'package:testable/features/user/data/providers/user_provider.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';

@RoutePage()
class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(userProfileProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final res = await UltraDialog.confirm(
                context: context,
                title: 'Logout',
                message: 'Are you sure to logout?',
              );
              unawaited(
                UltraDialog.loading(
                  context: context,
                  message: 'Logging out...',
                  completer: ref.read(authProvider.notifier).logout(),
                ),
              );
            },
          ),
        ],
      ),
      body: profileState.status == UserProfileStatus.loading
          ? const LoadingWidget(message: 'Loading profile...')
          : profileState.status == UserProfileStatus.error
          ? RetryWidget(
              message: profileState.error ?? 'Error loading profile',
              onRetry: () {
                ref.read(userProfileProvider.notifier).loadProfile();
              },
            )
          : profileState.profile != null
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profileState.profile!.avatar != null
                      ? NetworkImage(profileState.profile!.avatar!)
                      : null,
                  child: profileState.profile!.avatar == null
                      ? Text(
                          profileState.profile!.name[0].toUpperCase(),
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  profileState.profile!.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (profileState.profile!.email != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    profileState.profile!.email!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                if (profileState.profile!.phone != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    profileState.profile!.phone!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('User ID'),
                    subtitle: Text(profileState.profile!.id),
                  ),
                ),
                if (authState.user != null) ...[
                  const SizedBox(height: 10),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.email),
                      title: const Text('Email'),
                      subtitle: Text(authState.user!.email ?? 'N/A'),
                    ),
                  ),
                ],
              ],
            )
          : const EmptyStateWidget(
              icon: Icons.person_outline,
              title: 'No Profile',
              message: 'Profile data not available',
            ),
    );
  }
}
