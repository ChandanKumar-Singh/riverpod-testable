// entities/permission_request_config.dart
part of '../permission_manager.dart';

class PermissionRequestConfig {
  const PermissionRequestConfig({
    required this.permission,
    required this.title,
    required this.description,
    this.iconAsset,
    this.imageAsset,
    this.isEssential = true,
    this.deniedMessage,
    this.permanentDenialMessage,
    this.usases,
  });

  final Permission permission;
  final String title;
  final String description;
  final String? iconAsset;
  final String? imageAsset;
  final bool isEssential;
  final String? deniedMessage;
  final String? permanentDenialMessage;
  final List<String>? usases;

  PermissionRequestConfig copyWith({
    Permission? permission,
    String? title,
    String? description,
    String? iconAsset,
    String? imageAsset,
    bool? isEssential,
    String? deniedMessage,
    String? permanentDenialMessage,
    List<String>? usases,
  }) {
    return PermissionRequestConfig(
      permission: permission ?? this.permission,
      title: title ?? this.title,
      description: description ?? this.description,
      iconAsset: iconAsset ?? this.iconAsset,
      imageAsset: imageAsset ?? this.imageAsset,
      isEssential: isEssential ?? this.isEssential,
      deniedMessage: deniedMessage ?? this.deniedMessage,
      permanentDenialMessage:
          permanentDenialMessage ?? this.permanentDenialMessage,
      usases: usases ?? this.usases,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PermissionRequestConfig &&
          runtimeType == other.runtimeType &&
          permission == other.permission &&
          title == other.title &&
          description == other.description &&
          iconAsset == other.iconAsset &&
          imageAsset == other.imageAsset &&
          isEssential == other.isEssential &&
          deniedMessage == other.deniedMessage &&
          permanentDenialMessage == other.permanentDenialMessage;

  @override
  int get hashCode =>
      permission.hashCode ^
      title.hashCode ^
      description.hashCode ^
      iconAsset.hashCode ^
      imageAsset.hashCode ^
      isEssential.hashCode ^
      deniedMessage.hashCode ^
      permanentDenialMessage.hashCode;

  @override
  String toString() {
    return 'PermissionRequestConfig(permission: $permission, title: $title, isEssential: $isEssential)';
  }
}

/// Pre-defined permission configurations for common use cases
class PermissionConfigs {
  static const camera = PermissionRequestConfig(
    permission: Permission.camera,
    title: 'Camera Access',
    description: 'We need camera access to take photos and scan QR codes',
    isEssential: true,
    deniedMessage: 'Camera access is required for this feature',
    permanentDenialMessage:
        'Please enable camera access in app settings to use this feature',
  );

  static const photos = PermissionRequestConfig(
    permission: Permission.photos,
    title: 'Photo Library Access',
    description:
        'We need access to your photos to let you select and upload images',
    isEssential: false,
    deniedMessage: 'Photo library access is required to select images',
    permanentDenialMessage:
        'Please enable photo library access in app settings',
  );

  static const location = PermissionRequestConfig(
    permission: Permission.location,
    title: 'Location Access',
    description: 'We need your location to provide location-based services',
    isEssential: true,
    deniedMessage: 'Location access is required for this feature',
    permanentDenialMessage: 'Please enable location services in app settings',
  );

  static const notification = PermissionRequestConfig(
    permission: Permission.notification,
    title: 'Notifications',
    description: 'Enable notifications to receive important updates and alerts',
    isEssential: false,
    deniedMessage: 'Notifications are disabled',
    permanentDenialMessage: 'Please enable notifications in app settings',
  );

  static const microphone = PermissionRequestConfig(
    permission: Permission.microphone,
    title: 'Microphone Access',
    description: 'We need microphone access for voice recording and calls',
    isEssential: true,
    deniedMessage: 'Microphone access is required for audio features',
    permanentDenialMessage: 'Please enable microphone access in app settings',
  );

  static const contacts = PermissionRequestConfig(
    permission: Permission.contacts,
    title: 'Contacts Access',
    description:
        'We need access to your contacts to help you connect with friends',
    isEssential: false,
    deniedMessage: 'Contacts access is required for this feature',
    permanentDenialMessage: 'Please enable contacts access in app settings',
  );
}
