// FEATURE: Sample Screen

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:testable/app/router/app_router.dart';
import 'package:testable/shared/widgets/image_view.dart';

/// A reusable sample screen used across projects for testing routes.
/// It shows current route info, and allows navigating to all defined routes.
class SampleScreen extends ConsumerWidget {
  const SampleScreen({required this.title, required this.color, super.key});
  final String title;
  final Color color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AutoRouter.of(context);
    final currentRoute = router.current.name;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text('$title Screen'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: color.withAlpha(25),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.route, size: 40),
                  const SizedBox(height: 10),
                  Text(
                    'Current Route',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    currentRoute,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Route History:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const AppBreadcrumb(),
          const SizedBox(height: 24),
          Text(
            'Navigate to:',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _navButton('Home', () => router.push(const HomeScreenRoute())),
              _navButton(
                'Profile',
                () => router.push(const ProfileScreenRoute()),
              ),
              _navButton(
                'Settings',
                () => router.push(const SettingsScreenRoute()),
              ),
              _navButton('About', () => router.push(const AboutScreenRoute())),
            ],
          ),

          _images(),
        ],
      ),
    );
  }

  Widget _navButton(String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
      onPressed: onPressed,
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    );
  }

  Widget _images() {
    return Column(
      children: [
        // 1) Network with radius + overlay badge
        ImageView(
          'https://picsum.photos/400',
          width: 140,
          height: 140,
          radius: 16,
          overlay: Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: const EdgeInsets.all(6),
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified, color: Colors.white, size: 14),
            ),
          ),
        ),

        // 2) Circular avatar
        const ImageView(
          'https://picsum.photos/200',
          width: 72,
          height: 72,
          shape: BoxShape.circle,
        ),

        // 3) SVG icon
        const ImageView(
          'assets/icons/heart.svg',
          width: 28,
          height: 28,
          color: Colors.pink,
        ),

        // 4) Lottie
        const ImageView('assets/anim/success.json', width: 80, height: 80),

        // 5) Zoom viewer + hero
        const ImageView(
          'https://picsum.photos/800',
          width: 180,
          height: 120,
          heroTag: 'img-1',
          enableZoomViewer: true,
        ),
      ],
    );
  }
}
