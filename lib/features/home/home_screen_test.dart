import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testable/app/localization/locale.dart';
import 'package:testable/app/router/app_router.dart';
import 'package:testable/features/auth/data/models/user_model.dart';
import 'package:testable/features/auth/data/providers/auth_provider.dart';
import 'package:testable/shared/components/index.dart';
import 'package:testable/shared/localization/lang_switcher.dart';
import 'package:testable/shared/theme/theme_switcher.dart';

/// Home screen with navigation to main features
@RoutePage()
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              context.pushRoute(const UserProfileScreenRoute());
            },
          ),
          const LangSwitcher(),
          const ThemeSwitcher(),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Header section
          if (authState.user != null)
            SliverToBoxAdapter(
              child: _buildUserHeader(context, authState.user!, theme),
            ),

          // Features grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 140,
                maxCrossAxisExtent: 150,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              delegate: SliverChildListDelegate([
                _buildFeatureCard(
                  context,
                  title: 'Sheet',
                  icon: Icons.person_2_outlined,
                  color: colorScheme.primary,
                  onTap: () {
                    UltraSheet.show(
                      context: context,
                      child: const Text('Hello UltraSheet ✨'),
                    );

                  }
                      ,
                ),
                _buildFeatureCard(
                  context,
                  title: 'Profile',
                  icon: Icons.person_2_outlined,
                  color: colorScheme.primary,
                  onTap: () =>
                      context.pushRoute(const UserProfileScreenRoute()),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Payments',
                  icon: Icons.payments_outlined,
                  color: colorScheme.secondary,
                  onTap: () => context.pushRoute(const PaymentScreenRoute()),
                ),
                _buildFeatureCard(
                  context,
                  title: 'Settings',
                  icon: Icons.settings_outlined,
                  color: colorScheme.tertiary,
                  onTap: () => context.pushRoute(const SettingsScreenRoute()),
                ),
                _buildFeatureCard(
                  context,
                  title: 'About',
                  icon: Icons.info_outline,
                  color: colorScheme.primaryContainer,
                  onTap: () => context.pushRoute(const AboutScreenRoute()),
                ),
              ]),
            ),
          ),

          // Quick actions section
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Quick Actions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildQuickActionTile(
                  context,
                  title: 'Edit Profile',
                  icon: Icons.edit_outlined,
                  onTap: () =>
                      context.pushRoute(const EditProfileScreenRoute()),
                ),
                _buildQuickActionTile(
                  context,
                  title: 'Security',
                  icon: Icons.security_outlined,
                  onTap: () => context.pushRoute(const SecurityScreenRoute()),
                ),
                _buildQuickActionTile(
                  context,
                  title: 'Notifications',
                  icon: Icons.notifications_outlined,
                  onTap: () =>
                      context.pushRoute(const NotificationsScreenRoute()),
                ),
                _buildQuickActionTile(
                  context,
                  title: 'Alerts',
                  icon: Icons.notifications_outlined,
                  onTap: () =>
                      context.pushRoute(const AlertCardsDemoScreenRoute()),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader(
    BuildContext context,
    UserModel user,
    ThemeData theme,
  ) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              user.name[0].toUpperCase(),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.lang.welcomeBack,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (user.email != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    user.email!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurfaceVariant,
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
