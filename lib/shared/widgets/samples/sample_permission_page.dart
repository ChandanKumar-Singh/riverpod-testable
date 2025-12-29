import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:testable/core/utils/permission_manager/permission_manager.dart';

@RoutePage()
class SamplePermissionsPage extends ConsumerWidget {
  const SamplePermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissionManager = ref.read(permissionManagerProvider);
    final tiles = _buildTiles(permissionManager);

    return Scaffold(
      appBar: AppBar(title: const Text('Permissions')),
      body: ListView.builder(
        itemCount: tiles.length,
        itemBuilder: (_, index) {
          final tile = tiles[index];
          return PermissionTile(
            title: tile.title,
            description: tile.description,
            onTap: () => _handleTap(tile, permissionManager),
          );
        },
      ),
    );
  }

  List<PermissionTileModel> _buildTiles(PermissionManager permissionManager) {
    return const [
      PermissionTileModel(
        title: 'Camera',
        description: 'Required to scan QR codes and capture images.',
        permissions: [Permission.camera],
      ),
      PermissionTileModel(
        title: 'Location',
        description: 'Used to detect your location for nearby services.',
        permissions: [Permission.locationWhenInUse],
      ),
      PermissionTileModel(
        title: 'Notifications',
        description: 'Get important alerts and updates.',
        permissions: [Permission.notification],
        isEssential: false,
      ),
      PermissionTileModel(
        title: 'Storage',
        description: 'Save and access files on your device.',
        permissions: [Permission.storage],
        isEssential: false,
      ),
      PermissionTileModel(
        title: 'Camera + Storage',
        description: 'Required to capture and save photos.',
        permissions: [Permission.camera, Permission.storage],
        permissionConfigs: [
          PermissionRequestConfig(
            permission: Permission.camera,
            title: 'Camera Access',
            description:
                'Allows you to take photos and record videos within the app for profile pictures, sharing moments, scanning documents, and using AR features.',
            // iconAsset: 'assets/icons/camera_permission.png',
            // imageAsset: 'assets/images/camera_permission_preview.png',
            isEssential: false,
            deniedMessage:
                'Camera access is required to take photos or scan QR codes.',
            permanentDenialMessage:
                'Camera access is needed for photo capture. Please enable it in Settings > App Permissions > Camera.',
          ),
          PermissionRequestConfig(
            permission: Permission.storage,
            title: 'Storage Access',
            description:
                'Allows the app to save photos and videos to your device, organize them in albums, and access existing media for editing and sharing.',
            // iconAsset: 'assets/icons/storage_permission.png',
            // imageAsset: 'assets/images/storage_permission_preview.png',
            isEssential: true,
            deniedMessage:
                'Storage access is required to save photos and videos.',
            permanentDenialMessage:
                'Storage access is needed to save your media. Please enable it in Settings > App Permissions > Storage.',
          ),
        ],
      ),
    ];
  }

  Future<void> _handleTap(
    PermissionTileModel tile,
    PermissionManager permissionManager,
  ) async {
    if (tile.permissions.length == 1) {
      await permissionManager.requestSingle(
        config: PermissionRequestConfig(
          permission: tile.permissions.first,
          title: tile.title,
          description: tile.description,
          isEssential: tile.isEssential,
        ),
      );
    } else {
      await permissionManager.requestMultiple(
        configs: tile.permissions
            .map(
              (p) =>
                  tile.permissionConfigs?[tile.permissions.indexOf(p)] ??
                  PermissionRequestConfig(
                    permission: p,
                    title: tile.title,
                    description: tile.description,
                    isEssential: tile.isEssential,
                  ),
            )
            .toList(),
      );
    }
  }
}

class PermissionTileModel {
  const PermissionTileModel({
    required this.title,
    required this.description,
    required this.permissions,
    this.permissionConfigs,
    this.isEssential = true,
  });

  final String title;
  final String description;
  final List<PermissionRequestConfig>? permissionConfigs;
  final List<Permission> permissions;
  final bool isEssential;
}

class PermissionTile extends StatelessWidget {
  const PermissionTile({
    required this.title,
    required this.description,
    required this.onTap,
    super.key,
    this.trailing,
  });

  final String title;
  final String description;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: Text(description),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
